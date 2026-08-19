package com.roadguard.backend.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.Transformation;
import com.cloudinary.utils.ObjectUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CloudinaryService {

    private final Cloudinary cloudinary;

    @Value("${cloudinary.cloud-name}")
    private String cloudName;

    public UploadResult uploadImage(MultipartFile file) {
        try {
            Transformation transformation = new Transformation()
                    .width(1600)
                    .crop("limit")
                    .quality("auto");

            Map<String, Object> params = ObjectUtils.asMap(
                    "folder", "roadguard/reports",
                    "resource_type", "image",
                    "transformation", transformation
            );

            Map<?, ?> result = cloudinary.uploader().upload(file.getBytes(), params);

            return new UploadResult(
                    (String) result.get("secure_url"),
                    (String) result.get("public_id")
            );
        } catch (IOException e) {
            throw new RuntimeException("Failed to upload image", e);
        }
    }

    public void deleteImage(String publicId) {
        try {
            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        } catch (IOException e) {
            throw new RuntimeException("Failed to delete image", e);
        }
    }

    public record UploadResult(String secureUrl, String publicId) {}
}