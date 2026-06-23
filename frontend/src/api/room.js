import api from './index'

export const roomApi = {
  getTypes: (params) => api.get('/rooms/types/', { params }),
  getType: (id) => api.get(`/rooms/types/${id}/`),
  createType: (data) => api.post('/rooms/types/', data),
  updateType: (id, data) => api.patch(`/rooms/types/${id}/`, data),
  deleteType: (id) => api.delete(`/rooms/types/${id}/`),
  createTypeWithImage: (formData) => api.post('/rooms/types/', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }),
  updateTypeWithImage: (id, formData) => api.patch(`/rooms/types/${id}/`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }),
  
  getList: (params) => api.get('/rooms/', { params }),
  getAvailable: (params) => api.get('/rooms/available/', { params }),
  getRoom: (id) => api.get(`/rooms/${id}/`),
  createRoom: (data) => api.post('/rooms/', data),
  updateRoom: (id, data) => api.patch(`/rooms/${id}/`, data),
  deleteRoom: (id) => api.delete(`/rooms/${id}/`),
  changeStatus: (id, status) => api.post(`/rooms/${id}/change_status/`, { status }),
}
