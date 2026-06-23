import api from './index'

export const tagApi = {
  getList: (params) => api.get('/tags/tags/', { params }),
  get: (id) => api.get(`/tags/tags/${id}/`),
  create: (data) => api.post('/tags/tags/', data),
  update: (id, data) => api.patch(`/tags/tags/${id}/`, data),
  delete: (id) => api.delete(`/tags/tags/${id}/`),
  getRoomTypes: (id) => api.get(`/tags/tags/${id}/room_types/`),
  batchAssign: (roomTypeId, tagIds) => api.post('/tags/tags/batch_assign/', { room_type_id: roomTypeId, tag_ids: tagIds }),
  
  getRoomTypeTags: (params) => api.get('/tags/room-type-tags/', { params }),
}
