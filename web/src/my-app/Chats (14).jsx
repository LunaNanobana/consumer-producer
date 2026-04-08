/* Catalog.css - drop-in styles */
:root{
  --accent:#7b4b1f;
  --bg:#fbf2f6;
  --card:#fff;
  --muted:#9f94a0;
}

.catalog-shell {
  width:100%;
  padding: 18px 22px;
  box-sizing: border-box;
  background: var(--bg);
}

/* header row */
.catalog-header {
  display:flex;
  justify-content:space-between;
  align-items:center;
  margin-bottom: 14px;
}
.catalog-header h2 { margin:0; font-size:20px; font-weight:800; color:#1a1a1a; }
.catalog-count { color:var(--muted); font-weight:700; }

/* list container (stacked) */
.catalog-list {
  display:block;
}

/* each catalog row (rectangular) */
.catalog-row {
  display:flex;
  align-items:center;
  gap: 16px;
  padding: 12px 16px;
  border-radius: 12px;
  background: linear-gradient(180deg, rgba(255,255,255,0.98), rgba(247,241,245,0.98));
  border:1px solid rgba(0,0,0,0.04);
  box-shadow: 0 6px 18px rgba(0,0,0,0.03);
  margin-bottom: 12px;
  overflow: hidden;
}

/* index on the left */
.catalog-index {
  width: 40px;
  text-align:center;
  font-weight:700;
  color:#222;
}

/* thumbnail: fixed size */
.catalog-thumb {
  flex: 0 0 92px;
  width: 92px;
  height: 92px;
  overflow: hidden;
  border-radius: 8px;
  background:#fff;
  display:flex;
  align-items:center;
  justify-content:center;
  box-shadow: 0 4px 10px rgba(0,0,0,0.03), inset 0 1px 0 rgba(255,255,255,0.6);
}
.catalog-thumb img {
  width:100%;
  height:100%;
  object-fit:cover;
  display:block;
  pointer-events:none;
  -webkit-user-drag:none;
}

/* main text */
.catalog-main {
  flex: 1 1 auto;
  min-width: 0;
  display:flex;
  flex-direction:column;
}
.catalog-name { font-weight:800; font-size:16px; color:#111; }
.catalog-sub { color:var(--muted); margin-top:6px; font-size:13px; }

/* actions */
.catalog-actions {
  display:flex;
  flex-direction:column;
  gap:8px;
  align-items:flex-end;
  flex: 0 0 auto;
}
.btn-info, .btn-edit {
  padding:8px 14px;
  border-radius: 20px;
  border:1px solid rgba(0,0,0,0.06);
  background: #fff;
  cursor:pointer;
  font-weight:700;
}
.btn-info { color: #3b2a57; }
.btn-edit { color: var(--accent); }

/* Modal overlay & dialog */
.catalog-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.35);
  display:flex;
  align-items:center;
  justify-content:center;
  z-index:1200;
  padding: 18px;
  box-sizing:border-box;
}

.catalog-modal {
  width: 420px;
  max-width: calc(100% - 40px);
  background: #fff;
  border-radius: 10px;
  padding: 18px 20px;
  box-shadow: 0 30px 80px rgba(0,0,0,0.25);
  position: relative;
}

/* modal close */
.modal-close {
  position:absolute;
  right:10px;
  top:10px;
  border:none;
  background:transparent;
  font-size:18px;
  cursor:pointer;
}

/* content */
.modal-title { margin: 4px 0 10px 0; font-size:18px; font-weight:800; }
.modal-body { color:#222; font-size:15px; display:flex; flex-direction:column; gap:10px; margin-bottom:12px; }
.modal-row { display:flex; gap:8px; }
.modal-actions { display:flex; justify-content:flex-end; }
.modal-btn {
  padding:8px 14px;
  border-radius:8px;
  border: none;
  background: var(--accent);
  color: white;
  cursor:pointer;
  font-weight:700;
}

/* Add Button */
.catalog-add-container {
  width: 100%;
  display: flex;
  justify-content: center;
  margin-top: 24px;
}

.catalog-add-btn {
  background: var(--accent);
  color: white;
  font-weight: 700;
  padding: 12px 26px;
  border-radius: 22px;
  border: none;
  cursor: pointer;
  font-size: 16px;
  display: flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 5px 14px rgba(0,0,0,0.15);
}

.catalog-add-btn .plus {
  font-size: 18px;
  font-weight: 900;
  margin-right: 4px;
}

.catalog-add-btn:hover {
  opacity: 0.92;
  transform: translateY(-1px);
}


/* responsive */
@media (max-width: 720px) {
  .catalog-row { flex-direction: row; gap:12px; padding:10px; }
  .catalog-thumb { width:72px; height:72px; flex: 0 0 72px; }
  .catalog-index { width: 32px; }
  .catalog-actions { gap:6px; }
}

