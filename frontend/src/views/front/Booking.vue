<template>
  <div class="booking-page">
    <div class="page-header">
      <h1>预订房间</h1>
      <p>请填写预订信息，完成您的预订</p>
    </div>
    
    <div class="booking-container" v-loading="loading">
      <div class="room-summary">
        <img :src="roomType?.image || defaultImage" :alt="roomType?.name" class="room-image" />
        <div class="room-info">
          <h2>{{ roomType?.name }}</h2>
          <div class="room-meta">
            <span><el-icon><User /></el-icon> {{ roomType?.capacity }}人</span>
            <span><el-icon><Grid /></el-icon> {{ roomType?.size }}㎡</span>
          </div>
          <div class="room-price">
            <span class="label">每晚价格</span>
            <span class="value">¥{{ roomType?.price }}</span>
          </div>
        </div>
      </div>
      
      <el-form
        ref="formRef"
        :model="bookingForm"
        :rules="rules"
        label-width="120px"
        class="booking-form"
      >
        <h3 class="section-title">入住信息</h3>
        
        <el-form-item label="入住日期" prop="check_in_date">
          <el-date-picker
            v-model="bookingForm.check_in_date"
            type="date"
            placeholder="选择入住日期"
            :disabled-date="disabledDate"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        
        <el-form-item label="退房日期" prop="check_out_date">
          <el-date-picker
            v-model="bookingForm.check_out_date"
            type="date"
            placeholder="选择退房日期"
            :disabled-date="disabledDate"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        
        <el-form-item label="入住人数" prop="guests">
          <el-input-number v-model="bookingForm.guests" :min="1" :max="roomType?.capacity || 10" />
        </el-form-item>
        
        <el-form-item label="特殊要求">
          <el-input
            v-model="bookingForm.special_requests"
            type="textarea"
            :rows="3"
            placeholder="如有特殊要求请在此填写"
          />
        </el-form-item>
        
        <h3 class="section-title">联系人信息</h3>
        
        <el-form-item label="联系人姓名" prop="contact_name">
          <el-input v-model="bookingForm.contact_name" placeholder="请输入联系人姓名" />
        </el-form-item>
        
        <el-form-item label="联系电话" prop="contact_phone">
          <el-input v-model="bookingForm.contact_phone" placeholder="请输入联系电话" />
        </el-form-item>
        
        <div class="price-summary">
          <h3 class="section-title">费用明细</h3>
          <div class="summary-item">
            <span>入住天数</span>
            <span>{{ nights }}晚</span>
          </div>
          <div class="summary-item">
            <span>房间单价</span>
            <span>¥{{ roomType?.price }}/晚</span>
          </div>
          <div class="summary-item total">
            <span>总价</span>
            <span>¥{{ totalPrice }}</span>
          </div>
        </div>
        
        <el-form-item>
          <el-button type="primary" size="large" :loading="submitting" @click="handleSubmit">
            确认预订
          </el-button>
          <el-button size="large" @click="$router.back()">返回</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { roomApi } from '@/api/room'
import { bookingApi } from '@/api/booking'
import { paymentApi } from '@/api/payment'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const submitting = ref(false)
const formRef = ref(null)
const roomType = ref(null)
const defaultImage = 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800'

const bookingForm = ref({
  room: null,
  check_in_date: route.query.check_in || '',
  check_out_date: route.query.check_out || '',
  guests: Number(route.query.guests) || 1,
  special_requests: '',
  contact_name: '',
  contact_phone: '',
})

const rules = {
  check_in_date: [{ required: true, message: '请选择入住日期', trigger: 'change' }],
  check_out_date: [{ required: true, message: '请选择退房日期', trigger: 'change' }],
  guests: [{ required: true, message: '请选择入住人数', trigger: 'change' }],
  contact_name: [{ required: true, message: '请输入联系人姓名', trigger: 'blur' }],
  contact_phone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' },
  ],
}

const disabledDate = (date) => {
  return date < new Date(new Date().setHours(0, 0, 0, 0))
}

