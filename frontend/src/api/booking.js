import api from './index'

export const bookingApi = {
  getList: (params) => api.get('/bookings/', { params }),
  getBooking: (id) => api.get(`/bookings/${id}/`),
  createBooking: (data) => api.post('/bookings/', data),
  updateBooking: (id, data) => api.patch(`/bookings/${id}/`, data),
  deleteBooking: (id) => api.delete(`/bookings/${id}/`),
  confirm: (id) => api.post(`/bookings/${id}/confirm/`),
  checkIn: (id) => api.post(`/bookings/${id}/check_in/`),
  checkOut: (id) => api.post(`/bookings/${id}/check_out/`),
  cancel: (id) => api.post(`/bookings/${id}/cancel/`),
  
  getRecords: (params) => api.get('/bookings/records/', { params }),
  getRecord: (id) => api.get(`/bookings/records/${id}/`),
  returnDeposit: (id) => api.post(`/bookings/records/${id}/return_deposit/`),
}
