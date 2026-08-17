import { useState, useEffect } from "react";

export function Modal({ obj, close, action }) {
  const [confirmType, setConfirmType] = useState(null); // 'dismiss', 'verify', 'resolve'

  // Reset confirmation state if the modal closes or opens a different object
  useEffect(() => {
    setConfirmType(null);
  }, [obj]);

  if (!obj) return null;

  const handleAction = () => {
    // Only "resolve" actually removes it from the list as requested,
    // but you can easily apply it to all by removing the if-condition
    if (confirmType === 'resolve' || confirmType === 'dismiss' || confirmType === 'verify') {
      action(obj.id); // Removes from App.jsx state
    }
  };

  return (
      <div className="fixed inset-0 z-[70] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
        <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl overflow-hidden relative flex flex-col md:flex-row">

          {/* Left Side - Dynamic Image
            In a real backend setup, obj.img will contain the live URL from your database
            Example: <img src={obj.liveCameraImageUrl} /> */}
          <div className="md:w-1/2 h-64 md:h-auto relative bg-slate-100">
            <img
                src={obj.img}
                alt={obj.type}
                className="absolute inset-0 w-full h-full object-cover"
            />
            <div className="absolute top-4 left-4 bg-black/70 backdrop-blur-md text-white px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider">
              Live Feed
            </div>
          </div>

          {/* Right Side - Details & Actions */}
          <div className="md:w-1/2 p-6 flex flex-col relative">
            <button onClick={close} className="absolute top-4 right-4 text-slate-400 hover:text-slate-800">
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>

            <div className="mb-6 mt-2">
              <h3 className="text-2xl font-bold text-slate-800 capitalize mb-1">{obj.type}</h3>
              <p className="text-slate-500 text-sm">{obj.loc}</p>
            </div>

            <div className="space-y-4 mb-8 flex-1">
              <div className="bg-slate-50 p-3 rounded-lg border border-slate-100">
                <p className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">Time Detected</p>
                <p className="text-sm font-medium text-slate-700">{obj.date} at {obj.time}</p>
              </div>
              <div className="bg-slate-50 p-3 rounded-lg border border-slate-100">
                <p className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">AI Confidence</p>
                <p className="text-sm font-medium text-slate-700">{obj.aiConf}</p>
              </div>
            </div>

            {/* Action Buttons Section */}
            <div className="flex flex-col gap-2">
              <button onClick={() => setConfirmType('resolve')} className="w-full py-2.5 bg-[#22c55e] text-white rounded-lg font-medium hover:bg-green-600 transition-colors shadow-sm">
                Mark as Resolved
              </button>
              <div className="flex gap-2">
                <button onClick={() => setConfirmType('verify')} className="flex-1 py-2.5 bg-[#0b1325] text-white rounded-lg font-medium hover:bg-slate-800 transition-colors shadow-sm">
                  Mark as Verified
                </button>
                <button onClick={() => setConfirmType('dismiss')} className="flex-1 py-2.5 bg-slate-200 text-slate-600 rounded-lg font-medium hover:bg-slate-300 transition-colors shadow-sm">
                  Dismiss
                </button>
              </div>
            </div>

            {/* Confirmation Dialogue Overlay */}
            {confirmType && (
                <div className="absolute inset-0 bg-white/95 backdrop-blur-sm flex flex-col items-center justify-center p-6 z-10">
                  <h4 className="text-lg font-bold text-slate-800 mb-2">Confirm Action</h4>
                  <p className="text-center text-slate-600 text-sm mb-6">
                    Are you sure you want to {confirmType === 'resolve' ? 'resolve' : confirmType === 'verify' ? 'verify' : 'dismiss'} this {obj.type} alert?
                  </p>
                  <div className="flex gap-3 w-full">
                    <button onClick={() => setConfirmType(null)} className="flex-1 py-2 bg-slate-100 text-slate-600 rounded-lg font-medium hover:bg-slate-200 transition-colors">
                      Cancel
                    </button>
                    <button onClick={handleAction} className={`flex-1 py-2 text-white rounded-lg font-medium transition-colors ${
                        confirmType === 'resolve' ? 'bg-[#22c55e] hover:bg-green-600' :
                            confirmType === 'verify' ? 'bg-[#0b1325] hover:bg-slate-800' :
                                'bg-slate-500 hover:bg-slate-600'
                    }`}>
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