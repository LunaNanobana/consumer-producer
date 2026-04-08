import React, { useState, useRef, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext";
import * as api from "../api";
import "./Chats.css";

function formatTime(iso) {
  const d = new Date(iso);
  return d.toLocaleString([], { hour: "2-digit", minute: "2-digit" });
}

export default function Chats() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [conversations, setConversations] = useState([]);
  const [activeId, setActiveId] = useState(null);
  const [text, setText] = useState("");
  const [loading, setLoading] = useState(true);
  const messagesRef = useRef(null);
  useEffect(() => {
    async function fetchConversations() {
      try {
        setLoading(true);
        const convos = await api.getChatConversations();
        if (convos.length > 0) {
          setConversations(convos);
          setActiveId(convos[0].id);
        } else {
          try {
            const newConv = await api.createChatConversation({ title: "General Chat" });
            setConversations([newConv]);
            setActiveId(newConv.id);
          } catch (err) {
            console.error('Error creating default conversation:', err);
          }
        }
      } catch (err) {
        console.error('Error fetching conversations:', err);
        try {
          const newConv = await api.createChatConversation({ title: "General Chat" });
          setConversations([newConv]);
          setActiveId(newConv.id);
        } catch (createErr) {
          console.error('Error creating default conversation:', createErr);
        }
      } finally {
        setLoading(false);
      }
    }
    fetchConversations();
  }, []);
  useEffect(() => {
    if (!activeId) return;

    async function fetchMessages() {
      try {
        const messages = await api.getChatMessages(activeId);
        setConversations(prev => prev.map(conv => {
          if (conv.id === activeId) {
            return {
              ...conv,
              messages: messages.map(msg => ({
                id: msg.id,
                from: msg.user.id === user?.id ? "user" : "staff",
                text: msg.text,
                time: msg.created_at,
                user: msg.user
              })),
              lastMessage: messages.length > 0 ? messages[messages.length - 1].text : ""
            };
          }
          return conv;
        }));
      } catch (err) {
        console.error('Error fetching messages:', err);
      }
    }
    fetchMessages();
  }, [activeId, user]);
  useEffect(() => {
    if (messagesRef.current) {
      messagesRef.current.scrollTop = messagesRef.current.scrollHeight;
    }
  }, [conversations]);

  const activeConv = conversations.find(c => c.id === activeId);

  async function sendMessage() {
    const t = text.trim();
    if (!t || !activeId) return;

    try {
      const newMsg = await api.createChatMessage({
        conversation: activeId,
        text: t
      });
      setConversations(prev => prev.map(c => {
        if (c.id !== activeId) return c;
        return {
          ...c,
          messages: [...(c.messages || []), {
            id: newMsg.id,
            from: "user",
            text: newMsg.text,
            time: newMsg.created_at,
            user: newMsg.user
          }],
          lastMessage: t,
        };
      }));
      setText("");
    } catch (err) {
      console.error('Error sending message:', err);
      alert('Failed to send message. Please try again.');
    }
  }

  function onKey(e) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  }

  if (loading) {
    return (
      <div style={{ padding: '20px', textAlign: 'center' }}>
        Loading conversations...
      </div>
    );
  }

  return (
    <div className="chats-shell no-side-info">
      <div style={{ padding: '10px', borderBottom: '1px solid #ddd' }}>
        <button
          onClick={() => navigate('/dashboard')}
          style={{
            padding: '8px 16px',
            backgroundColor: '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer',
            fontSize: '14px'
          }}
        >
          ← Back to Dashboard
        </button>
      </div>
      <aside className="chats-list compact">
        <div className="convos">
          {conversations.length === 0 ? (
            <div style={{ padding: '20px', color: '#6c757d', textAlign: 'center' }}>
              No conversations yet
            </div>
          ) : (
            conversations.map(conv => (
              <button
                key={conv.id}
                className={`convo-item ${conv.id === activeId ? "active" : ""}`}
                onClick={() => setActiveId(conv.id)}
              >
                <div className="convo-title">{conv.title}</div>
                <div className="convo-sub">{conv.last_message?.text || conv.lastMessage || "No messages"}</div>
              </button>
            ))
          )}
        </div>
      </aside>

      <section className="chat-panel full">
        <header className="chat-header">
          <div className="chat-header-left">
            <div className="chat-title">{activeConv?.title || 'Select a conversation'}</div>
            <div className="chat-sub">{activeConv?.last_message?.text || activeConv?.lastMessage || ''}</div>
          </div>
        </header>

        <div className="messages" ref={messagesRef}>
          {activeConv?.messages && activeConv.messages.length > 0 ? (
            activeConv.messages.map(m => (
              <div key={m.id} className={`message ${m.from === "user" ? "from-me" : "from-them"}`}>
                <div className="msg-text">{m.text}</div>
                <div className="msg-time">{formatTime(m.time)}</div>
              </div>
            ))
          ) : (
            <div style={{ padding: '20px', color: '#6c757d', textAlign: 'center' }}>
              No messages yet. Start the conversation!
            </div>
          )}
        </div>

        <footer className="composer">
          <textarea
            placeholder="Write a message and press Enter to send..."
            value={text}
            onChange={e => setText(e.target.value)}
            onKeyDown={onKey}
            disabled={!activeConv}
          />
          <div className="composer-actions">
            <button className="send-btn" onClick={sendMessage} disabled={!activeConv}>Send</button>
          </div>
        </footer>
      </section>
    </div>
  );
}
