import api from './index'

export const notificationApi = {
  getList: (params) => api.get('/notifications/', { params }),
  getUnreadCount: () => api.get('/notifications/unread_count/'),
  markRead: (id) => api.post(`/notifications/${id}/mark_read/`),
  markAllRead: () => api.post('/notifications/mark_all_read/'),
  clearRead: () => api.delete('/notifications/clear_read/'),
  delete: (id) => api.delete(`/notifications/${id}/`),
}
