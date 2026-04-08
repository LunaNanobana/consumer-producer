.chats-shell {
  display: flex;
  gap: 18px;
  width: 100%;
  height: calc(100vh - 160px);
  box-sizing: border-box;
}

.chats-list.compact {
  width: 260px;
  min-width: 220px;
  background: rgba(255,255,255,0.95);
  border-radius: 12px;
  padding: 12px;
  box-shadow: 0 6px 18px rgba(0,0,0,0.03);
  display:flex;
  flex-direction: column;
  gap: 8px;
  overflow: hidden;
}

.convos {
  overflow-y: auto;
  padding-top: 4px;
  display:flex;
  flex-direction: column;
  gap:8px;
}
.convo-item {
  text-align:left;
  padding: 12px;
  border-radius:10px;
  background: transparent;
  border: none;
  cursor: pointer;
  position: relative;
}
.convo-item:hover { background: rgba(0,0,0,0.03); }
.convo-item.active {
  background: linear-gradient(180deg, rgba(123,75,31,0.07), rgba(123,75,31,0.03));
  box-shadow: inset 0 0 0 1px rgba(123,75,31,0.05);
}
.convo-title { font-weight:700; }
.convo-sub { color: #8f8390; font-size:13px; margin-top:4px; }

.chat-panel.full {
  flex: 1 1 auto;
  min-width: 0;
  display:flex;
  flex-direction: column;
  background: transparent;
  gap: 10px;
}

.chat-header {
  display:flex;
  align-items:center;
  justify-content: space-between;
  padding: 8px 12px;
  background: rgba(255,255,255,0.6);
  border-radius: 8px;
}
.chat-title { font-weight:800; font-size:18px; }
.chat-sub { color: #8f8390; font-size:13px; margin-top:2px; }

.messages {
  flex: 1 1 auto;
  overflow-y: auto;
  padding: 18px;
  display:flex;
  flex-direction: column;
  gap: 12px;
  background: linear-gradient(180deg, rgba(255,255,255,0.6), rgba(255,255,255,0.95));
  border-radius: 10px;
  box-shadow: 0 6px 18px rgba(0,0,0,0.03);
}

.message {
  max-width: 70%;
  padding: 12px 14px;
  border-radius: 12px;
  position: relative;
  font-size: 15px;
  line-height: 1.35;
}
.message .msg-time { font-size: 12px; color: #9b8f98; margin-top:8px; }
.from-me {
  align-self: flex-end;
  background: linear-gradient(180deg, #ffffff, #fffdfa);
  border: 1px solid rgba(0,0,0,0.04);
}
.from-them {
  align-self: flex-start;
  background: linear-gradient(180deg, #f7f1f5, #fff);
  border: 1px solid rgba(0,0,0,0.04);
}

.composer {
  display:flex;
  gap: 12px;
  align-items: stretch;
  padding: 12px;
  background: transparent;
}
.composer textarea {
  flex: 1 1 auto;
  min-height: 56px;
  max-height: 150px;
  resize: vertical;
  padding: 10px;
  border-radius: 10px;
  border: 1px solid rgba(0,0,0,0.06);
  font-size: 14px;
}
.composer-actions {
  display:flex;
  flex-direction: column;
  gap:10px;
}
.send-btn {
  background: var(--accent);
  color: white;
  border: none;
  padding: 10px 14px;
  border-radius: 10px;
  cursor: pointer;
  font-weight: 700;
}

@media (max-width: 1050px) {
  .chats-shell { height: calc(100vh - 140px); }
  .chats-list { display:none; }
  .chat-panel { min-width: 0; }
}
