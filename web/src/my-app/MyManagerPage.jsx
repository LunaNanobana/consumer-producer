import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext";
import * as api from "../api";
import "./MyPage.css";

const PROFILE_IMG = "";

export default function MyPage({ name, id, progress = 0 }) {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [supplier, setSupplier] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchSupplier() {
      try {
        const supplierData = await api.getMySupplier();
        if (supplierData && !supplierData.error) {
          setSupplier(supplierData);
        }
      } catch (error) {
        console.error('Error fetching supplier:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchSupplier();
  }, []);

  const displayName = name || (user?.first_name && user?.last_name ? `${user.first_name} ${user.last_name}` : user?.username || "User");
  const displayId = id || user?.id?.toString() || "N/A";

  return (
    <div className="mypage-shell">
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
      <div className="mypage-body">
        <div className="mypage-left">
          <div className="profile-block">
            <div className="avatar">
              <img src={PROFILE_IMG || "https://via.placeholder.com/100"} alt="profile" />
            </div>

            <div className="profile-meta">
              <div className="profile-name">{displayName}</div>
              <div className="profile-id">ID: {displayId}</div>
              {user?.email && <div className="profile-id">Email: {user.email}</div>}
              {supplier && (
                <>
                  <div className="profile-id">Company: {supplier.name}</div>
                  <div className="profile-id">Status: {supplier.is_active ? 'Active' : 'Inactive'}</div>
                </>
              )}
            </div>

            <button className="settings-btn" title="Settings">⚙️</button>
          </div>

          <div className="progress-section">
            <div className="progress-label">Goal Progress</div>
            <div className="progress-bar-wrap" aria-hidden>
              <div className="progress-bar-bg">
                <div className="progress-bar-fill" style={{ width: `${progress}%` }} />
              </div>
              <div className="progress-numeric">{progress} / 100</div>
            </div>
          </div>
        </div>

        <div className="mypage-right"></div>
      </div>
    </div>
  );
}
