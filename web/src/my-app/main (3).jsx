import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "./Catalog.css";
import * as api from "../api";
import { useAuth } from "../AuthContext";

function InfoModal({ item, onClose }) {
  if (!item) return null;
  return (
    <div className="catalog-modal-overlay">
      <div className="catalog-modal">
        <button className="modal-close" onClick={onClose}>✕</button>

        <h3 className="modal-title">Product info</h3>

        <div className="modal-body">
          <div className="modal-row"><strong>Name:</strong> {item.name}</div>
          <div className="modal-row"><strong>SKU:</strong> {item.sku || 'N/A'}</div>
          <div className="modal-row"><strong>Stock:</strong> {item.stock} {item.unit}</div>
          <div className="modal-row"><strong>Price:</strong> ${item.price}</div>
          <div className="modal-row"><strong>Description:</strong> {item.description || 'N/A'}</div>
          <div className="modal-row"><strong>Category:</strong> {item.category?.name || 'N/A'}</div>
          <div className="modal-row"><strong>Status:</strong> {item.is_active ? 'Active' : 'Inactive'}</div>
        </div>

        <div className="modal-actions">
          <button className="modal-btn" onClick={onClose}>Close</button>
        </div>
      </div>
    </div>
  );
}

function AddProductModal({ onClose, onSuccess }) {
  const [formData, setFormData] = useState({
    name: '',
    stock: '',
    price: '',
    unit: 'kg',
    description: '',
    sku: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const productData = {
        name: formData.name,
        stock: parseInt(formData.stock) || 0,
        price: parseFloat(formData.price) || 0,
        unit: formData.unit,
        description: formData.description,
        sku: formData.sku,
        is_active: true,
        min_order_qty: 1
      };

      await api.createProduct(productData);
      onSuccess();
      onClose();
    } catch (err) {
      console.error('Error creating product:', err);
      let errorMessage = 'Failed to create product. Please check your inputs.';
      try {
        const errorData = JSON.parse(err.message);
        if (errorData.error) {
          errorMessage = errorData.error;
        } else if (typeof errorData === 'object') {
          const errorMessages = Object.keys(errorData).map(key => {
            if (Array.isArray(errorData[key])) {
              return `${key}: ${errorData[key].join(', ')}`;
            }
            return `${key}: ${errorData[key]}`;
          });
          errorMessage = errorMessages.join('; ');
        }
      } catch (parseErr) {
        if (err.message && !err.message.includes('JSON')) {
          errorMessage = err.message;
        }
      }
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="catalog-modal-overlay">
      <div className="catalog-modal" style={{ maxWidth: '500px' }}>
        <button className="modal-close" onClick={onClose}>✕</button>

        <h3 className="modal-title">Add New Product</h3>

        <form onSubmit={handleSubmit}>
          <div className="modal-body" style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
            <div>
              <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Product Name *</label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
                style={{ width: '100%', padding: '8px', border: '1px solid #ddd', borderRadius: '4px' }}
                placeholder="Enter product name"
              />
            </div>

            <div>
              <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Amount (Stock) *</label>
              <input
                type="number"
                value={formData.stock}
                onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
                required
                min="0"
                style={{ width: '100%', padding: '8px', border: '1px solid #ddd', borderRadius: '4px' }}
                placeholder="Enter stock amount"
              />
            </div>

            <div>
              <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Unit</label>
              <select
                value={formData.unit}
                onChange={(e) => setFormData({ ...formData, unit: e.target.value })}
                style={{ width: '100%', padding: '8px', border: '1px solid #ddd', borderRadius: '4px' }}
              >
                <option value="kg">kg</option>
                <option value="g">g</option>
                <option value="l">l</option>
                <option value="ml">ml</option>
                <option value="pcs">pcs</option>
                <option value="box">box</option>
              </select>
            </div>

            <div>
              <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Price *</label>
              <input
                type="number"
                step="0.01"
                value={formData.price}
                onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                required
                min="0"
                style={{ width: '100%', padding: '8px', border: '1px solid #ddd', borderRadius: '4px' }}
                placeholder="Enter price"
              />
            </div>

            <div>
              <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>SKU (Optional)</label>
              <input
                type="text"
                value={formData.sku}
                onChange={(e) => setFormData({ ...formData, sku: e.target.value })}
                style={{ width: '100%', padding: '8px', border: '1px solid #ddd', borderRadius: '4px' }}
                placeholder="Enter SKU"
              />
            </div>

            <div>
              <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Description (Optional)</label>
              <textarea
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                style={{ width: '100%', padding: '8px', border: '1px solid #ddd', borderRadius: '4px', minHeight: '80px' }}
                placeholder="Enter product description"
              />
            </div>

            {error && (
              <div style={{ padding: '10px', backgroundColor: '#f8d7da', color: '#721c24', borderRadius: '4px' }}>
                {error}
              </div>
            )}
          </div>

          <div className="modal-actions" style={{ display: 'flex', gap: '10px', justifyContent: 'flex-end' }}>
            <button type="button" className="modal-btn" onClick={onClose} disabled={loading}>
              Cancel
            </button>
            <button type="submit" className="modal-btn" disabled={loading} style={{ backgroundColor: '#28a745', color: 'white' }}>
              {loading ? 'Creating...' : 'Create Product'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default function Catalog() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [items, setItems] = useState([]);
  const [infoItem, setInfoItem] = useState(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const fetchProducts = async () => {
    try {
      setLoading(true);
      const products = await api.getProducts();
      setItems(products);
      setError('');
    } catch (err) {
      console.error('Error fetching products:', err);
      setError('Failed to load products');
      setItems([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  const handleProductAdded = () => {
    fetchProducts(); 
  };

  return (
    <div className="catalog-shell">
      <div style={{ padding: '10px', borderBottom: '1px solid #ddd', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
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

      <div className="catalog-header">
        <h2>Catalog</h2>
        <div className="catalog-count">Total: {items.length}</div>
      </div>

      {error && (
        <div style={{ padding: '10px', backgroundColor: '#f8d7da', color: '#721c24', borderRadius: '4px', margin: '10px' }}>
          {error}
        </div>
      )}

      {loading ? (
        <div style={{ padding: '20px', textAlign: 'center' }}>Loading catalog...</div>
      ) : (
        <div className="catalog-list">
          {items.length === 0 ? (
            <div style={{ padding: '20px', color: '#6f6370', textAlign: 'center' }}>No products in catalog. Add your first product!</div>
          ) : (
            items.map((it, idx) => (
              <div className="catalog-row" key={it.id}>
                <div className="catalog-index">{idx + 1}</div>

                <div className="catalog-thumb">
                  <img src={it.image || "https://via.placeholder.com/150"} alt={it.name} />
                </div>

                <div className="catalog-main">
                  <div className="catalog-name">{it.name}</div>
                  <div className="catalog-sub">SKU: {it.sku || 'N/A'}</div>
                </div>

                <div className="catalog-actions">
                  <button className="btn-info" onClick={() => setInfoItem(it)}>Info</button>
                  <button className="btn-edit" onClick={() => alert("Edit functionality coming soon")}>Edit</button>
                </div>
              </div>
            ))
          )}
        </div>
      )}

      <div className="catalog-add-container">
        <button className="catalog-add-btn" type="button" onClick={() => setShowAddModal(true)}>
          <span className="plus">＋</span> Add Product
        </button>
      </div>

      <InfoModal item={infoItem} onClose={() => setInfoItem(null)} />
      {showAddModal && <AddProductModal onClose={() => setShowAddModal(false)} onSuccess={handleProductAdded} />}
    </div>
  );
}
