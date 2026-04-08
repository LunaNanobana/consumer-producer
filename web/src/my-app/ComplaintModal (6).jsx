import React, { useState } from "react";
import "./PageLayout.css";
import ComplaintModal from "./ComplaintModal";
import MyPage from "./MyPage";
import Chats from "./Chats";

const HEADER_BG = "/mnt/data/4881fda5-730a-4f49-ab74-e0e6d6dd7369.png";

const initialComplaints = [
  { id: 1, title: "Broken light at entrance", date: "2025-11-23T11:13:00Z" },
  { id: 2, title: "No hot water in unit 4A", date: "2025-11-23T11:13:00Z" },
  { id: 3, title: "Elevator stuck intermittently", date: "2025-11-22T09:05:00Z" },
  { id: 4, title: "Hallway smell", date: "2025-11-20T18:30:00Z" }
];

function formatDate(iso) {
  const d = new Date(iso);
  return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) + "  " + d.toLocaleDateString();
}

function ComplaintCard({ c, onClick }) {
  return (
    <button className="complaint-card" onClick={() => onClick(c)}>
      <div className="complaint-title">{c.title}</div>
      <div className="complaint-body" />
      <div className="complaint-ts">{formatDate(c.date)}</div>
    </button>
  );
}

export default function PageLayout() {
  const [page, setPage] = useState("dashboard");
  const [complaints, setComplaints] = useState(initialComplaints);
  const [selected, setSelected] = useState(null);
  const [progress, setProgress] = useState(0);

  function openComplaint(c) {
    setSelected(c);
  }
  function closeModal() {
    setSelected(null);
  }

  function goToChat() {
    setSelected(null);
    setPage("chats");
  }

  function completeComplaint(c) {
    setComplaints(prev => prev.filter(x => x.id !== c.id));
    setProgress(prev => Math.min(100, prev + 1));
  }

  function escalateComplaint(c) {
    setComplaints(prev => prev.filter(x => x.id !== c.id));
  }

  return (
    <div className="app-shell">
      <header className="appbar" style={{ backgroundImage: `url(${HEADER_BG})` }}>
        <div className="appbar-title">{page === "profile" ? "My Account" : page === "chats" ? "Chats" : "Dashboard"}</div>
      </header>

      <div className="app-body">
        <aside className="sidebar">
          <div className="sidebar-block">
            <button
              className={`side-btn ${page === "dashboard" ? "active" : ""}`}
              onClick={() => setPage("dashboard")}
            >
              <span className="icon">📋</span>
              <span className="label">Dashboard</span>
            </button>

            <button
              className={`side-btn ${page === "chats" ? "active" : ""}`}
              onClick={() => setPage("chats")}
            >
              <span className="icon">💬</span>
              <span className="label">Chats</span>
            </button>

            <button
              className={`side-btn ${page === "profile" ? "active" : ""}`}
              onClick={() => setPage("profile")}
            >
              <span className="icon">👤</span>
              <span className="label">My Page</span>
            </button>
          </div>
        </aside>

        <main className="main-area">
          {page === "dashboard" && (
            <>
              <section className="complaint-grid" aria-label="complaint list">
                {complaints.map((c) => (
                  <ComplaintCard key={c.id} c={c} onClick={openComplaint} />
                ))}
                {complaints.length === 0 && (
                  <div style={{ padding: 20, color: "#6f6370" }}>No complaints — good job!</div>
                )}
              </section>
            </>
          )}

          {page === "chats" && <Chats />}

          {page === "profile" && <MyPage name="Bruce Wayne" id="12345" progress={progress} />}
        </main>
      </div>

      <ComplaintModal
        complaint={selected}
        onClose={closeModal}
        onChat={() => { goToChat(); }}
        onComplete={completeComplaint}
        onEscalate={escalateComplaint}
      />
    </div>
  );
}
