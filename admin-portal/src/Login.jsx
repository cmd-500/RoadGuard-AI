import { useState } from "react";

export const Login = ({ setAuth }) => {
  const [user, setUser] = useState("");
  const [pwd, setPwd] = useState("");
  const [err, setErr] = useState(false);

  const handleSub = (e) => {
    e.preventDefault();
    // Simple mock authentication for the hackathon demo
    if (user === "admin" && pwd === "admin") {
      setAuth(true);
    } else {
      setErr(true);
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 flex items-center justify-center p-4">
      <div className="bg-white p-8 rounded-lg shadow-xl w-full max-w-sm">
        <h1 className="text-2xl font-bold text-slate-800 text-center mb-6">
          <span className="text-blue-600">RoadMon</span> Admin
        </h1>
        
        <form onSubmit={handleSub} className="flex flex-col gap-4">
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Username</label>
            <input 
              type="text" 
              value={user}
              onChange={(e) => setUser(e.target.value)}
              className="w-full border border-slate-300 rounded px-3 py-2 focus:outline-none focus:border-blue-500"
              placeholder="admin"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Password</label>
            <input 
              type="password" 
              value={pwd}
              onChange={(e) => setPwd(e.target.value)}
              className="w-full border border-slate-300 rounded px-3 py-2 focus:outline-none focus:border-blue-500"
              placeholder="••••••••"
            />
          </div>
          
          {err && <p className="text-red-500 text-xs font-medium">Invalid credentials. Use admin / admin.</p>}
          
          <button 
            type="submit" 
            className="w-full bg-blue-600 text-white font-medium py-2 rounded hover:bg-blue-700 transition-colors mt-2"
          >
            Sign In
          </button>
        </form>
      </div>
    </div>
  );
};