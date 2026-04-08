import './App.css'
import { AuthProvider, useAuth } from './AuthContext';
import { Login } from './components/Login.jsx';
import { Register } from './components/Register.jsx';
import { BrowserRouter, Route, Routes, Navigate } from 'react-router-dom';
import OrdersDashboard from './components/OrdersDashboard.jsx';
import Catalog from './components/Catalog.jsx';
import Chats from './components/Chats.jsx';
import MyPage from './components/MyPage.jsx';
import MyOwnerPage from './components/MyOwnerPage.jsx';
import MyManagerPage from './components/MyManagerPage.jsx';
import Staff from './components/Staff.jsx';
import Orders from './components/Orders.jsx';
import Complaints from './components/Complaints.jsx';

function PrivateRoute({ children }) {
  const { user, loading } = useAuth();
  
  if (loading) {
    return <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>Loading...</div>;
  }
  
  return user ? children : <Navigate to="/login" replace />;
}

function App() { 
  return  (
    <>
      <AuthProvider>
        <BrowserRouter>
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route path="/" element={<PrivateRoute><OrdersDashboard /></PrivateRoute>} />
            <Route path="/dashboard" element={<PrivateRoute><OrdersDashboard /></PrivateRoute>} />
            <Route path="/catalog" element={<PrivateRoute><Catalog /></PrivateRoute>} />
            <Route path="/chats" element={<PrivateRoute><Chats /></PrivateRoute>} />
            <Route path="/profile" element={<PrivateRoute><MyPage /></PrivateRoute>} />
            <Route path="/owner" element={<PrivateRoute><MyOwnerPage /></PrivateRoute>} />
            <Route path="/manager" element={<PrivateRoute><MyManagerPage /></PrivateRoute>} />
            <Route path="/staff" element={<PrivateRoute><Staff /></PrivateRoute>} />
            <Route path="/orders" element={<PrivateRoute><Orders /></PrivateRoute>} />
            <Route path="/complaints" element={<PrivateRoute><Complaints /></PrivateRoute>} />
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </>
  );
} 
export default App;
