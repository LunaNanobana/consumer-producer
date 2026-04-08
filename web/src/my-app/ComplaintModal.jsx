const API_BASE_URL = 'http://localhost:8000';
function getToken() {
  return localStorage.getItem('token');
}
function getAuthHeaders() {
  const token = getToken();
  return {
    'Content-Type': 'application/json',
    ...(token && { 'Authorization': `Token ${token}` })
  };
}
export async function registerUser(data) {
  const res = await fetch(`${API_BASE_URL}/auth/users/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function getSuppliers() {
  const res = await fetch(`${API_BASE_URL}/api/suppliers/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch suppliers');
  }
  return res.json();
}
export async function getMySupplier() {
  const res = await fetch(`${API_BASE_URL}/api/suppliers/me/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    return null;
  }
  return res.json();
}
export async function getProducts() {
  const res = await fetch(`${API_BASE_URL}/api/products/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch products');
  }
  return res.json();
}
export async function createProduct(data) {
  const res = await fetch(`${API_BASE_URL}/api/products/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function updateProduct(id, data) {
  const res = await fetch(`${API_BASE_URL}/api/products/${id}/`, {
    method: 'PATCH',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function deleteProduct(id) {
  const res = await fetch(`${API_BASE_URL}/api/products/${id}/`, {
    method: 'DELETE',
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  return res.ok;
}
export async function getOrders() {
  const res = await fetch(`${API_BASE_URL}/api/orders/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch orders');
  }
  return res.json();
}
export async function getComplaints() {
  const res = await fetch(`${API_BASE_URL}/api/complaints/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch complaints');
  }
  return res.json();
}
export async function createComplaint(data) {
  const res = await fetch(`${API_BASE_URL}/api/complaints/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function updateComplaint(id, data) {
  const res = await fetch(`${API_BASE_URL}/api/complaints/${id}/`, {
    method: 'PATCH',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function forwardComplaint(id) {
  const res = await fetch(`${API_BASE_URL}/api/complaints/${id}/forward_to_manager/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to forward complaint');
  }
  return res.json();
}
export async function resolveComplaint(id) {
  const res = await fetch(`${API_BASE_URL}/api/complaints/${id}/resolve/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to resolve complaint');
  }
  return res.json();
}
export async function getStaff() {
  const res = await fetch(`${API_BASE_URL}/api/staff/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch staff');
  }
  return res.json();
}
export async function getUserRole() {
  const res = await fetch(`${API_BASE_URL}/api/staff/my_role/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    return { role: 'owner' };
  }
  return res.json();
}
export async function getCategories() {
  const res = await fetch(`${API_BASE_URL}/api/categories/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch categories');
  }
  return res.json();
}
export async function createCategory(data) {
  const res = await fetch(`${API_BASE_URL}/api/categories/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function createStaff(data) {
  const res = await fetch(`${API_BASE_URL}/api/staff/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function deleteStaff(id) {
  const res = await fetch(`${API_BASE_URL}/api/staff/${id}/delete_account/`, {
    method: 'DELETE',
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  return res.ok;
}
export async function deactivateSupplier(id) {
  const res = await fetch(`${API_BASE_URL}/api/suppliers/${id}/deactivate/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  return res.ok;
}
export async function markOrderAsDone(id) {
  const res = await fetch(`${API_BASE_URL}/api/orders/${id}/mark_as_done/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function getChatConversations() {
  const res = await fetch(`${API_BASE_URL}/api/chat/conversations/`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch conversations');
  }
  return res.json();
}
export async function createChatConversation(data) {
  const res = await fetch(`${API_BASE_URL}/api/chat/conversations/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
export async function getChatMessages(conversationId) {
  const res = await fetch(`${API_BASE_URL}/api/chat/messages/?conversation=${conversationId}`, {
    headers: getAuthHeaders(),
    mode: 'cors'
  });
  if (!res.ok) {
    throw new Error('Failed to fetch messages');
  }
  return res.json();
}
export async function createChatMessage(data) {
  const res = await fetch(`${API_BASE_URL}/api/chat/messages/`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify(data),
    mode: 'cors'
  });
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(JSON.stringify(error));
  }
  return res.json();
}
