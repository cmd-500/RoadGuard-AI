import { useState, useEffect, useCallback } from "react";
import { Layout } from "./Layout";
import { MapWidget } from "./MapWidget";
import { Stats } from "./Stats";
import { Modal } from "./Modal";

const API_BASE = "http://localhost:8080/api/v1";

function typeFromBackend(type) {
  const map = {
    POTHOLE: "pothole",
    ACCIDENT: "accident",
    WATERLOGGING: "waterlogging",
    SPEED_BREAKER: "speed breaker",
    FOG: "fog",
    CONSTRUCTION: "landslide",
    EMERGENCY: "cyclone",
    OTHER: "other",
  };
  return map[type] || type.toLowerCase();
}

function typeToBackend(type) {
  const map = {
    pothole: "POTHOLE",
    accident: "ACCIDENT",
    waterlogging: "WATERLOGGING",
    "speed breaker": "SPEED_BREAKER",
    fog: "FOG",
    landslide: "CONSTRUCTION",
    cyclone: "EMERGENCY",
    other: "OTHER",
  };
  return map[type] || type.toUpperCase();
}

function sevFromBackend(sev) {

  const map = { CRITICAL: "high", HIGH: "high", MEDIUM: "med", LOW: "low" };
  return map[sev] || "low";
}

function statusFromBackend(status) {
  const map = {
    PENDING: "pending",
    IN_PROGRESS: "inprogress",
    RESOLVED: "resolved",
    REJECTED: "rejected",
  };
  return map[status] || "pending";
}

function formatDate(dateStr) {
  const d = new Date(dateStr);
  return {
    date: d.toLocaleDateString("en-GB", { day: "2-digit", month: "short", year: "numeric" }),
    time: d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
  };
}

function getIconConfig(type) {
  const configs = {
    pothole: {
      bg: "bg-red-100",
      text: "text-red-600",
      border: "border-red-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <ellipse cx="12" cy="13" rx="7" ry="4.5" strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 10.5l1.5 2M15 10l-1.2 2.3M11 15.5l1-2" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3.5 6.5l2 1.5M20.5 6.5l-2 1.5" />
          </svg>
      ),
    },
    accident: {
      bg: "bg-amber-100",
      text: "text-amber-600",
      border: "border-amber-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 16v-2.5L5 9h9l3 4.5V16M3 16h14M3 16v2M17 16v2" />
            <circle cx="6.5" cy="16.5" r="1.5" strokeWidth={2} />
            <circle cx="14.5" cy="16.5" r="1.5" strokeWidth={2} />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M18.5 4l1.5 2-1.5 2M21 6h-4" />
          </svg>
      ),
    },
    waterlogging: {
      bg: "bg-blue-100",
      text: "text-blue-600",
      border: "border-blue-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 9c1.5-1.5 3-1.5 4.5 0s3 1.5 4.5 0 3-1.5 4.5 0 3 1.5 4.5 0" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 14c1.5-1.5 3-1.5 4.5 0s3 1.5 4.5 0 3-1.5 4.5 0 3 1.5 4.5 0" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 19c1.5-1.5 3-1.5 4.5 0s3 1.5 4.5 0 3-1.5 4.5 0 3 1.5 4.5 0" />
          </svg>
      ),
    },
    "speed breaker": {
      bg: "bg-purple-100",
      text: "text-purple-600",
      border: "border-purple-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2 17c2-4 5-6 10-6s8 2 10 6" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} strokeDasharray="2 2" d="M4 20h16" />
          </svg>
      ),
    },
    fog: {
      bg: "bg-slate-100",
      text: "text-slate-600",
      border: "border-slate-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <circle cx="12" cy="7" r="2.5" strokeWidth={2} />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 12h18M4 16h16M6 20h12" />
          </svg>
      ),
    },
    landslide: {
      bg: "bg-orange-100",
      text: "text-orange-600",
      border: "border-orange-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 19l5-9 3.5 5L15 9l6 10H3z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 4l1 1.5M20 5l-1 1.5" />
          </svg>
      ),
    },
    cyclone: {
      bg: "bg-indigo-100",
      text: "text-indigo-600",
      border: "border-indigo-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3a9 9 0 109 9M12 3a5 5 0 105 5M12 3a1.5 1.5 0 101.5 1.5" />
          </svg>
      ),
    },
    other: {
      bg: "bg-teal-100",
      text: "text-teal-600",
      border: "border-teal-200",
      svg: (

          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4l9 16H3l9-16z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 10v4" />
            <circle cx="12" cy="17" r="0.9" fill="currentColor" stroke="none" />
          </svg>
      ),
    },
  };
  return configs[type] || configs.other;
}

