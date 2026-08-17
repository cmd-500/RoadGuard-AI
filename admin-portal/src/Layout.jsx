import { useState } from "react";

export function Layout({ children, auth, onLogin, onLogout }) {
    const [showAuth, setShowAuth] = useState(false);
    const [authMode, setAuthMode] = useState("login"); // 'login', 'signup', 'forgot'
    const [signupStep, setSignupStep] = useState(1); // 1: Details, 2: OTP, 3: Password

    const handleAuthClose = () => {
        setShowAuth(false);
        setAuthMode("login");
        setSignupStep(1);
    };

    const handleLoginSubmit = (e) => {
        e.preventDefault();
        onLogin();
        handleAuthClose();
    };

    return (
        <div className="min-h-screen bg-slate-50 flex flex-col font-sans">
            <nav className="bg-[#0b1325] text-white px-6 py-4 shadow-md flex justify-between items-center sticky top-0 z-50">
                <div className="flex items-center gap-3">
                    <div className="w-8 h-8 bg-[#22c55e] rounded-md flex items-center justify-center font-bold text-lg">
                        AI
                    </div>
                    <h1 className="text-xl font-bold tracking-wide">RoadGuard AI</h1>
                </div>

                <div>
                    {auth ? (
                        <button onClick={onLogout} className="px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg text-sm font-medium transition-colors">
                            Sign Out
                        </button>
                    ) : (
                        <button onClick={() => setShowAuth(true)} className="px-5 py-2 bg-[#22c55e] hover:bg-green-600 rounded-lg text-sm font-medium transition-colors shadow-sm">
                            Sign In / Register
                        </button>
                    )}
                </div>
            </nav>

            <main className="flex-1 flex flex-col relative">
                {children}
            </main>

            {/* Auth Modal */}
            {showAuth && !auth && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden relative">
                        <button onClick={handleAuthClose} className="absolute top-4 right-4 text-slate-400 hover:text-slate-800">
                            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" /></svg>
                        </button>

                        <div className="p-8">
                            {/* --- LOGIN FLOW --- */}
                            {authMode === "login" && (
                                <>
                                    <h2 className="text-2xl font-bold text-slate-800 mb-6">Welcome Back</h2>
                                    <form onSubmit={handleLoginSubmit} className="flex flex-col gap-4">
                                        <div>
                                            <label className="block text-sm font-medium text-slate-600 mb-1">User ID / Email</label>
                                            <input type="text" required className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#0b1325]" placeholder="Enter your User ID" />
                                        </div>
                                        <div>
                                            <div className="flex justify-between mb-1">
                                                <label className="block text-sm font-medium text-slate-600">Password</label>
                                                <button type="button" onClick={() => setAuthMode("forgot")} className="text-sm text-[#22c55e] hover:underline font-medium">Forgot?</button>
                                            </div>
                                            <input type="password" required className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#0b1325]" placeholder="••••••••" />
                                        </div>
                                        <button type="submit" className="mt-2 w-full py-2.5 bg-[#0b1325] text-white rounded-lg font-medium hover:bg-slate-800 transition-colors">
                                            Log In
                                        </button>
                                    </form>
                                    <p className="mt-6 text-center text-sm text-slate-500">
                                        Don't have an account? <button onClick={() => setAuthMode("signup")} className="text-[#0b1325] font-bold hover:underline">Sign up</button>
                                    </p>
                                </>
                            )}

                            {/* --- SIGNUP FLOW --- */}
                            {authMode === "signup" && (
                                <>
                                    <h2 className="text-2xl font-bold text-slate-800 mb-2">Create Account</h2>
                                    <p className="text-sm text-slate-500 mb-6">Step {signupStep} of 3</p>

                                    <form onSubmit={(e) => { e.preventDefault(); if(signupStep < 3) setSignupStep(prev => prev + 1); else handleLoginSubmit(e); }} className="flex flex-col gap-4">

                                        {/* Step 1: Contact Details */}
                                        {signupStep === 1 && (
                                            <>
                                                <div>
                                                    <label className="block text-sm font-medium text-slate-600 mb-1">Email Address</label>
                                                    <input type="email" required className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#22c55e]" placeholder="you@example.com" />
                                                </div>
                                                <div>
                                                    <label className="block text-sm font-medium text-slate-600 mb-1">Phone Number</label>
                                                    <input type="tel" required className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#22c55e]" placeholder="+91 9876543210" />
                                                </div>
                                                <button type="submit" className="mt-2 w-full py-2.5 bg-[#22c55e] text-white rounded-lg font-medium hover:bg-green-600 transition-colors">Send OTP</button>
                                            </>
                                        )}

                                        {/* Step 2: OTP */}
                                        {signupStep === 2 && (
                                            <>
                                                <div>
                                                    <label className="block text-sm font-medium text-slate-600 mb-1">Enter OTP</label>
                                                    <p className="text-xs text-slate-400 mb-2">We sent a 6-digit code to your phone/email.</p>
                                                    <input type="text" required maxLength="6" className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#22c55e] text-center tracking-[0.5em] font-bold text-lg" placeholder="••••••" />
                                                </div>
                                                <button type="submit" className="mt-2 w-full py-2.5 bg-[#22c55e] text-white rounded-lg font-medium hover:bg-green-600 transition-colors">Verify OTP</button>
                                                <button type="button" onClick={() => setSignupStep(1)} className="text-sm text-slate-500 hover:text-slate-800">Back</button>
                                            </>
                                        )}

                                        {/* Step 3: Set Password */}
                                        {signupStep === 3 && (
                                            <>
                                                <div>
                                                    <label className="block text-sm font-medium text-slate-600 mb-1">Set User ID</label>
                                                    <input type="text" required className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#22c55e]" placeholder="Choose a username" />
                                                </div>
                                                <div>
                                                    <label className="block text-sm font-medium text-slate-600 mb-1">Set Password</label>
                                                    <input type="password" required className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#22c55e]" placeholder="••••••••" />
                                                </div>
                                                <button type="submit" className="mt-2 w-full py-2.5 bg-[#0b1325] text-white rounded-lg font-medium hover:bg-slate-800 transition-colors">Complete Registration</button>
                                            </>
                                        )}
                                    </form>

                                    {signupStep === 1 && (
                                        <p className="mt-6 text-center text-sm text-slate-500">
                                            Already have an account? <button onClick={() => setAuthMode("login")} className="text-[#0b1325] font-bold hover:underline">Log in</button>
                                        </p>
                                    )}
                                </>
                            )}

                            {/* --- FORGOT PASSWORD FLOW --- */}
                            {authMode === "forgot" && (
                                <>
                                    <h2 className="text-2xl font-bold text-slate-800 mb-2">Reset Password</h2>
                                    <p className="text-sm text-slate-500 mb-6">Enter your registered email or phone number to receive a reset link/OTP.</p>
                                    <form onSubmit={(e) => { e.preventDefault(); alert("Reset link sent!"); setAuthMode("login"); }} className="flex flex-col gap-4">
                                        <div>
                                            <label className="block text-sm font-medium text-slate-600 mb-1">Email or Phone</label>
                                            <input type="text" required className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#0b1325]" placeholder="Enter details" />
                                        </div>
                                        <button type="submit" className="mt-2 w-full py-2.5 bg-[#0b1325] text-white rounded-lg font-medium hover:bg-slate-800 transition-colors">
                                            Send Reset Instructions
                                        </button>
                                    </form>
                                    <p className="mt-6 text-center text-sm text-slate-500">
                                        Remembered? <button onClick={() => setAuthMode("login")} className="text-[#0b1325] font-bold hover:underline">Back to Login</button>
                                    </p>
                                </>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}