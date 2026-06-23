import api from './index'

export const reviewApi = {
  getList: (params) => api.get('/reviews/', { params }),
  getReview: (id) => api.get(`/reviews/${id}/`),
  createReview: (data) => api.post('/reviews/', data),
  updateReview: (id, data) => api.patch(`/reviews/${id}/`, data),
  deleteReview: (id) => api.delete(`/reviews/${id}/`),
}
