package com.roadguard.backend.util;

import org.apache.commons.imaging.ImageReadException;
import org.apache.commons.imaging.Imaging;
import org.apache.commons.imaging.common.ImageMetadata;
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata;
import org.apache.commons.imaging.formats.jpeg.exif.ExifRewriter;
import org.apache.commons.imaging.formats.tiff.TiffField;
import org.apache.commons.imaging.formats.tiff.TiffImageMetadata;
import org.apache.commons.imaging.formats.tiff.constants.ExifTagConstants;
import org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants;
import org.apache.commons.imaging.formats.tiff.write.TiffOutputSet;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Component
public class ImageVerificationUtil {

    private static final int BLUR_VARIANCE_THRESHOLD = 80;
    private static final int GPS_MISMATCH_THRESHOLD_METERS = 500;

    public record ExifGps(double latitude, double longitude) {}

    public record VerificationResult(
            boolean isBlurry,
            double blurScore,
            String imageHash,
            ExifGps exifGps
    ) {}

    public VerificationResult analyze(byte[] imageBytes) {
        double blurScore = computeBlurScore(imageBytes);
        boolean isBlurry = blurScore < BLUR_VARIANCE_THRESHOLD;
        String imageHash = computeImageHash(imageBytes);
        ExifGps exifGps = extractExifGps(imageBytes);

        return new VerificationResult(isBlurry, blurScore, imageHash, exifGps);
    }

    private double computeBlurScore(byte[] imageBytes) {
        try (InputStream is = new ByteArrayInputStream(imageBytes)) {
            BufferedImage image = Imaging.getBufferedImage(is);
            if (image == null) return 0;

            // Convert to grayscale
            BufferedImage gray = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_BYTE_GRAY);
            Graphics g = gray.getGraphics();
            g.drawImage(image, 0, 0, null);
            g.dispose();

            // Laplacian variance for blur detection
            int width = gray.getWidth();
            int height = gray.getHeight();
            double sum = 0;
            double sumSq = 0;
            int count = 0;

            for (int y = 1; y < height - 1; y++) {
                for (int x = 1; x < width - 1; x++) {
                    int center = gray.getRGB(x, y) & 0xFF;
                    int laplacian = (gray.getRGB(x-1, y) & 0xFF) +
                            (gray.getRGB(x+1, y) & 0xFF) +
                            (gray.getRGB(x, y-1) & 0xFF) +
                            (gray.getRGB(x, y+1) & 0xFF) -
                            4 * center;
                    sum += laplacian;
                    sumSq += laplacian * laplacian;
                    count++;
                }
            }

            double mean = sum / count;
            return sumSq / count - mean * mean;

        } catch (IOException | ImageReadException e) {
            return 0;
        }
    }

    private String computeImageHash(byte[] imageBytes) {
        try {
            BufferedImage image = Imaging.getBufferedImage(new ByteArrayInputStream(imageBytes));
            if (image == null) return "";

            // Resize to 32x32 for perceptual hash
            BufferedImage resized = new BufferedImage(32, 32, BufferedImage.TYPE_BYTE_GRAY);
            Graphics g = resized.getGraphics();
            g.drawImage(image, 0, 0, 32, 32, null);
            g.dispose();

            // Compute average
            long sum = 0;
            for (int y = 0; y < 32; y++) {
                for (int x = 0; x < 32; x++) {
                    sum += resized.getRGB(x, y) & 0xFF;
                }
            }
            double avg = sum / 1024.0;

            // Build hash
            StringBuilder hash = new StringBuilder();
            for (int y = 0; y < 32; y++) {
                for (int x = 0; x < 32; x++) {
                    hash.append((resized.getRGB(x, y) & 0xFF) >= avg ? "1" : "0");
                }
            }

            // Convert to hex
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(hash.toString().getBytes());
            return bytesToHex(hashBytes).substring(0, 16);

        } catch (IOException | ImageReadException | NoSuchAlgorithmException e) {
            return "";
        }
    }

    public int hammingDistance(String hash1, String hash2) {
        if (hash1.length() != hash2.length()) return Integer.MAX_VALUE;
        int distance = 0;
        for (int i = 0; i < hash1.length(); i++) {
            if (hash1.charAt(i) != hash2.charAt(i)) distance++;
        }
        return distance;
    }

    public ExifGps extractExifGps(byte[] imageBytes) {
        try {
            ImageMetadata metadata = Imaging.getMetadata(imageBytes);
            if (metadata instanceof JpegImageMetadata jpegMetadata) {
                TiffImageMetadata exif = jpegMetadata.getExif();
                if (exif != null) {
                    TiffField latRef = exif.findField(GpsTagConstants.GPS_TAG_GPS_LATITUDE_REF);
                    TiffField lat = exif.findField(GpsTagConstants.GPS_TAG_GPS_LATITUDE);
                    TiffField lngRef = exif.findField(GpsTagConstants.GPS_TAG_GPS_LONGITUDE_REF);
                    TiffField lng = exif.findField(GpsTagConstants.GPS_TAG_GPS_LONGITUDE);

                    if (latRef != null && lat != null && lngRef != null && lng != null) {
                        double latitude = convertToDegrees(lat);
                        double longitude = convertToDegrees(lng);

                        if ("S".equals(latRef.getStringValue())) latitude = -latitude;
                        if ("W".equals(lngRef.getStringValue())) longitude = -longitude;

                        return new ExifGps(latitude, longitude);
                    }
                }
            }
        } catch (IOException | ImageReadException e) {
            // No EXIF GPS data
        }
        return null;
    }

    private double convertToDegrees(TiffField field) throws ImageReadException {
        Object val = field.getValue();
        if (val instanceof Number[]) {
            Number[] parts = (Number[]) val;
            if (parts.length >= 3) {
                return parts[0].doubleValue() + parts[1].doubleValue() / 60.0 + parts[2].doubleValue() / 3600.0;
            }
        }
        return 0;
    }

    public double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371000; // Earth radius in meters
        double phi1 = Math.toRadians(lat1);
        double phi2 = Math.toRadians(lat2);
        double deltaPhi = Math.toRadians(lat2 - lat1);
        double deltaLambda = Math.toRadians(lon2 - lon1);

        double a = Math.sin(deltaPhi / 2) * Math.sin(deltaPhi / 2) +
                Math.cos(phi1) * Math.cos(phi2) *
                Math.sin(deltaLambda / 2) * Math.sin(deltaLambda / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c;
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}