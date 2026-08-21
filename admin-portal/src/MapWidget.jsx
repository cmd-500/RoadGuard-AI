import { useEffect } from "react";
import { MapContainer, TileLayer, CircleMarker, Tooltip, useMap, Marker } from 'react-leaflet';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

const pinIcon = new L.DivIcon({
  className: 'bg-transparent',
  html: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#ea4335" width="40px" height="40px" style="filter: drop-shadow(0px 4px 4px rgba(0,0,0,0.3));"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>`,
  iconSize: [40, 40],
  iconAnchor: [20, 40]
});

function MapUpdater({ center }) {
  const map = useMap();

  useEffect(() => {
    if (center) {
      map.flyTo(center, 15, { duration: 1.5 });
    }
  }, [center, map]);

  return null;
}

export function MapWidget({ data, setSel, center }) {
  const defaultCenter = [28.47, 77.50];

  return (
      <div className="w-full h-full relative bg-slate-100 z-0">
        <MapContainer
            center={defaultCenter}
            zoom={12}
            style={{ width: '100%', height: '100%' }}
            zoomControl={false}
        >
          <MapUpdater center={center} />

          <TileLayer
              url="https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png"
              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          />

          {data.map((item) => {
            const color = item.sev === 'high' ? '#ef4444' : item.sev === 'med' ? '#f59e0b' : '#3b82f6';
            const radius = item.sev === 'high' ? 12 : 8;

            return (
                <CircleMarker
                    key={item.id}
                    center={[item.lat, item.lng]}
                    pathOptions={{ color: color, fillColor: color, fillOpacity: 0.7, weight: 2 }}
                    radius={radius}
                    eventHandlers={{ click: () => setSel(item) }}
                >
                  <Tooltip direction="top" offset={[0, -10]} opacity={1}>
                    <span className="font-bold capitalize">{item.type}</span>
                  </Tooltip>
                </CircleMarker>
            );
          })}

          {center && (
              <Marker position={center} icon={pinIcon} />
          )}
        </MapContainer>

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