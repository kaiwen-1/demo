<template>
  <div class="user-bookings-page">
    <div class="page-header">
      <h1>我的预订</h1>
      <p>查看和管理您的预订记录</p>
    </div>
    
    <div class="bookings-container">
      <el-tabs v-model="activeTab" class="bookings-tabs">
        <el-tab-pane label="全部预订" name="all" />
        <el-tab-pane label="待确认" name="pending" />
        <el-tab-pane label="已确认" name="confirmed" />
        <el-tab-pane label="已入住" name="checked_in" />
        <el-tab-pane label="已完成" name="checked_out" />
        <el-tab-pane label="已取消" name="cancelled" />
      </el-tabs>
      
      <div class="bookings-list" v-loading="loading">
        <div
          v-for="booking in filteredBookings"
          :key="booking.id"
          class="booking-card animate__animated animate__fadeInUp"
        >
          <div class="booking-header">
            <div class="booking-info">
              <span class="booking-id">订单号：{{ booking.id }}</span>
              <el-tag :type="getStatusType(booking.status)" size="large">
                {{ getStatusLabel(booking.status) }}
              </el-tag>
            </div>
            <span class="booking-date">{{ formatDate(booking.created_at) }}</span>
          </div>
          
          <div class="booking-body">
            <div class="room-info">
              <img :src="booking.room?.room_type?.image_url || booking.room?.room_type?.image || defaultImage" alt="room" class="room-image" />
              <div class="room-detail">
                <h3>{{ booking.room?.room_type?.name || '房型' }} - {{ booking.room?.room_number }}</h3>
                <div class="stay-info">
                  <span><el-icon><Calendar /></el-icon> {{ booking.check_in_date }}</span>
                  <span>至</span>
                  <span>{{ booking.check_out_date }}</span>
                  <span class="nights">({{ booking.nights }}晚)</span>
                </div>
                <div class="guests-info">
                  <el-icon><User /></el-icon>
                  {{ booking.guests }}人入住
                </div>
              </div>
            </div>
            
            <div class="price-info">
              <div class="total-price">
                <span class="label">订单金额</span>
                <span class="value">¥{{ booking.total_price }}</span>
              </div>
            </div>
          </div>
          
          <div class="booking-footer">
            <div class="contact-info">
              <span>联系人：{{ booking.contact_name }}</span>
              <span>电话：{{ booking.contact_phone }}</span>
            </div>
            <div class="actions">
              <el-button
                v-if="booking.status === 'pending' && !booking.payment"
                type="primary"
                @click="goToPay(booking)"
              >
                去支付
              </el-button>
              <el-button
                v-if="booking.status === 'pending' || booking.status === 'confirmed'"
                type="danger"
                text
                @click="handleCancel(booking)"
              >
                取消预订
              </el-button>
              <el-button type="primary" text @click="viewDetail(booking)">
                查看详情
              </el-button>
            </div>
          </div>
        </div>
        
        <el-empty v-if="!loading && filteredBookings.length === 0" description="暂无预订记录">
          <router-link to="/rooms">
            <el-button type="primary">去预订房间</el-button>
          </router-link>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { bookingApi } from '@/api/booking'
import { paymentApi } from '@/api/payment'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'

const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const bookings = ref([])
const activeTab = ref('all')
const defaultImage = 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800'

const filteredBookings = computed(() => {
  if (activeTab.value === 'all') {
    return bookings.value
  }
  return bookings.value.filter((b) => b.status === activeTab.value)
})

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

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

const fetchBookings = async () => {
  loading.value = true
  try {
    const res = await bookingApi.getList()
    bookings.value = res.results || res
  } finally {
    loading.value = false
  }
}

const handleCancel = async (booking) => {
  await ElMessageBox.confirm('确定要取消此预订吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await bookingApi.cancel(booking.id)
  ElMessage.success('取消成功')
  fetchBookings()
}

const goToPay = async (booking) => {
  try {
    const paymentRes = await paymentApi.createPayment({
      booking: booking.id,
      payment_method: 'alipay'
    })
    router.push({ name: 'Payment', params: { id: paymentRes.id } })
  } catch (error) {
    ElMessage.error('创建支付订单失败')
  }
}

const viewDetail = (booking) => {
  ElMessage.info('订单详情功能开发中')
}

onMounted(() => {
  fetchBookings()
})
</script>

<style lang="scss" scoped>
.user-bookings-page {
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
  
  .bookings-container {
    max-width: 1000px;
    margin: -20px auto 40px;
    padding: 0 20px;
    
    .bookings-tabs {
      background: #fff;
      border-radius: 12px;
      padding: 10px 20px;
      margin-bottom: 20px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    }
  }
  
  .bookings-list {
    .booking-card {
      background: #fff;
      border-radius: 12px;
      margin-bottom: 15px;
      overflow: hidden;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      .booking-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        background: #f8f9fa;
        border-bottom: 1px solid var(--border-light);
        
        .booking-info {
          display: flex;
          align-items: center;
          gap: 15px;
          
          .booking-id {
            font-weight: 500;
            color: var(--text-secondary);
          }
        }
        
        .booking-date {
          color: var(--text-secondary);
          font-size: 14px;
        }
      }
      
      .booking-body {
        display: flex;
        justify-content: space-between;
        padding: 20px;
        
        @media (max-width: 768px) {
          flex-direction: column;
          gap: 20px;
        }
        
        .room-info {
          display: flex;
          gap: 15px;
          
          .room-image {
            width: 120px;
            height: 90px;
            border-radius: 8px;
            object-fit: cover;
          }
          
          .room-detail {
            h3 {
              font-size: 18px;
              margin-bottom: 10px;
            }
            
            .stay-info {
              display: flex;
              align-items: center;
              gap: 8px;
              color: var(--text-secondary);
              margin-bottom: 8px;
              
              .nights {
                color: var(--primary-color);
              }
            }
            
            .guests-info {
              display: flex;
              align-items: center;
              gap: 5px;
              color: var(--text-secondary);
            }
          }
        }
        
        .price-info {
          text-align: right;
          
          .total-price {
            .label {
              display: block;
              font-size: 14px;
              color: var(--text-secondary);
              margin-bottom: 5px;
            }
            
            .value {
              font-size: 28px;
              font-weight: bold;
              color: var(--primary-color);
            }
          }
        }
      }
      
      .booking-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        border-top: 1px solid var(--border-light);
        background: #fafafa;
        
        @media (max-width: 768px) {
          flex-direction: column;
          gap: 15px;
          align-items: flex-start;
        }
        
        .contact-info {
          display: flex;
          gap: 20px;
          color: var(--text-secondary);
          font-size: 14px;
        }
      }
    }
  }
}
</style>
