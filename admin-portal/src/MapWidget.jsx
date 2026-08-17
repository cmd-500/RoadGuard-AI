import { useEffect, useState } from "react";
// IMPORTANT: Assuming you are using 'react-leaflet'.
// If not installed, run: npm install react-leaflet leaflet
import { MapContainer, TileLayer, CircleMarker, Popup, Tooltip } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';

export function MapWidget({ data, setSel }) {
  // Center map generally around Greater Noida / NCR region based on your mock data
  const center = [28.47, 77.50];

  return (
      <div className="w-full h-full relative bg-slate-100 z-0">
        <MapContainer
            center={center}
            zoom={12}
            style={{ width: '100%', height: '100%' }}
            zoomControl={false}
        >
          <TileLayer
              url="https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png"
              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
          />

          {/*
          This loops through real-time data.
          Markers are placed precisely at item.lat and item.lng.
        */}
          {data.map((item) => {
            // Determine color based on severity (Red for High, Yellow/Orange for Med/Low)
            const color = item.sev === 'high' ? '#ef4444' : item.sev === 'med' ? '#f59e0b' : '#3b82f6';
            const radius = item.sev === 'high' ? 12 : 8;

            return (
                <CircleMarker
                    key={item.id}
                    center={[item.lat, item.lng]}
                    pathOptions={{
                      color: color,
                      fillColor: color,
                      fillOpacity: 0.7,
                      weight: 2
                    }}
                    radius={radius}
                    eventHandlers={{
                      click: () => setSel(item), // Opens the modal when clicked
                    }}
                >
                  <Tooltip direction="top" offset={[0, -10]} opacity={1}>
                    <span className="font-bold capitalize">{item.type}</span>
                  </Tooltip>
                </CircleMarker>
            );
          })}
        </MapContainer>

        {/* Map Legend */}
        <div className="absolute bottom-4 left-4 bg-white/90 backdrop-blur p-3 rounded-lg shadow-lg border border-slate-200 z-[400] text-sm">
          <h4 className="font-bold text-slate-800 mb-2">Live Sensors</h4>
          <div className="flex flex-col gap-2">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-red-500 border-2 border-red-200"></div>
              <span className="text-slate-600">High Severity</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-amber-500 border-2 border-amber-200"></div>
              <span className="text-slate-600">Medium Severity</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-blue-500 border-2 border-blue-200"></div>
              <span className="text-slate-600">Low Severity</span>
            </div>
          </div>
        </div>
      </div>
  );
}