:root {
  --accent: #7b4b1f;
  --bg: #fbf2f6;
  --card: #ffffff;
  --muted: #8f8390;
}

.mypage-shell {
  width: 100%;
  height: calc(100vh - 88px);
  display: flex;
  flex-direction: column;
  background: var(--bg);
  box-sizing: border-box;
}

.mypage-header {
  height: 64px;
  background: var(--accent);
  color: white;
  display:flex;
  align-items:center;
  padding: 12px 28px;
  box-shadow: 0 2px 0 rgba(0,0,0,0.06);
}
.mypage-title {
  font-size: 20px;
  font-weight: 700;
}

.mypage-body {
  display: flex;
  gap: 28px;
  padding: 28px;
  align-items: flex-start;
  box-sizing: border-box;
  width: 100%;
}

.mypage-left {
  width: 720px;
  min-width: 360px;
  background: transparent;
  position: relative;
}

.settings-btn {
  border: none;
  background: transparent;
  font-size: 22px;
  cursor: pointer;
  color: var(--muted);
  margin-left: auto;
}


.profile-block {
  display: flex;
  gap: 18px;
  align-items: center;
  padding: 14px 6px;
  width: 100%;
}


.avatar {
  width: 96px;
  height: 96px;
  border-radius: 12px;
  background: #7b4b1f;
  overflow: hidden;
  display:flex;
  align-items:center;
  justify-content:center;
  flex-shrink:0;
  border: 2px solid rgba(0,0,0,0.03);
}
.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display:block;
}

.profile-meta {
  display:flex;
  flex-direction: column;
}
.profile-name {
  font-size: 22px;
  font-weight: 800;
  margin-bottom: 6px;
}
.profile-id {
  color: var(--muted);
  font-size: 14px;
}

.progress-section {
  margin-top: 28px;
  padding: 12px 6px;
}
.progress-label {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 10px;
}

.progress-bar-wrap {
  display:flex;
  flex-direction: column;
  gap: 10px;
}
.progress-bar-bg {
  height: 12px;
  background: #e8e7e9;
  border-radius: 8px;
  overflow:hidden;
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.6);
}
.progress-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #7b4b1f, #9a5f30);
  width: 0%;
  transition: width 0.4s ease;
}
.progress-numeric {
  color: var(--muted);
  font-size: 14px;
}

.mypage-right {
  flex: 1 1 auto;
  min-width: 240px;
  max-width: 420px;
}

@media (max-width: 900px) {
  .mypage-body {
    padding: 18px;
    flex-direction: column;
    gap: 14px;
  }
  .mypage-left { width: 100%; }
  .mypage-right { display:none; }
  .settings-btn { left: 4px; top: 4px; }
}

.manage-btn {
  border-radius: 10px;
  background: var(--accent);
  color: white;
  padding: 8px 14px;
  font-weight: 700;
  box-shadow: 0 6px 14px rgba(123,75,31,0.12);
}
.manage-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 30px rgba(123,75,31,0.16);
}
