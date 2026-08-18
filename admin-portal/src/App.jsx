import { useState, useEffect } from "react";
import { Layout } from "./Layout";
import { MapWidget } from "./MapWidget";
import { Stats } from "./Stats";
import { Modal } from "./Modal";

export default function App() {
  const [auth, setAuth] = useState(false);
  const [data, setData] = useState([]);
  const [filter, setFilter] = useState("all");
  const [sel, setSel] = useState(null);
  const [loginPrompt, setLoginPrompt] = useState(false);
  const [mapCenter, setMapCenter] = useState(null);

  useEffect(() => {
    const generateAlert = (type, index) => {
      const sevs = ["high", "med", "low"];

      const locations = [
        "NH 48, Near Sector 62, Noida, UP",
        "Knowledge Park III, Greater Noida, UP",
        "Yamuna Expressway, Sector 150",
        "Pari Chowk, Greater Noida, UP",
        "Eastern Peripheral Expy, Greater Noida"
      ];

      const statuses = [
        "Work has been assigned to the maintenance team.",
        "Issue logged. Pending AI verification.",
        "Team dispatched to location."
      ];

      const images = {
        pothole:
          "https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?auto=format&fit=crop&w=600&q=80",
        crack:
          "https://images.unsplash.com/photo-1584858548983-9b88931126cd?auto=format&fit=crop&w=600&q=80",
        waterlogging:
          "https://images.unsplash.com/photo-1518182170546-076616fd4aa3?auto=format&fit=crop&w=600&q=80",
        "speed breaker":
          "https://images.unsplash.com/photo-1580901556858-62021665aef3?auto=format&fit=crop&w=600&q=80",
        fog:
          "https://images.unsplash.com/photo-1485236715568-ddc5ee6ca227?auto=format&fit=crop&w=600&q=80",
        landslide:
          "https://images.unsplash.com/photo-1605378772845-6677f5024da9?auto=format&fit=crop&w=600&q=80",
        cyclone:
          "https://images.unsplash.com/photo-1527482797697-8795b05a13fe?auto=format&fit=crop&w=600&q=80"
      };

      const aiConfidences = [
        "74.1%",
        "88.5%",
        "92.3%",
        "65.8%",
        "98.1%"
      ];

      const aiStatusMsgs = [
        "Manual Admin Override Req.",
        "Verified automatically",
        "Needs Community Consensus"
      ];

      const d = new Date();

      return {
        id: Date.now() + index + Math.random(),
        type,
        sev: sevs[Math.floor(Math.random() * sevs.length)],
        lat: 28.47 + (Math.random() * 0.04 - 0.02),
        lng: 77.5 + (Math.random() * 0.04 - 0.02),
        time: d.toLocaleTimeString([], {
          hour: "2-digit",
          minute: "2-digit"
        }),
        date: d.toLocaleDateString("en-GB", {
          day: "2-digit",
          month: "short",
          year: "numeric"
        }),
        loc: locations[Math.floor(Math.random() * locations.length)],
        statusMsg:
          statuses[Math.floor(Math.random() * statuses.length)],
        img: images[type],
        aiConf:
          aiConfidences[
            Math.floor(Math.random() * aiConfidences.length)
          ],
        aiStatus:
          aiStatusMsgs[
            Math.floor(Math.random() * aiStatusMsgs.length)
          ]
      };
    };

    const alertTypes = [
      "pothole",
      "crack",
      "waterlogging",
      "landslide",
      "fog",
      "speed breaker",
      "cyclone"
    ];

    setData(
      alertTypes.map((type, index) =>
        generateAlert(type, index)
      )
    );
  }, []);

  const handleFix = (id) => {
    setData((prev) =>
      prev.filter((item) => item.id !== id)
    );
    setSel(null);
  };

  const handleLocate = (lat, lng) => {
    setMapCenter([lat, lng]);
    setSel(null);
  };

  const getIconConfig = (type) => {
    switch (type) {
      case "pothole":
        return {
          bg: "bg-red-50",
          text: "text-red-500",
          border: "border-red-100",
          svg: (
            <svg
              className="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.7}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
              />
            </svg>
          )
        };

      case "crack":
        return {
          bg: "bg-orange-50",
          text: "text-orange-500",
          border: "border-orange-100",
          svg: (
            <svg
              className="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.7}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M10 2l-2 5 4 3-3 5 5 4-1 3"
              />
            </svg>
          )
        };

      case "waterlogging":
        return {
          bg: "bg-blue-50",
          text: "text-blue-500",
          border: "border-blue-100",
          svg: (
            <svg
              className="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.7}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M2.25 15c2.5 0 2.5-2 5-2s2.5 2 5 2 2.5-2 5-2 2.5 2 5 2M2.25 19c2.5 0 2.5-2 5-2s2.5 2 5 2 2.5-2 5-2 2.5 2 5 2"
              />
            </svg>
          )
        };

      case "landslide":
        return {
          bg: "bg-amber-50",
          text: "text-amber-700",
          border: "border-amber-200",
          svg: (
            <svg
              className="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.7}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M3 21l8-14 4 7m4-2l3 5H3z"
              />
            </svg>
          )
        };

      case "fog":
        return {
          bg: "bg-slate-100",
          text: "text-slate-500",
          border: "border-slate-200",
          svg: (
            <svg
              className="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.7}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M4 16h16M4 20h16M7 12h10M8 8a4 4 0 017.33-2.33 3 3 0 014.67 2.33H8z"
              />
            </svg>
          )
        };

      case "speed breaker":
        return {
          bg: "bg-yellow-50",
          text: "text-yellow-600",
          border: "border-yellow-100",
          svg: (
            <svg
              className="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.7}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M4 16c3.5-5 8.5-5 12 0M4 19h16"
              />
            </svg>
          )
        };

      case "cyclone":
        return {
          bg: "bg-teal-50",
          text: "text-teal-600",
          border: "border-teal-200",
          svg: (
            <svg
              className="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.7}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M4 6h16M6 10h12M8 14h8M10 18h4"
              />
            </svg>
          )
        };

      default:
        return {
          bg: "bg-gray-50",
          text: "text-gray-400",
          border: "border-gray-100",
          svg: null
        };
    }
  };

  const res =
    filter === "all"
      ? data
      : data.filter((d) => d.sev === filter);

  const tot = data.length;
  const high = data.filter(
    (d) => d.sev === "high"
  ).length;

  return (
    <>
      <Layout
        auth={auth}
        onLogin={() => setAuth(true)}
        onLogout={() => setAuth(false)}
        data={data}
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
                    data={res}
                    setSel={setSel}
                    center={mapCenter}
                  />
                </div>

                <div className="lg:col-span-1 flex flex-col gap-4">
                  <Stats data={res} />

                  <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-4 flex flex-col h-[27rem]">
                    <div className="flex justify-between items-center mb-4 sticky top-0 bg-white pb-2 border-b border-slate-100 z-10">
                      <h3 className="font-semibold text-slate-800">
                        Live Alerts
                      </h3>

                      <span className="text-xs font-semibold bg-red-50 text-red-600 px-2 py-1 rounded-full">
                        {res.length} Active
                      </span>
                    </div>

                    <div className="flex-1 overflow-y-auto pr-2 custom-scrollbar">
                      <ul className="flex flex-col gap-4">
                        {res.map((item) => {
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

                        {res.length === 0 && (
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