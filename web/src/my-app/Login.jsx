import React, { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "../AuthContext";
import "./PageLayout.css";
import MyManagerPage from "./MyManagerPage";
import Chats from "./Chats";
import Catalog from "./Catalog";
import MyOwnerPage from "./MyOwnerPage";
import Staff from "./Staff";
import Complaints from "./Complaints";
import Orders from "./Orders";
import * as api from "../api";

function formatDate(iso) {
  const d = new Date(iso);
  return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) + "  " + d.toLocaleDateString();
}

function ProductCard({ p, onClick }) {
  return (
    <button
      className="product-card-vertical"
      onClick={() => onClick(p)}
      title={`Open ${p.name}`}
      type="button"
    >
      <div className="product-thumb-vertical" aria-hidden>
        <img src={p.image || "https://via.placeholder.com/150"} alt={p.name} />
      </div>

      <div className="product-info-vertical">
        <div className="product-title">{p.name}</div>
        <div className="product-qty">{p.stock} {p.unit || 'kg'}</div>
        <div className="product-due">💰 Price: ${p.price}</div>
      </div>
    </button>
  );
}

export default function OrdersDashboard() {
  const navigate = useNavigate();
  const location = useLocation();
  const { user, logout } = useAuth();
  const [page, setPage] = useState("dashboard");
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState(null);
  const [userRole, setUserRole] = useState('owner');
  useEffect(() => {
    const path = location.pathname;
    if (path === '/dashboard' || path === '/') {
      setPage('dashboard');
    } else if (path === '/catalog') {
      setPage('catalog');
    } else if (path === '/chats') {
      setPage('chats');
    } else if (path === '/profile') {
      setPage('profile');
    } else if (path === '/staff') {
      setPage('staff');
    } else if (path === '/orders') {
      setPage('orders');
    } else if (path === '/complaints') {
      setPage('complaints');
    }
  }, [location]);
  useEffect(() => {
    async function fetchData() {
      try {
        setLoading(true);
        const [productsData, roleData] = await Promise.all([
          api.getProducts().catch(() => []),
          api.getUserRole().catch(() => ({ role: 'owner' }))
        ]);
        setProducts(productsData);
        setUserRole(roleData.role || 'owner');
      } catch (error) {
        console.error('Error fetching data:', error);
        setProducts([]);
      } finally {
        setLoading(false);
      }
    }
    if (page === 'dashboard') {
      fetchData();
    }
  }, [page]);

  function onCardClick(p) {
    setSelected(p);
  }

  function handlePageChange(newPage) {
    setPage(newPage);
    navigate(`/${newPage === 'dashboard' ? 'dashboard' : newPage}`);
  }

  return (
    <div className="app-shell">
      <header className="appbar">
        <div className="appbar-title">
          {page === "profile" ? "My Account" : 
           page === "chats" ? "Chats" : 
           page === "catalog" ? "Catalog" : 
           page === "staff" ? "Staff Management" :
           page === "complaints" ? "Complaints" :
           page === "orders" ? "Orders" :
           "Dashboard"}
        </div>
        <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: '10px', paddingRight: '20px' }}>
          <span style={{ fontSize: '14px' }}>{user?.username}</span>
          <button 
            onClick={logout}
            style={{ 
              padding: '6px 12px', 
              backgroundColor: '#dc3545', 
              color: 'white', 
              border: 'none', 
              borderRadius: '4px', 
              cursor: 'pointer',
              fontSize: '12px'
            }}
          >
            Logout
          </button>
        </div>
      </header>

      <div className="app-body">
        <aside className="sidebar">
          <div className="sidebar-block">
            <button
              className={`side-btn ${page === "dashboard" ? "active" : ""}`}
              onClick={() => handlePageChange("dashboard")}
              type="button"
            >
              <span className="icon">📋</span>
              <span className="label">Dashboard</span>
            </button>

            <button
              className={`side-btn ${page === "chats" ? "active" : ""}`}
              onClick={() => handlePageChange("chats")}
              type="button"
            >
              <span className="icon">💬</span>
              <span className="label">Chats</span>
            </button>

            <button
              className={`side-btn ${page === "catalog" ? "active" : ""}`}
              onClick={() => handlePageChange("catalog")}
              type="button"
            >
              <span className="icon">🛒</span>
              <span className="label">Catalog</span>
            </button>

            <button
              className={`side-btn ${page === "profile" ? "active" : ""}`}
              onClick={() => handlePageChange("profile")}
              type="button"
            >
              <span className="icon">👤</span>
              <span className="label">My Page</span>
            </button>

            <button
              className={`side-btn ${page === "staff" ? "active" : ""}`}
              onClick={() => handlePageChange("staff")}
              type="button"
            >
              <span className="icon">👥</span>
              <span className="label">Staff</span>
            </button>

            <button
              className={`side-btn ${page === "orders" ? "active" : ""}`}
              onClick={() => handlePageChange("orders")}
              type="button"
            >
              <span className="icon">📦</span>
              <span className="label">Orders</span>
            </button>

            <button
              className={`side-btn ${page === "complaints" ? "active" : ""}`}
              onClick={() => handlePageChange("complaints")}
              type="button"
            >
              <span className="icon">⚠️</span>
              <span className="label">Complaints</span>
            </button>
          </div>
        </aside>

        <main className="main-area">
          {page === "dashboard" && (
            <>
              <div className="products-header">
                <h2>Products</h2>
                <div className="products-total">Total: {products.length}</div>
              </div>

              {loading ? (
                <div style={{ padding: '20px', textAlign: 'center' }}>Loading products...</div>
              ) : (
                <section className="product-list-vertical" aria-label="product list">
                  {products.length === 0 ? (
                    <div style={{ padding: '20px', color: '#6f6370' }}>No products found. Add your first product!</div>
                  ) : (
                    products.map(p => (
                      <ProductCard key={p.id} p={p} onClick={onCardClick} />
                    ))
                  )}
                </section>
              )}

              {selected && <div className="selected-note">Selected: {selected.name}</div>}
            </>
          )}

          {page === "catalog" && <Catalog />}

          {page === "chats" && <Chats />}

          {page === "profile" && (
            userRole === 'owner' ? (
              <MyOwnerPage
                name={user?.first_name && user?.last_name ? `${user.first_name} ${user.last_name}` : user?.username || "User"}
                id={user?.id?.toString() || "N/A"}
                onManage={() => {
                  handlePageChange("dashboard");
                }}
              />
            ) : (
              <MyManagerPage
                name={user?.first_name && user?.last_name ? `${user.first_name} ${user.last_name}` : user?.username || "User"}
                id={user?.id?.toString() || "N/A"}
                onManage={() => {
                  handlePageChange("dashboard");
                }}
              />
            )
          )}

          {page === "staff" && <Staff />}

          {page === "orders" && <Orders />}

          {page === "complaints" && <Complaints />}
        </main>
      </div>
    </div>
  );
}
