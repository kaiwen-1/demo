import api from './index'

export const systemApi = {
  getConfigs: (params) => api.get('/system/configs/', { params }),
  getConfig: (key) => api.get('/system/configs/', { params: { key } }),
  createConfig: (data) => api.post('/system/configs/', data),
  updateConfig: (key, data) => api.patch(`/system/configs/${key}/`, data),
  deleteConfig: (key) => api.delete(`/system/configs/${key}/`),
  
  getSystemInfo: () => api.get('/system/info/'),
  getDatabaseStatus: () => api.get('/system/database-status/'),
  backupDatabase: () => api.post('/system/backup/'),
  clearCache: () => api.post('/system/clear-cache/'),
  getDashboardStats: () => api.get('/system/dashboard-stats/'),
}
