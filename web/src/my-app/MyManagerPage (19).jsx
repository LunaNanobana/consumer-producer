import React, { useState, useRef, useEffect } from "react";
import "./Chats.css";

const sampleConversations = [
  {
    id: 1,
    title: "Front door light",
    lastMessage: "We scheduled a technician.",
    messages: [
      { id: 1, from: "user", text: "The front light is broken again.", time: "2025-11-23T11:10:00Z" },
      { id: 2, from: "staff", text: "Thanks — we'll send someone today.", time: "2025-11-23T11:12:00Z" },
    ],
  },
  {
    id: 2,
    title: "Unit 4A water",
    lastMessage: "Please check your valves.",
    messages: [
      { id: 1, from: "user", text: "No hot water in 4A.", time: "2025-11-23T09:00:00Z" },
      { id: 2, from: "staff", text: "We're investigating.", time: "2025-11-23T09:15:00Z" },
      { id: 3, from: "user", text: "Any updates?", time: "2025-11-23T15:00:00Z" },
    ],
  },
  {
    id: 3,
    title: "Elevator",
    lastMessage: "Maintenance booked",
    messages: [
      { id: 1, from: "user", text: "Elevator stuck intermittently.", time: "2025-11-22T08:05:00Z" },
      { id: 2, from: "staff", text: "We will check it today.", time: "2025-11-22T10:20:00Z" },
    ],
  },
];

function formatTime(iso) {
  const d = new Date(iso);
  return d.toLocaleString([], { hour: "2-digit", minute: "2-digit" });
}

export default function Chats() {
  const [conversations, setConversations] = useState(sampleConversations);
  const [activeId, setActiveId] = useState(conversations[0].id);
  const [text, setText] = useState("");
  const messagesRef = useRef(null);

  const activeConv = conversations.find(c => c.id === activeId);

  useEffect(() => {
    if (messagesRef.current) {
      messagesRef.current.scrollTop = messagesRef.current.scrollHeight;
    }
  }, [activeId, activeConv?.messages?.length]);

  function sendMessage() {
    const t = text.trim();
    if (!t) return;
    const now = new Date().toISOString();
    const newMsg = { id: Date.now(), from: "user", text: t, time: now };

    setConversations(prev => prev.map(c => {
      if (c.id !== activeId) return c;
      return {
        ...c,
        messages: [...c.messages, newMsg],
        lastMessage: t,
      };
    }));
    setText("");
  }

  function onKey(e) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  }

  return (
    <div className="chats-shell no-side-info">
      <aside className="chats-list compact">
        <div className="convos">
          {conversations.map(conv => (
            <button
              key={conv.id}
              className={`convo-item ${conv.id === activeId ? "active" : ""}`}
              onClick={() => setActiveId(conv.id)}
            >
              <div className="convo-title">{conv.title}</div>
              <div className="convo-sub">{conv.lastMessage}</div>
            </button>
          ))}
        </div>
      </aside>

      <section className="chat-panel full">
        <header className="chat-header">
          <div className="chat-header-left">
            <div className="chat-title">{activeConv.title}</div>
            <div className="chat-sub">{activeConv.lastMessage}</div>
          </div>
        </header>

        <div className="messages" ref={messagesRef}>
          {activeConv.messages.map(m => (
            <div key={m.id} className={`message ${m.from === "user" ? "from-me" : "from-them"}`}>
              <div className="msg-text">{m.text}</div>
              <div className="msg-time">{formatTime(m.time)}</div>
            </div>
          ))}
        </div>

        <footer className="composer">
          <textarea
            placeholder="Write a message and press Enter to send..."
            value={text}
            onChange={e => setText(e.target.value)}
            onKeyDown={onKey}
          />
          <div className="composer-actions">
            <button className="send-btn" onClick={sendMessage}>Send</button>
          </div>
        </footer>
      </section>
    </div>
  );
}
