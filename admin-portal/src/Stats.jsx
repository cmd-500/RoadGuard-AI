export const Stats = ({ data }) => {
  const high = data.filter(d => d.sev === "high").length;
  const med = data.filter(d => d.sev === "med").length;
  const low = data.filter(d => d.sev === "low").length;

  return (
    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-4">
      <h3 className="font-semibold text-slate-800 mb-3">Severity Breakdown</h3>
      <div className="flex flex-col gap-2">
        {/* High: Dark Blue */}
        <div className="flex justify-between items-center p-2 rounded bg-[#0b1325] text-white">
          <span className="text-sm font-medium">High</span>
          <span className="font-bold">{high}</span>
        </div>
        {/* Medium: Green */}
        <div className="flex justify-between items-center p-2 rounded bg-[#22c55e] text-white">
          <span className="text-sm font-medium">Medium</span>
          <span className="font-bold">{med}</span>
        </div>
        {/* Low: White/Light Grey */}
        <div className="flex justify-between items-center p-2 rounded bg-slate-50 border border-slate-200 text-slate-600">
          <span className="text-sm font-medium">Low</span>
          <span className="font-bold">{low}</span>
        </div>
      </div>
    </div>
  );
};