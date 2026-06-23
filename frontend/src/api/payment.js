import api from './index'

export const paymentApi = {
  getList: (params) => api.get('/payments/', { params }),
  getPayment: (id) => api.get(`/payments/${id}/`),
  createPayment: (data) => api.post('/payments/', data),
  pay: (id) => api.post(`/payments/${id}/pay/`),
  cancel: (id) => api.post(`/payments/${id}/cancel/`),
  refund: (id) => api.post(`/payments/${id}/refund/`),
}
