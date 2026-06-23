import api from './index'

export const favoriteApi = {
  getList: (params) => api.get('/favorites/', { params }),
  add: (roomTypeId) => api.post('/favorites/', { room_type: roomTypeId }),
  remove: (id) => api.delete(`/favorites/${id}/`),
  toggle: (roomTypeId) => api.post('/favorites/toggle/', { room_type: roomTypeId }),
  check: (roomTypeId) => api.get('/favorites/check/', { params: { room_type: roomTypeId } }),
}
