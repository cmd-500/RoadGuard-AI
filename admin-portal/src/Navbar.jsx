import { useState } from "react";

export const Navbar = ({ auth, onLogin, onLogout }) => {
  const [uName, setUName] = useState("");
  const [pwd, setPwd] = useState("");
  const [err, setErr] = useState(false);
  const [showConf, setShowConf] = useState(false);
  const [showLogin, setShowLogin] = useState(false);

  const doLogin = (e) => {
    e.preventDefault();
    if (uName === "admin" && pwd === "admin") {
      onLogin();
      setErr(false);
      setUName("");
      setPwd("");
      setShowLogin(false);
    } else {
      setErr(true);
    }
  };

  // Removed "Alerts" and "Settings" from this list
  const navLinks = ["Dashboard"];

  return (
      <>
        <nav className="bg-[#0b1325] text-white px-6 py-3 flex justify-between items-center shadow-md z-50 relative">
          {/* Left Side: Brand Logo & Tagline */}
          <div className="flex items-center gap-3">
            <div className="bg-[#22c55e] p-2 rounded-lg flex items-center justify-center">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" /></svg>
            </div>
            <div className="flex flex-col">
              <h1 className="text-2xl font-bold tracking-tight leading-none">Road<span className="text-[#22c55e]">Safe</span></h1>
              <span className="text-[10px] text-slate-400 mt-0.5">Safer Roads, Smarter Journeys</span>
            </div>
          </div>

          {/* Right Side: Links AND Buttons Grouped Together */}
          <div className="flex items-center gap-8">

            {/* Navigation Links */}
            <ul className="hidden lg:flex gap-6 items-center">
              {navLinks.map((item, idx) => (
                  <li
                      key={idx}
                      className={`text-sm font-medium cursor-pointer transition-colors ${item === 'Dashboard' ? 'text-white border-b-2 border-[#22c55e] pb-1 mt-1' : 'text-slate-300 hover:text-[#22c55e]'}`}
                  >
                    {item}
                  </li>
              ))}
            </ul>

            {/* Action Buttons */}
            <div className="flex items-center gap-3">
              {auth ? (
                  <button
                      onClick={() => setShowConf(true)}
                      className="bg-transparent border border-slate-500 text-slate-300 hover:text-white hover:border-white px-5 py-2 rounded text-sm font-medium transition-colors"
                  >
                    Logout
                  </button>
              ) : (
                  <>
                    <button
                        onClick={() => setShowLogin(true)}
                        className="bg-transparent border border-slate-500 text-slate-300 hover:text-white hover:border-white px-5 py-2 rounded text-sm font-medium transition-colors"
                    >
                      Login
                    </button>
                    <button
                        onClick={() => setShowLogin(true)}
                        className="bg-[#22c55e] hover:bg-green-600 text-white px-5 py-2 rounded text-sm font-bold transition-colors shadow-sm"
                    >
                      Sign Up
                    </button>
                  </>
              )}
            </div>
          </div>
        </nav>

        {/* The Login Dialogue Box */}
        {showLogin && (
            <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center z-[99999] p-4">
              <div className="bg-white rounded-lg shadow-xl p-6 w-full max-w-sm">
                <div className="flex justify-between items-center mb-6">
                  <h3 className="text-xl font-bold text-slate-800">Admin Login</h3>
                  <button onClick={() => setShowLogin(false)} className="text-slate-400 hover:text-slate-800 font-bold px-2">✕</button>
                </div>
                <form onSubmit={doLogin} className="flex flex-col gap-4">
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-1">Username</label>
                    <input type="text" value={uName} onChange={(e) => setUName(e.target.value)} className="w-full border border-slate-300 rounded px-3 py-2 focus:outline-none focus:border-[#22c55e] text-slate-800" placeholder="admin" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-1">Password</label>
                    <input type="password" value={pwd} onChange={(e) => setPwd(e.target.value)} className="w-full border border-slate-300 rounded px-3 py-2 focus:outline-none focus:border-[#22c55e] text-slate-800" placeholder="••••••••" />
                  </div>
                  {err && <p className="text-red-500 text-xs font-medium">Invalid credentials. Use admin / admin.</p>}
                  <button type="submit" className="w-full bg-[#22c55e] text-white font-medium py-2 rounded hover:bg-green-600 transition-colors mt-2">Login</button>
                </form>
              </div>
            </div>
        )}

        {/* Logout Confirmation Dialog */}
        {showConf && (
            <div className="fixed inset-0 bg-slate-900/50 flex items-center justify-center z-[99999] p-4">
              <div className="bg-white rounded-lg shadow-xl p-6 w-full max-w-sm text-center">
                <h3 className="text-lg font-bold text-slate-800 mb-2">Are you sure you want to log out?</h3>
                <p className="text-slate-600 text-sm mb-6">You will need to enter your credentials again to sign back in.</p>
                <div className="flex gap-3 justify-center">
                  <button onClick={() => setShowConf(false)} className="px-4 py-2 bg-slate-100 text-slate-700 rounded hover:bg-slate-200 font-medium text-sm transition-colors">Cancel</button>
                  <button onClick={() => { setShowConf(false); onLogout(); }} className="px-4 py-2 bg-[#22c55e] text-white rounded hover:bg-green-600 font-medium text-sm transition-colors shadow-sm">Yes, Logout</button>
                </div>
              </div>
            </div>
        )}
      </>
  );
};