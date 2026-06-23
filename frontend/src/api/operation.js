import api from './index'

export const operationApi = {
  getBanners: (params) => api.get('/operations/banners/', { params }),
  getActiveBanners: () => api.get('/operations/banners/', { params: { active_only: true } }),
  getBanner: (id) => api.get(`/operations/banners/${id}/`),
  createBanner: (data) => api.post('/operations/banners/', data),
  updateBanner: (id, data) => api.patch(`/operations/banners/${id}/`, data),
  deleteBanner: (id) => api.delete(`/operations/banners/${id}/`),
  
  getPromotions: (params) => api.get('/operations/promotions/', { params }),
  getActivePromotions: () => api.get('/operations/promotions/', { params: { active_only: true } }),
  getPromotion: (id) => api.get(`/operations/promotions/${id}/`),
  createPromotion: (data) => api.post('/operations/promotions/', data),
  updatePromotion: (id, data) => api.patch(`/operations/promotions/${id}/`, data),
  deletePromotion: (id) => api.delete(`/operations/promotions/${id}/`),
  
  getCoupons: (params) => api.get('/operations/coupons/', { params }),
  getCoupon: (id) => api.get(`/operations/coupons/${id}/`),
  createCoupon: (data) => api.post('/operations/coupons/', data),
  updateCoupon: (id, data) => api.patch(`/operations/coupons/${id}/`, data),
  deleteCoupon: (id) => api.delete(`/operations/coupons/${id}/`),
  claimCoupon: (id) => api.post(`/operations/coupons/${id}/claim/`),
  claimCouponByCode: (code) => api.post('/operations/coupons/claim_by_code/', { code }),
  
  getUserCoupons: (params) => api.get('/operations/user-coupons/', { params }),
  getAvailableCoupons: () => api.get('/operations/user-coupons/available/'),
}
