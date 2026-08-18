import { useState } from "react";
import { MapWidget } from "./MapWidget";

export function Layout({
  children,
  auth,
  onLogin,
  onLogout,
  data,
  onResolve,
  onSelectAlert,
  getIconConfig,
  onLocate,
  mapCenter
}) {
  const [showAuth, setShowAuth] = useState(false);
  const [authMode, setAuthMode] = useState("login");
  const [signupStep, setSignupStep] = useState(1);
  const [uName, setUName] = useState("");
  const [pwd, setPwd] = useState("");
  const [err, setErr] = useState(false);
  const [showPastRecords, setShowPastRecords] = useState(false);
  const [resolveConfirmId, setResolveConfirmId] =
    useState(null);
  const [resolvedMsg, setResolvedMsg] = useState("");
  const [showConf, setShowConf] = useState(false);

  const handleAuthClose = () => {
    setShowAuth(false);
    setAuthMode("login");
    setSignupStep(1);
    setErr(false);
    setUName("");
    setPwd("");
  };

  const handleLoginSubmit = (e) => {
    e.preventDefault();

    if (
      uName
        .trim()
        .toLowerCase()
        .endsWith("@gmail.com")
    ) {
      onLogin();
      handleAuthClose();
    } else {
      setErr(true);
    }
  };

  const confirmResolve = () => {
    onResolve(resolveConfirmId);

    setResolvedMsg(
      "Live alert successfully marked as resolved!"
    );

    setResolveConfirmId(null);

    setTimeout(() => {
      setResolvedMsg("");
    }, 3000);
  };

  const openRecords = () => {
    if (!auth) {
      setShowAuth(true);
      setAuthMode("login");
      return;
    }

    setShowPastRecords(true);
  };

  const openCurrent = () => {
    setShowPastRecords(false);
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col font-sans">
      <nav className="bg-[#0b1325] text-white px-6 py-4 shadow-md flex justify-between items-center sticky top-0 z-50">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 bg-[#22c55e] rounded-md flex items-center justify-center font-bold text-lg">
            AI
          </div>

          <h1 className="text-xl font-bold tracking-wide">
            RoadGuard AI
          </h1>
        </div>

        <div className="flex items-center gap-8">
          <ul className="flex gap-6 items-center m-0 p-0 list-none">
            <li
              onClick={openCurrent}
              className={`text-sm font-medium cursor-pointer transition-colors ${
                !showPastRecords
                  ? "text-white border-b-2 border-[#22c55e] pb-1 mt-1"
                  : "text-slate-300 hover:text-[#22c55e]"
              }`}
            >
              Current
            </li>

            <li
              onClick={openRecords}
              className={`text-sm font-medium cursor-pointer transition-colors ${
                showPastRecords
                  ? "text-white border-b-2 border-[#22c55e] pb-1 mt-1"
                  : "text-slate-300 hover:text-[#22c55e]"
              }`}
            >
              Records
            </li>
          </ul>

          <div className="flex items-center gap-3">
            {auth ? (
              <button
                onClick={() => setShowConf(true)}
                className="px-4 py-2 bg-transparent border border-slate-500 text-slate-300 hover:text-white hover:border-white rounded-lg text-sm font-medium transition-colors"
              >
                Logout
              </button>
            ) : (
              <>
                <button
                  onClick={() => {
                    setShowAuth(true);
                    setAuthMode("login");
                  }}
                  className="px-5 py-2 bg-transparent border border-slate-500 text-slate-300 hover:text-white hover:border-white rounded-lg text-sm font-medium transition-colors"
                >
                  Login
                </button>

                <button
                  onClick={() => {
                    setShowAuth(true);
                    setAuthMode("signup");
                  }}
                  className="px-5 py-2 bg-[#22c55e] hover:bg-green-600 rounded-lg text-sm font-bold text-white transition-colors shadow-sm"
                >
                  Sign Up
                </button>
              </>
            )}
          </div>
        </div>
      </nav>

      <main className="flex-1 flex flex-col relative">
        {!showPastRecords && children}

        {showPastRecords && (
          <div className="absolute inset-0 bg-slate-50 z-[40] p-6 overflow-y-auto">
            <div className="max-w-7xl mx-auto">
              <div className="mb-6">
                <h2 className="text-2xl font-bold text-slate-800">
                  Records
                </h2>

                <p className="text-slate-500 mt-1">
                  Live road alerts
                </p>
              </div>

              {resolvedMsg && (
                <div className="mb-4 p-3 bg-green-100 text-green-700 rounded-lg border border-green-200 font-medium text-sm flex items-center gap-2">
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

                  {resolvedMsg}
                </div>
              )}

              <div className="grid grid-cols-1 lg:grid-cols-5 gap-4">
                <div className="lg:col-span-3 bg-white h-[38rem] rounded-xl shadow-sm border border-slate-200 overflow-hidden">
                  <MapWidget
                    data={data}
                    setSel={(item) =>
                      onSelectAlert({
                        ...item,
                        recordMode: true
                      })
                    }
                    center={mapCenter}
                  />
                </div>

                <div className="lg:col-span-2">
                  <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-4 flex flex-col h-[38rem]">
                    <div className="flex justify-between items-center mb-4 sticky top-0 bg-white pb-2 border-b border-slate-100 z-10">
                      <div>
                        <h3 className="font-semibold text-slate-800">
                          Live Alerts
                        </h3>

                        <p className="text-xs text-slate-400 mt-1">
                          Current road issues
                        </p>
                      </div>

                      <span className="text-xs font-semibold bg-red-50 text-red-600 px-2 py-1 rounded-full">
                        {data?.length || 0} Active
                      </span>
                    </div>

                    <div className="flex-1 overflow-y-auto pr-2 custom-scrollbar">
                      <ul className="flex flex-col gap-4">
                        {data?.length > 0 ? (
                          data.map((item) => {
                            const iconData =
                              getIconConfig(item.type);

                            return (
                              <li
                                key={item.id}
                                onClick={() =>
                                  onSelectAlert({
                                    ...item,
                                    recordMode: true
                                  })
                                }
                                className="group bg-white rounded-xl border border-slate-100 shadow-sm flex gap-3.5 p-3.5 cursor-pointer hover:border-slate-300 hover:shadow-md transition-all active:scale-[0.98]"
                              >
                                <div
                                  className={`w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0 border ${iconData.bg} ${iconData.text} ${iconData.border}`}
                                >
                                  {iconData.svg}
                                </div>

                                <div className="flex-1 min-w-0">
                                  <div className="flex justify-between items-start mb-1">
                                    <span className="font-bold capitalize text-slate-800 text-[15px] truncate">
                                      {item.type}
                                    </span>

                                    {item.sev && (
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
                                    )}
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

                                  <div className="mt-3 pt-3 border-t border-slate-100">
                                    <button
                                      onClick={(e) => {
                                        e.stopPropagation();
                                        setResolveConfirmId(
                                          item.id
                                        );
                                      }}
                                      className="w-full bg-[#22c55e] hover:bg-green-600 text-white px-4 py-2.5 rounded-lg text-xs font-semibold shadow-sm transition-colors"
                                    >
                                      Mark as Resolved
                                    </button>
                                  </div>
                                </div>
                              </li>
                            );
                          })
                        ) : (
                          <li className="text-center py-10 text-slate-400 text-sm">
                            No live alerts found.
                          </li>
                        )}
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {resolveConfirmId && (
              <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center z-[99999] p-4">
                <div className="bg-white rounded-lg shadow-xl p-6 w-full max-w-sm text-center">
                  <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
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
                  </div>

                  <h3 className="text-lg font-bold text-slate-800 mb-2">
                    Resolve Issue?
                  </h3>

                  <p className="text-slate-600 text-sm mb-6">
                    Are you sure you want to mark this live alert as resolved?
                  </p>

                  <div className="flex gap-3">
                    <button
                      onClick={() =>
                        setResolveConfirmId(null)
                      }
                      className="px-4 py-2 bg-slate-100 text-slate-700 rounded hover:bg-slate-200 font-medium text-sm transition-colors w-full"
                    >
                      Cancel
                    </button>

                    <button
                      onClick={confirmResolve}
                      className="px-4 py-2 bg-[#22c55e] text-white rounded hover:bg-green-600 font-medium text-sm transition-colors w-full"
                    >
                      Mark as Resolved
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}
      </main>

      {showAuth && !auth && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden relative">
            <button
              onClick={handleAuthClose}
              className="absolute top-4 right-4 text-slate-400 hover:text-slate-800"
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

            <div className="p-8">
              {authMode === "login" && (
                <>
                  <h2 className="text-2xl font-bold text-slate-800 mb-6">
                    Welcome Back
                  </h2>

                  <form
                    onSubmit={handleLoginSubmit}
                    className="flex flex-col gap-4"
                  >
                    <div>
                      <label className="block text-sm font-medium text-slate-600 mb-1">
                        Email Address
                      </label>

                      <input
                        type="email"
                        value={uName}
                        onChange={(e) =>
                          setUName(e.target.value)
                        }
                        required
                        className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#0b1325]"
                        placeholder="admin@gmail.com"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-slate-600 mb-1">
                        Password
                      </label>

                      <input
                        type="password"
                        value={pwd}
                        onChange={(e) =>
                          setPwd(e.target.value)
                        }
                        required
                        className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#0b1325]"
                        placeholder="••••••••"
                      />
                    </div>

                    {err && (
                      <p className="text-red-500 text-xs font-medium">
                        Email must end with @gmail.com.
                      </p>
                    )}

                    <button
                      type="submit"
                      className="mt-2 w-full py-2.5 bg-[#0b1325] text-white rounded-lg font-medium hover:bg-slate-800 transition-colors"
                    >
                      Log In
                    </button>
                  </form>

                  <p className="mt-6 text-center text-sm text-slate-500">
                    Don't have an account?{" "}
                    <button
                      onClick={() =>
                        setAuthMode("signup")
                      }
                      className="text-[#0b1325] font-bold hover:underline"
                    >
                      Sign up
                    </button>
                  </p>
                </>
              )}

              {authMode === "signup" && (
                <>
                  <h2 className="text-2xl font-bold text-slate-800 mb-2">
                    Create Account
                  </h2>

                  <p className="text-sm text-slate-500 mb-6">
                    Step {signupStep} of 3
                  </p>

                  <form
                    onSubmit={(e) => {
                      e.preventDefault();

                      if (signupStep < 3) {
                        setSignupStep(
                          (prev) => prev + 1
                        );
                      } else {
                        handleLoginSubmit(e);
                      }
                    }}
                    className="flex flex-col gap-4"
                  >
                    {signupStep === 1 && (
                      <>
                        <div>
                          <label className="block text-sm font-medium text-slate-600 mb-1">
                            Email Address
                          </label>

                          <input
                            type="email"
                            required
                            className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg"
                            placeholder="you@gmail.com"
                          />
                        </div>

                        <div>
                          <label className="block text-sm font-medium text-slate-600 mb-1">
                            Phone Number
                          </label>

                          <input
                            type="tel"
                            required
                            className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg"
                            placeholder="+91 9876543210"
                          />
                        </div>

                        <button
                          type="submit"
                          className="mt-2 w-full py-2.5 bg-[#22c55e] text-white rounded-lg font-medium hover:bg-green-600 transition-colors"
                        >
                          Send OTP
                        </button>
                      </>
                    )}

                    {signupStep === 2 && (
                      <>
                        <div>
                          <label className="block text-sm font-medium text-slate-600 mb-1">
                            Enter OTP
                          </label>

                          <input
                            type="text"
                            required
                            maxLength="6"
                            className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg text-center"
                            placeholder="••••••"
                          />
                        </div>

                        <button
                          type="submit"
                          className="mt-2 w-full py-2.5 bg-[#22c55e] text-white rounded-lg font-medium hover:bg-green-600 transition-colors"
                        >
                          Verify OTP
                        </button>

                        <button
                          type="button"
                          onClick={() =>
                            setSignupStep(1)
                          }
                          className="text-sm text-slate-500"
                        >
                          Back
                        </button>
                      </>
                    )}

                    {signupStep === 3 && (
                      <>
                        <div>
                          <label className="block text-sm font-medium text-slate-600 mb-1">
                            Set Email
                          </label>

                          <input
                            type="text"
                            value={uName}
                            onChange={(e) =>
                              setUName(e.target.value)
                            }
                            required
                            className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg"
                            placeholder="you@gmail.com"
                          />
                        </div>

                        <div>
                          <label className="block text-sm font-medium text-slate-600 mb-1">
                            Set Password
                          </label>

                          <input
                            type="password"
                            value={pwd}
                            onChange={(e) =>
                              setPwd(e.target.value)
                            }
                            required
                            className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg"
                          />
                        </div>

                        <button
                          type="submit"
                          className="mt-2 w-full py-2.5 bg-[#0b1325] text-white rounded-lg font-medium"
                        >
                          Complete Registration
                        </button>
                      </>
                    )}
                  </form>
                </>
              )}
            </div>
          </div>
        </div>
      )}

      {showConf && (
        <div className="fixed inset-0 bg-slate-900/50 flex items-center justify-center z-[100] p-4">
          <div className="bg-white rounded-lg shadow-xl p-6 w-full max-w-sm text-center">
            <h3 className="text-lg font-bold text-slate-800 mb-2">
              Are you sure you want to log out?
            </h3>

            <p className="text-slate-600 text-sm mb-6">
              You will need to enter your credentials again to sign back in.
            </p>

            <div className="flex gap-3 justify-center">
              <button
                onClick={() => setShowConf(false)}
                className="px-4 py-2 bg-slate-100 text-slate-700 rounded hover:bg-slate-200 font-medium text-sm transition-colors"
              >
                Cancel
              </button>

              <button
                onClick={() => {
                  setShowConf(false);
                  onLogout();
                }}
                className="px-4 py-2 bg-[#22c55e] text-white rounded hover:bg-green-600 font-medium text-sm transition-colors shadow-sm"
              >
                Yes, Logout
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}