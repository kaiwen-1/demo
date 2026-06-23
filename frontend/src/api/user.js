import api from './index'

export const userApi = {
  login: (data) => api.post('/users/login/', data),
  logout: () => api.post('/users/logout/'),
  register: (data) => api.post('/users/', data),
  registerWithAvatar: (formData) => api.post('/users/', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  }),
  getProfile: () => api.get('/users/me/'),
  updateProfile: (data) => api.patch('/users/me/', data),
  updateProfileWithAvatar: (id, formData) => api.patch(`/users/${id}/`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  }),
  changePassword: (data) => api.post('/users/change_password/', data),
  getList: (params) => api.get('/users/', { params }),
  getUser: (id) => api.get(`/users/${id}/`),
  updateUser: (id, data) => api.patch(`/users/${id}/`, data),
  updateUserWithAvatar: (id, formData) => api.patch(`/users/${id}/`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  }),
  deleteUser: (id) => api.delete(`/users/${id}/`),
}
