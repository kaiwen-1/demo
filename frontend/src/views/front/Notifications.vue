<template>
  <div class="notifications-page">
    <div class="page-header">
      <h1>消息通知</h1>
      <p>您的系统消息和通知</p>
    </div>
    
    <div class="notifications-container">
      <div class="notifications-toolbar">
        <el-tabs v-model="activeTab" @tab-change="handleTabChange">
          <el-tab-pane label="全部" name="all" />
          <el-tab-pane label="未读" name="unread" />
          <el-tab-pane label="已读" name="read" />
        </el-tabs>
        <div class="actions">
          <el-button type="primary" text @click="handleMarkAllRead" :disabled="unreadCount === 0">
            全部标记已读
          </el-button>
          <el-button type="danger" text @click="handleClearRead">
            清除已读消息
          </el-button>
        </div>
      </div>
      
      <div class="notifications-list" v-loading="loading">
        <div 
          v-for="notification in notifications" 
          :key="notification.id" 
          class="notification-item"
          :class="{ unread: !notification.is_read }"
          @click="handleClick(notification)"
        >
          <div class="notification-icon">
            <el-icon :size="24" :color="getIconColor(notification.notification_type)">
              <component :is="getIcon(notification.notification_type)" />
            </el-icon>
          </div>
          <div class="notification-content">
            <div class="notification-header">
              <span class="notification-title">{{ notification.title }}</span>
              <el-tag :type="getTypeTag(notification.notification_type)" size="small">
                {{ notification.type_display }}
              </el-tag>
            </div>
            <p class="notification-text">{{ notification.content }}</p>
            <span class="notification-time">{{ formatDate(notification.created_at) }}</span>
          </div>
          <div class="notification-status">
            <el-icon v-if="!notification.is_read" color="#409EFF"><CircleFilled /></el-icon>
          </div>
        </div>
        
        <el-empty v-if="!loading && notifications.length === 0" description="暂无消息" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { notificationApi } from '@/api/notification'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'

const router = useRouter()
const loading = ref(false)
const notifications = ref([])
const activeTab = ref('all')
const unreadCount = ref(0)

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

const getIcon = (type) => {
  const icons = {
    system: 'Setting',
    booking: 'Calendar',
    payment: 'Wallet',
    promotion: 'Present',
    other: 'Bell',
  }
  return icons[type] || 'Bell'
}

const getIconColor = (type) => {
  const colors = {
    system: '#909399',
    booking: '#409EFF',
    payment: '#67C23A',
    promotion: '#E6A23C',
    other: '#F56C6C',
  }
  return colors[type] || '#909399'
}

const getTypeTag = (type) => {
  const tags = {
    system: 'info',
    booking: 'primary',
    payment: 'success',
    promotion: 'warning',
    other: 'danger',
  }
  return tags[type] || 'info'
}

const fetchNotifications = async () => {
  loading.value = true
  try {
    const params = {}
    if (activeTab.value === 'unread') {
      params.is_read = false
    } else if (activeTab.value === 'read') {
      params.is_read = true
    }
    const res = await notificationApi.getList(params)
    notifications.value = res.results || res
  } finally {
    loading.value = false
  }
}

const fetchUnreadCount = async () => {
  try {
    const res = await notificationApi.getUnreadCount()
    unreadCount.value = res.unread_count
  } catch (error) {
    console.error('获取未读数量失败')
  }
}

const handleTabChange = () => {
  fetchNotifications()
}

const handleClick = async (notification) => {
  if (!notification.is_read) {
    await notificationApi.markRead(notification.id)
    notification.is_read = true
    unreadCount.value = Math.max(0, unreadCount.value - 1)
  }
  
  if (notification.link) {
    router.push(notification.link)
  }
}

const handleMarkAllRead = async () => {
  await notificationApi.markAllRead()
  ElMessage.success('已全部标记为已读')
  fetchNotifications()
  fetchUnreadCount()
}

const handleClearRead = async () => {
  await ElMessageBox.confirm('确定要清除所有已读消息吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await notificationApi.clearRead()
  ElMessage.success('已清除已读消息')
  fetchNotifications()
}

onMounted(() => {
  fetchNotifications()
  fetchUnreadCount()
})
</script>

<style lang="scss" scoped>
.notifications-page {
  min-height: 100vh;
  background: #f5f7fa;
  
  .page-header {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
    padding: 40px 20px;
    text-align: center;
    color: #fff;
    
    h1 {
      font-size: 32px;
      margin-bottom: 10px;
      background: linear-gradient(135deg, var(--primary-color), #a855f7);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    p {
      color: rgba(255, 255, 255, 0.8);
    }
  }
  
  .notifications-container {
    max-width: 800px;
    margin: -20px auto 40px;
    padding: 0 20px;
    
    .notifications-toolbar {
      background: #fff;
      border-radius: 12px;
      padding: 10px 20px;
      margin-bottom: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      .el-tabs {
        flex: 1;
      }
      
      .actions {
        display: flex;
        gap: 10px;
      }
    }
  }
  
  .notifications-list {
    .notification-item {
      background: #fff;
      border-radius: 12px;
      padding: 20px;
      margin-bottom: 15px;
      display: flex;
      gap: 15px;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      &:hover {
        transform: translateX(5px);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
      }
      
      &.unread {
        background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
        border-left: 4px solid #409EFF;
      }
      
      .notification-icon {
        width: 48px;
        height: 48px;
        background: #f5f7fa;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }
      
      .notification-content {
        flex: 1;
        
        .notification-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 8px;
          
          .notification-title {
            font-size: 16px;
            font-weight: 600;
          }
        }
        
        .notification-text {
          color: var(--text-secondary);
          font-size: 14px;
          line-height: 1.6;
          margin-bottom: 8px;
        }
        
        .notification-time {
          font-size: 12px;
          color: var(--text-placeholder);
        }
      }
      
      .notification-status {
        display: flex;
        align-items: center;
      }
    }
  }
}
</style>