const nights = computed(() => {
  if (bookingForm.value.check_in_date && bookingForm.value.check_out_date) {
    return dayjs(bookingForm.value.check_out_date).diff(dayjs(bookingForm.value.check_in_date), 'day')
  }
  return 0
})

const totalPrice = computed(() => {
  if (nights.value > 0 && roomType.value) {
    return nights.value * roomType.value.price
  }
  return 0
})

const fetchRoomType = async () => {
  loading.value = true
  try {
    const res = await roomApi.getType(route.params.roomId)
    roomType.value = res
    bookingForm.value.guests = Math.min(bookingForm.value.guests, res.capacity)
    
    const roomsRes = await roomApi.getList({ room_type: res.id, status: 'available' })
    if (roomsRes.results?.length > 0 || roomsRes.length > 0) {
      const rooms = roomsRes.results || roomsRes
      bookingForm.value.room = rooms[0].id
    }
  } finally {
    loading.value = false
  }
}

const handleSubmit = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
  } catch {
    return
  }
  
  if (nights.value <= 0) {
    ElMessage.error('退房日期必须晚于入住日期')
    return
  }
  
  if (!bookingForm.value.room) {
    ElMessage.error('该房型暂无可用房间')
    return
  }
  
  submitting.value = true
  try {
    const bookingRes = await bookingApi.createBooking(bookingForm.value)
    ElMessage.success('预订创建成功，请完成支付')
    
    const paymentRes = await paymentApi.createPayment({
      booking: bookingRes.id,
      payment_method: 'alipay'
    })
    
    router.push({ name: 'Payment', params: { id: paymentRes.id } })
  } catch (error) {
    console.error('预订或支付创建失败:', error)
    ElMessage.error(error.response?.data?.error || error.response?.data?.detail || '预订失败，请重试')
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push({ name: 'Login', query: { redirect: route.fullPath } })
    return
  }
  
  bookingForm.value.contact_name = userStore.user?.username || ''
  bookingForm.value.contact_phone = userStore.user?.phone || ''
  
  fetchRoomType()
})
</script>

<style lang="scss" scoped>
.booking-page {
  min-height: 100vh;
  background: #f5f7fa;
  
  .page-header {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
    padding: 50px 20px;
    text-align: center;
    color: #fff;
    
    h1 {
      font-size: 36px;
      margin-bottom: 10px;
      background: linear-gradient(135deg, var(--primary-color), #a855f7);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    p {
      color: rgba(255, 255, 255, 0.8);
    }
  }
  
  .booking-container {
    max-width: 800px;
    margin: -30px auto 40px;
    padding: 0 20px;
    position: relative;
    z-index: 1;
  }
  
  .room-summary {
    background: #fff;
    border-radius: 16px;
    overflow: hidden;
    margin-bottom: 20px;
    display: flex;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    
    @media (max-width: 768px) {
      flex-direction: column;
    }
    
    .room-image {
      width: 250px;
      height: 180px;
      object-fit: cover;
      
      @media (max-width: 768px) {
        width: 100%;
        height: 200px;
      }
    }
    
    .room-info {
      flex: 1;
      padding: 20px;
      
      h2 {
        font-size: 22px;
        margin-bottom: 15px;
      }
      
      .room-meta {
        display: flex;
        gap: 20px;
        margin-bottom: 15px;
        color: var(--text-secondary);
        
        span {
          display: flex;
          align-items: center;
          gap: 5px;
        }
      }
      
      .room-price {
        .label {
          color: var(--text-secondary);
          margin-right: 10px;
        }
        
        .value {
          font-size: 28px;
          font-weight: bold;
          color: var(--primary-color);
        }
      }
    }
  }
  
  .booking-form {
    background: #fff;
    border-radius: 16px;
    padding: 30px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    
    .section-title {
      font-size: 18px;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 2px solid var(--primary-color);
    }
    
    .price-summary {
      background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
      padding: 25px;
      border-radius: 12px;
      margin: 25px 0;
      
      .summary-item {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        
        &.total {
          border-bottom: none;
          padding-top: 15px;
          margin-top: 10px;
          font-size: 20px;
          font-weight: bold;
          color: var(--primary-color);
        }
      }
    }
  }
}
</style>