export default function App() {
  const [auth, setAuth] = useState(() => localStorage.getItem("roadguard_auth") === "true");
  const [data, setData] = useState([]);
  const [filter, setFilter] = useState("all");
  const [sel, setSel] = useState(null);
  const [loginPrompt, setLoginPrompt] = useState(false);
  const [mapCenter, setMapCenter] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [records, setRecords] = useState([]);

  const fetchRecords = useCallback(async () => {
    try {
      const params = new URLSearchParams();
      params.append("status", "RESOLVED");

      const res = await fetch(`${API_BASE}/reports?${params.toString()}`, {
        headers: { "Content-Type": "application/json" },
      });

      if (!res.ok) throw new Error("Failed to fetch records");

      const json = await res.json();
      const reports = json.content || json.data || json.reports || (Array.isArray(json) ? json : []);

      const mapped = reports.map((r) => {
        const { date, time } = formatDate(r.createdAt);
        return {
          id: r.id,
          type: typeFromBackend(r.hazardType),
          sev: sevFromBackend(r.severity),
          lat: r.latitude,
          lng: r.longitude,
          time: time,
          date: date,
          loc: r.address,
          statusMsg: "Verified",
          img: r.imageUrl,
          aiConf: "95%",
          aiStatus: "Verified",
          communityStatus: r.communityStatus,
          reportStatus: r.status,
          voteScore: r.voteScore,
          creator: r.createdBy,
          distanceMeters: r.distanceMeters,
        };
      });

      setRecords(mapped);
    } catch (e) {
      console.error("Failed to load records:", e);
    }
  }, []);

  const fetchReports = useCallback(async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (filter !== "all") params.append("hazardType", typeToBackend(filter));

      const res = await fetch(`${API_BASE}/reports?${params.toString()}`, {
        headers: { "Content-Type": "application/json" },
      });

      if (!res.ok) throw new Error("Failed to fetch reports");

      const json = await res.json();

      const reports = json.content || json.data || json.reports || (Array.isArray(json) ? json : []);

      const mapped = reports
          .filter(r => r.status === "PENDING" || r.status === "IN_PROGRESS")
          .map((r) => {
            const { date, time } = formatDate(r.createdAt);
            return {
              id: r.id,
              type: typeFromBackend(r.hazardType),
              sev: sevFromBackend(r.severity),
              lat: r.latitude,
              lng: r.longitude,
              time: time,
              date: date,
              loc: r.address,
              statusMsg: r.status === "IN_PROGRESS" ? "Work in progress" : "Pending review",
              img: r.imageUrl,
              aiConf: "95%",
              aiStatus: "Verified",
              communityStatus: r.communityStatus,
              reportStatus: r.status,
              voteScore: r.voteScore,
              creator: r.createdBy,
              distanceMeters: r.distanceMeters,
            };
          });

      setData(mapped);
      setError(null);
    } catch (e) {
      setError("Failed to load reports");
    } finally {
      setLoading(false);
    }
  }, [filter]);

  useEffect(() => {
    fetchReports();
    fetchRecords();
    const interval = setInterval(() => {
      fetchReports();
      fetchRecords();
    }, 30000);
    return () => clearInterval(interval);
  }, [fetchReports, fetchRecords]);

  const tot = data.length;
  const high = data.filter(d => d.sev === "high").length;

  const handleFix = async (id, actionType = "resolve") => {
    const statusMap = {
      verify: "RESOLVED",
      dismiss: "REJECTED",
      resolve: "RESOLVED",
    };
    const status = statusMap[actionType] || "RESOLVED";

    try {
      const res = await fetch(`${API_BASE}/reports/${id}/status`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status }),
      });
      if (!res.ok) throw new Error(`Status update failed (${res.status})`);

      // Report is no longer pending/in-progress, so it always leaves the
      // Live Alerts list. If it was verified/resolved, it now belongs in Records.
      setData((prev) => prev.filter((item) => item.id !== id));
      if (status === "RESOLVED") {
        fetchRecords();
      }
      setSel(null);
    } catch (e) {
      console.error("Failed to update report status:", e);
    }
  };

  const handleLocate = (lat, lng) => {
    setMapCenter([lat, lng]);
    setSel(null);
  };

  return (
      <>
        <Layout
            auth={auth}
            onLogin={() => {
              localStorage.setItem("roadguard_auth", "true");
              setAuth(true);
            }}
            onLogout={() => {
              localStorage.removeItem("roadguard_auth");
              setAuth(false);
            }}
            data={data}
            records={records}
            onResolve={handleFix}
            onSelectAlert={setSel}
            getIconConfig={getIconConfig}
            onLocate={handleLocate}
            mapCenter={mapCenter}
        >
          <div className="relative h-full w-full overflow-y-auto overflow-x-hidden pb-12 pt-6">
            {loginPrompt && !auth && (
                <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-900/30 backdrop-blur-sm">
                  <div className="bg-white rounded-lg shadow-xl p-6 w-full max-w-sm text-center">
                    <div className="w-12 h-12 bg-[#0b1325] text-white rounded-full flex items-center justify-center text-2xl mx-auto mb-4">
                      <svg
                          className="w-6 h-6"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                      >
                        <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth={2}
                            d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                        />
                      </svg>
                    </div>

                    <h3 className="text-lg font-bold text-slate-800 mb-2">
                      Authentication Required
                    </h3>

                    <p className="text-slate-600 text-sm mb-6">
                      Please sign in from the top navigation bar to interact with the dashboard.
                    </p>

                    <button
                        onClick={() => setLoginPrompt(false)}
                        className="px-6 py-2 bg-[#22c55e] text-white rounded hover:bg-green-600 font-medium text-sm transition-colors shadow-sm"
                    >
                      Understood
                    </button>
                  </div>
                </div>
            )}

            <div className="relative max-w-7xl mx-auto px-4">
              {!auth && (
                  <div
                      className="absolute inset-0 z-[40]"
                      onClick={() => setLoginPrompt(true)}
                  />
              )}

              <div
                  className={`transition-all duration-700 ease-in-out ${
                      !auth ? "pointer-events-none" : ""
                  }`}
              >
                <header className="mb-6 flex flex-col md:flex-row md:items-center justify-between gap-4 pt-1">
                  <div>
                    <h2 className="text-2xl font-semibold text-slate-800">
                      Dashboard Overview
                    </h2>

                    <p className="text-slate-500">
                      Total Anomalies: {tot} | High Severity: {high}
                    </p>
                  </div>

                  <div className="flex gap-2">
                    {["all", "high", "med", "low"].map((f) => (
                        <button
                            key={f}
                            onClick={() => setFilter(f)}
                            className={`px-3 py-1.5 rounded-lg capitalize text-sm font-medium border transition-colors shadow-sm ${
                                filter === f
                                    ? "bg-[#0b1325] text-white border-[#0b1325]"
                                    : "bg-white text-slate-600 border-slate-300 hover:bg-slate-50"
                            }`}
                        >
                          {f}
                        </button>
                    ))}
                  </div>
                </header>

                <div className="grid grid-cols-1 lg:grid-cols-4 gap-4">
                  <div className="lg:col-span-3 bg-white h-[38rem] rounded-xl shadow-sm border border-slate-200 overflow-hidden">
                    <MapWidget
                        data={data}
                        setSel={setSel}
                        center={mapCenter}
                    />
                  </div>

                  <div className="lg:col-span-1 flex flex-col gap-4">
                    <Stats data={data} />

                    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-4 flex flex-col h-[27rem]">
                      <div className="flex justify-between items-center mb-4 sticky top-0 bg-white pb-2 border-b border-slate-100 z-10">
                        <h3 className="font-semibold text-slate-800">
                          Live Alerts
                        </h3>

                        <span className="text-xs font-semibold bg-red-50 text-red-600 px-2 py-1 rounded-full">
                        {data.length} Active
                      </span>
                      </div>

                      <div className="flex-1 overflow-y-auto pr-2 custom-scrollbar">
                        <ul className="flex flex-col gap-4">
                          {data.map((item) => {
                            const iconData =
                                getIconConfig(item.type);

                            return (
                                <li
                                    key={item.id}
                                    onClick={() => setSel(item)}
                                    className="group bg-white rounded-xl border border-slate-100 shadow-sm flex gap-3.5 p-3.5 cursor-pointer hover:border-slate-300 hover:shadow-md transition-all active:scale-[0.98]"
                                >
                                  <div
                                      className={`w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0 border ${iconData.bg} ${iconData.text} ${iconData.border}`}
                                  >
                                    {iconData.svg}
                                  </div>

                                  <div className="flex-1 min-w-0">
                                    <div className="flex justify-between items-start mb-1">
                                  <span className="font-bold capitalize text-slate-800 text-[14px] truncate">
                                    {item.type}
                                  </span>

                                      <span
                                          className={`text-[10px] font-bold uppercase px-1.5 py-0.5 rounded ${
                                              item.sev === "high"
                                                  ? "bg-red-50 text-red-600"
                                                  : item.sev === "med"
                                                      ? "bg-amber-50 text-amber-600"
                                                      : "bg-blue-50 text-blue-600"
                                          }`}
                                      >
                                    {item.sev}
                                  </span>
                                    </div>

                                    <p className="text-[12px] text-slate-500 truncate">
                                      {item.loc}
                                    </p>
                                    <p className="text-[11px] text-slate-400 mt-1">
                                      {item.date} • {item.time}
                                    </p>

                                    <div className="flex items-center gap-1.5 mt-2">
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

                                      <p className="text-[11px] text-slate-600 truncate">
                                        {item.statusMsg}
                                      </p>
                                    </div>
                                  </div>
                                </li>
                            );
                          })}
                          {data.length === 0 && (
                              <li className="text-slate-400 text-sm text-center py-8 font-medium">
                                No alerts currently.
                              </li>
                          )}
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Layout>

        <Modal
            obj={sel}
            close={() => setSel(null)}
            action={handleFix}
            onLocate={handleLocate}
        />
      </>
  );
}