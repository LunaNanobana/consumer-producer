import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext";
import * as api from "../api";
import "./PageLayout.css";

export default function Orders() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    async function fetchOrders() {
      try {
        setLoading(true);
        const ordersData = await api.getOrders();
        if (ordersData.length === 0) {
          setOrders([{
            id: 'example',
            consumer: { name: 'Example Consumer' },
            total: 0.00,
            status: 'pending',
            created_at: new Date().toISOString(),
            items: []
          }]);
        } else {
          setOrders(ordersData);
        }
        setError('');
      } catch (err) {
        console.error('Error fetching orders:', err);
        setError('Failed to load orders');
        setOrders([{
          id: 'example',
          consumer: { name: 'Example Consumer' },
          total: 0.00,
          status: 'pending',
          created_at: new Date().toISOString(),
          items: []
        }]);
      } finally {
        setLoading(false);
      }
    }
    fetchOrders();
  }, []);

  const handleMarkAsDone = async (orderId) => {
    if (orderId === 'example') {
      alert('This is an example order. Real orders can be marked as done.');
      return;
    }
    try {
      await api.markOrderAsDone(orderId);
      const updated = await api.getOrders();
      setOrders(updated);
    } catch (err) {
      console.error('Error marking order as done:', err);
      setError('Failed to mark order as done');
    }
  };

  function formatDate(iso) {
    const d = new Date(iso);
    return d.toLocaleString([], { hour: "2-digit", minute: "2-digit" }) + "  " + d.toLocaleDateString();
  }

  return (
    <div style={{ padding: '20px' }}>
      <div style={{ padding: '10px', borderBottom: '1px solid #ddd', marginBottom: '20px' }}>
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

      <h2>Orders</h2>
      <p style={{ color: '#6c6370', marginBottom: '20px' }}>
        This is where orders that your supplier company received will be displayed. You can mark orders as done.
      </p>

      {error && (
        <div style={{ padding: '10px', backgroundColor: '#f8d7da', color: '#721c24', borderRadius: '4px', marginBottom: '20px' }}>
          {error}
        </div>
      )}

      {loading ? (
        <div style={{ padding: '20px', textAlign: 'center' }}>Loading orders...</div>
      ) : (
        <div style={{ overflowX: 'auto', marginTop: '20px' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', backgroundColor: 'white' }}>
            <thead>
              <tr style={{ backgroundColor: '#f8f9fa' }}>
                <th style={{ padding: '12px', textAlign: 'left', border: '1px solid #dee2e6' }}>Order ID</th>
                <th style={{ padding: '12px', textAlign: 'left', border: '1px solid #dee2e6' }}>Consumer</th>
                <th style={{ padding: '12px', textAlign: 'left', border: '1px solid #dee2e6' }}>Status</th>
                <th style={{ padding: '12px', textAlign: 'left', border: '1px solid #dee2e6' }}>Total</th>
                <th style={{ padding: '12px', textAlign: 'left', border: '1px solid #dee2e6' }}>Date</th>
                <th style={{ padding: '12px', textAlign: 'left', border: '1px solid #dee2e6' }}>Items</th>
                <th style={{ padding: '12px', textAlign: 'left', border: '1px solid #dee2e6' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {orders.length === 0 ? (
                <tr>
                  <td colSpan="7" style={{ padding: '20px', textAlign: 'center' }}>No orders found.</td>
                </tr>
              ) : (
                orders.map((order) => (
                  <tr key={order.id}>
                    <td style={{ padding: '12px', border: '1px solid #dee2e6' }}>#{order.id}</td>
                    <td style={{ padding: '12px', border: '1px solid #dee2e6' }}>{order.consumer?.name || order.consumer?.user?.username || 'N/A'}</td>
                    <td style={{ padding: '12px', border: '1px solid #dee2e6' }}>
                      <span style={{ 
                        padding: '4px 8px', 
                        borderRadius: '4px',
                        backgroundColor: order.status === 'completed' ? '#28a745' : 
                                       order.status === 'pending' ? '#ffc107' : '#6c757d',
                        color: 'white'
                      }}>
                        {order.status}
                      </span>
                    </td>
                    <td style={{ padding: '12px', border: '1px solid #dee2e6' }}>${order.total?.toFixed(2) || '0.00'}</td>
                    <td style={{ padding: '12px', border: '1px solid #dee2e6' }}>
                      {formatDate(order.created_at)}
                    </td>
                    <td style={{ padding: '12px', border: '1px solid #dee2e6' }}>
                      {order.items && order.items.length > 0 ? (
                        <ul style={{ margin: 0, paddingLeft: '20px' }}>
                          {order.items.map((item, idx) => (
                            <li key={idx} style={{ fontSize: '12px' }}>
                              {item.product?.name || 'Product'} ({item.quantity} x ${item.unit_price?.toFixed(2) || '0.00'})
                            </li>
                          ))}
                        </ul>
                      ) : (
                        <span style={{ color: '#6c757d' }}>No items</span>
                      )}
                    </td>
                    <td style={{ padding: '12px', border: '1px solid #dee2e6' }}>
                      {order.status !== 'completed' && (
                        <button
                          onClick={() => handleMarkAsDone(order.id)}
                          style={{ 
                            padding: '4px 8px', 
                            backgroundColor: '#28a745', 
                            color: 'white', 
                            border: 'none', 
                            borderRadius: '4px', 
                            cursor: 'pointer',
                            fontSize: '12px'
                          }}
                        >
                          Mark as Done
                        </button>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
