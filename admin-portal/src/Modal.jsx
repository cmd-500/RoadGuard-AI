import { useState, useEffect } from "react";
import {
  MapContainer,
  TileLayer,
  CircleMarker
} from "react-leaflet";

export function Modal({
  obj,
  close,
  action,
  onLocate
}) {
  const [confirmType, setConfirmType] =
    useState(null);

  useEffect(() => {
    setConfirmType(null);
  }, [obj]);

  if (!obj) return null;

  const recordMode = obj.recordMode === true;

  const handleAction = () => {
    if (
      confirmType === "dismiss" ||
      confirmType === "verify" ||
      confirmType === "resolve"
    ) {
      action(obj.id, confirmType);
    }
  };

  return (
    <div className="fixed inset-0 z-[70] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl overflow-hidden relative flex flex-col md:flex-row">
        <div className="md:w-1/2 h-64 md:h-auto relative bg-slate-100">
          <img
            src={obj.img}
            alt={obj.type}
            className="absolute inset-0 w-full h-full object-cover"
          />

          <div className="absolute top-4 left-4 bg-black/70 backdrop-blur-md text-white px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider z-10">
            Live Feed
          </div>
        </div>

        <div className="md:w-1/2 p-6 flex flex-col relative">
          <button
            onClick={close}
            className="absolute top-4 right-4 text-slate-400 hover:text-slate-800 z-50"
          >
            <svg
              className="w-5 h-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={2}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>

          <div className="flex justify-between items-start mb-6 mt-2">
            <div className="min-w-0 pr-3">
              <h3 className="text-2xl font-bold text-slate-800 capitalize mb-1">
                {obj.type}
              </h3>

              <p className="text-slate-500 text-sm">
                {obj.loc}
              </p>
            </div>

            <div className="flex flex-col items-center mr-2 mt-1 flex-shrink-0">
              <div
                className="w-16 h-16 border-2 border-slate-200 rounded shadow-sm overflow-hidden cursor-pointer relative group"
                onClick={() =>
                  onLocate(obj.lat, obj.lng)
                }
                title="View on main map"
              >
                <div className="absolute inset-0 z-[400] bg-black/10 group-hover:bg-black/0 transition-colors" />

                <MapContainer
                  center={[obj.lat, obj.lng]}
                  zoom={13}
                  zoomControl={false}
                  dragging={false}
                  scrollWheelZoom={false}
                  doubleClickZoom={false}
                  style={{
                    width: "100%",
                    height: "100%"
                  }}
                >
                  <TileLayer
                    url="https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png"
                  />

                  <CircleMarker
                    center={[
                      obj.lat,
                      obj.lng
                    ]}
                    radius={4}
                    pathOptions={{
                      color: "#ef4444",
                      fillColor: "#ef4444",
                      fillOpacity: 0.9,
                      weight: 2
                    }}
                  />
                </MapContainer>
              </div>

              <span className="text-[9px] text-slate-500 font-bold mt-1 tracking-wider">
                LOCATION MAP
              </span>
            </div>
          </div>

          <div className="space-y-4 mb-6 flex-1">
            <div className="bg-slate-50 p-3 rounded-lg border border-slate-100">
              <p className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">
                Time Detected
              </p>

              <p className="text-sm font-medium text-slate-700">
                {obj.date} at {obj.time}
              </p>
            </div>

            <div className="bg-slate-50 p-3 rounded-lg border border-slate-100">
              <p className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">
                AI Confidence
              </p>

              <p className="text-sm font-medium text-slate-700">
                {obj.aiConf}
              </p>
            </div>

            <div className="bg-slate-50 p-3 rounded-lg border border-slate-100">
              <p className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">
                Status
              </p>

              <div className="flex items-center gap-2">
                <div className="w-5 h-5 rounded-full bg-green-500 flex items-center justify-center flex-shrink-0">
                  <svg
                    className="w-3 h-3 text-white"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    strokeWidth={3}
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M5 12l4 4L19 6"
                    />
                  </svg>
                </div>

                <p className="text-sm font-medium text-slate-700">
                  {obj.statusMsg}
                </p>
              </div>
            </div>
          </div>

          {!recordMode && (
            <div className="flex gap-2">
              <button
                onClick={() =>
                  setConfirmType("verify")
                }
                className="flex-1 py-2.5 bg-[#0b1325] text-white rounded-lg font-medium hover:bg-slate-800 transition-colors shadow-sm"
              >
                Mark as Verified
              </button>

              <button
                onClick={() =>
                  setConfirmType("dismiss")
                }
                className="flex-1 py-2.5 bg-slate-200 text-slate-600 rounded-lg font-medium hover:bg-slate-300 transition-colors shadow-sm"
              >
                Dismiss
              </button>
            </div>
          )}

          {recordMode && (
            <div className="w-full py-2.5 bg-green-50 text-green-700 rounded-lg font-semibold text-center text-sm border border-green-200">
              ✓ Verified Record
            </div>
          )}

          {confirmType && (
            <div className="absolute inset-0 bg-white/95 backdrop-blur-sm flex flex-col items-center justify-center p-6 z-10">
              <div className="w-12 h-12 rounded-full bg-slate-100 flex items-center justify-center mb-4">
                {confirmType === "resolve" ? (
                  <svg
                    className="w-6 h-6 text-green-500"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    strokeWidth={2}
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M5 13l4 4L19 7"
                    />
                  </svg>
                ) : (
                  <svg
                    className="w-6 h-6 text-slate-600"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    strokeWidth={2}
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M12 9v2m0 4h.01"
                    />

                    <circle
                      cx="12"
                      cy="12"
                      r="9"
                    />
                  </svg>
                )}
              </div>

              <h4 className="text-lg font-bold text-slate-800 mb-2">
                Confirm Action
              </h4>

              <p className="text-center text-slate-600 text-sm mb-6">
                Are you sure you want to{" "}
                {confirmType === "verify"
                  ? "verify"
                  : confirmType === "dismiss"
                    ? "dismiss"
                    : "mark as resolved"}{" "}
                this {obj.type} alert?
              </p>

              <div className="flex gap-3 w-full">
                <button
                  onClick={() =>
                    setConfirmType(null)
                  }
                  className="flex-1 py-2 bg-slate-100 text-slate-600 rounded-lg font-medium hover:bg-slate-200 transition-colors"
                >
                  Cancel
                </button>

                <button
                  onClick={handleAction}
                  className={`flex-1 py-2 text-white rounded-lg font-medium transition-colors ${
                    confirmType === "verify"
                      ? "bg-[#0b1325] hover:bg-slate-800"
                      : confirmType === "resolve"
                        ? "bg-[#22c55e] hover:bg-green-600"
                        : "bg-slate-500 hover:bg-slate-600"
                  }`}
                >
                  Confirm
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}