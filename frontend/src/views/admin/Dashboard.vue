<template>
  <div class="dashboard-page">
    <div class="stats-grid">
      <div class="stat-card animate__animated animate__fadeInUp">
        <div class="stat-icon" style="background: linear-gradient(135deg, #667eea, #764ba2)">
          <el-icon :size="32"><OfficeBuilding /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ stats.totalRooms }}</span>
          <span class="stat-label">总房间数</span>
        </div>
      </div>
      
      <div class="stat-card animate__animated animate__fadeInUp" style="animation-delay: 0.1s">
        <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c)">
          <el-icon :size="32"><Calendar /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ stats.totalBookings }}</span>
          <span class="stat-label">总预订数</span>
        </div>
      </div>
      
      <div class="stat-card animate__animated animate__fadeInUp" style="animation-delay: 0.2s">
        <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe)">
          <el-icon :size="32"><User /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ stats.totalUsers }}</span>
          <span class="stat-label">注册用户</span>
        </div>
      </div>
      
      <div class="stat-card animate__animated animate__fadeInUp" style="animation-delay: 0.3s">
        <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7)">
          <el-icon :size="32"><Money /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">¥{{ stats.totalRevenue }}</span>
          <span class="stat-label">总收入</span>
        </div>
      </div>
    </div>
    
    <div class="dashboard-content">
      <el-row :gutter="20">
        <el-col :span="16">
          <el-card class="recent-bookings">
            <template #header>
              <div class="card-header">
                <span>最近预订</span>
                <router-link to="/admin/bookings">
                  <el-button type="primary" text>查看全部</el-button>
                </router-link>
              </div>
            </template>
            
            <el-table :data="recentBookings" v-loading="loading">
              <el-table-column prop="id" label="订单号" width="80" />
              <el-table-column prop="user.username" label="用户" width="100" />
              <el-table-column label="房间">
                <template #default="{ row }">
                  {{ row.room?.room_number }} - {{ row.room?.room_type?.name }}
                </template>
              </el-table-column>
              <el-table-column prop="check_in_date" label="入住日期" width="120" />
              <el-table-column prop="total_price" label="金额" width="100">
                <template #default="{ row }">
                  ¥{{ row.total_price }}
                </template>
              </el-table-column>
              <el-table-column prop="status" label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="getStatusType(row.status)" size="small">
                    {{ getStatusLabel(row.status) }}
                  </el-tag>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
        
        <el-col :span="8">
          <el-card class="room-status">
            <template #header>
              <span>房间状态统计</span>
            </template>
            
            <div class="status-list">
              <div class="status-item">
                <span class="status-label">空闲</span>
                <el-progress
                  :percentage="getPercentage('available')"
                  :stroke-width="12"
                  status="success"
                />
                <span class="status-count">{{ roomStatus.available || 0 }}</span>
              </div>
              <div class="status-item">
                <span class="status-label">已入住</span>
                <el-progress
                  :percentage="getPercentage('occupied')"
                  :stroke-width="12"
                  color="#e6a23c"
                />
                <span class="status-count">{{ roomStatus.occupied || 0 }}</span>
              </div>
              <div class="status-item">
                <span class="status-label">维护中</span>
                <el-progress
                  :percentage="getPercentage('maintenance')"
                  :stroke-width="12"
                  color="#f56c6c"
                />
                <span class="status-count">{{ roomStatus.maintenance || 0 }}</span>
              </div>
              <div class="status-item">
                <span class="status-label">清洁中</span>
                <el-progress
                  :percentage="getPercentage('cleaning')"
                  :stroke-width="12"
                  color="#909399"
                />
                <span class="status-count">{{ roomStatus.cleaning || 0 }}</span>
              </div>
            </div>
          </el-card>
          
          <el-card class="quick-actions">
            <template #header>
              <span>快捷操作</span>
            </template>
            
            <div class="actions-grid">
              <router-link to="/admin/rooms" class="action-item">
                <el-icon :size="24"><OfficeBuilding /></el-icon>
                <span>房间管理</span>
              </router-link>
              <router-link to="/admin/bookings" class="action-item">
                <el-icon :size="24"><Calendar /></el-icon>
                <span>预订管理</span>
              </router-link>
              <router-link to="/admin/users" class="action-item">
                <el-icon :size="24"><User /></el-icon>
                <span>用户管理</span>
              </router-link>
              <router-link to="/admin/reviews" class="action-item">
                <el-icon :size="24"><ChatDotRound /></el-icon>
                <span>评论管理</span>
              </router-link>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { systemApi } from '@/api/system'

const loading = ref(false)
const stats = reactive({
  totalRooms: 0,
  totalBookings: 0,
  totalUsers: 0,
  totalRevenue: 0,
})

const roomStatus = reactive({
  available: 0,
  occupied: 0,
  maintenance: 0,
  cleaning: 0,
})

const recentBookings = ref([])

const getStatusType = (status) => {
  const types = {
    pending: 'warning',
    confirmed: 'primary',
    checked_in: 'success',
    checked_out: 'info',
    cancelled: 'danger',
  }
  return types[status] || 'info'
}

const getStatusLabel = (status) => {
  const labels = {
    pending: '待确认',
    confirmed: '已确认',
    checked_in: '已入住',
    checked_out: '已完成',
    cancelled: '已取消',
  }
  return labels[status] || status
}

const getPercentage = (status) => {
  const total = Object.values(roomStatus).reduce((a, b) => a + b, 0)
  if (total === 0) return 0
  return Math.round((roomStatus[status] / total) * 100)
}

const fetchStats = async () => {
  loading.value = true
  try {
    const res = await systemApi.getDashboardStats()
    
    stats.totalRooms = res.total_rooms
    stats.totalBookings = res.total_bookings
    stats.totalUsers = res.total_users
    stats.totalRevenue = res.total_revenue
    
    Object.assign(roomStatus, res.room_status)
    recentBookings.value = res.recent_bookings
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchStats()
})
</script>

<style lang="scss" scoped>
.dashboard-page {
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
    margin-bottom: 20px;
    
    @media (max-width: 1200px) {
      grid-template-columns: repeat(2, 1fr);
    }
    
    @media (max-width: 768px) {
      grid-template-columns: 1fr;
    }
    
    .stat-card {
      background: #fff;
      border-radius: 12px;
      padding: 25px;
      display: flex;
      align-items: center;
      gap: 20px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      .stat-icon {
        width: 64px;
        height: 64px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
      }
      
      .stat-info {
        .stat-value {
          display: block;
          font-size: 28px;
          font-weight: bold;
          color: var(--text-primary);
        }
        
        .stat-label {
          color: var(--text-secondary);
          font-size: 14px;
        }
      }
    }
  }
  
  .dashboard-content {
    .el-card {
      border-radius: 12px;
      margin-bottom: 20px;
      
      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
    }
    
    .room-status {
      .status-list {
        .status-item {
          margin-bottom: 20px;
          
          &:last-child {
            margin-bottom: 0;
          }
          
          .status-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
          }
          
          .status-count {
            display: block;
            text-align: right;
            margin-top: 5px;
            color: var(--text-secondary);
          }
        }
      }
    }
    
    .quick-actions {
      .actions-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
        
        .action-item {
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 10px;
          padding: 20px;
          background: #f5f7fa;
          border-radius: 10px;
          color: var(--text-regular);
          transition: all 0.3s ease;
          
          &:hover {
            background: var(--primary-color);
            color: #fff;
            transform: translateY(-3px);
          }
        }
      }
    }
  }
}
</style>
