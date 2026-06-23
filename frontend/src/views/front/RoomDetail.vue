<template>
  <div class="room-detail-page" v-loading="loading">
    <template v-if="roomType">
      <div class="page-header">
        <div class="header-content">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item :to="{ path: '/rooms' }">房间列表</el-breadcrumb-item>
            <el-breadcrumb-item>{{ roomType.name }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
      </div>
      
      <div class="detail-container">
        <div class="gallery-section">
          <div class="main-image">
            <img :src="currentImage" :alt="roomType.name" />
          </div>
          <div class="thumbnails">
            <div
              v-for="(img, index) in roomImages"
              :key="index"
              class="thumbnail"
              :class="{ active: currentImage === img }"
              @click="currentImage = img"
            >
              <img :src="img" :alt="`${roomType.name} - ${index + 1}`" />
            </div>
          </div>
        </div>
        
        <div class="info-section">
          <h1 class="room-title">{{ roomType.name }}</h1>
          <div class="room-rating">
            <el-rate :model-value="4.5" disabled show-score text-color="#ff9900" />
            <span class="review-count">({{ reviews.length }}条评价)</span>
          </div>
          
          <div class="room-meta">
            <div class="meta-item">
              <el-icon :size="24"><User /></el-icon>
              <span>容纳{{ roomType.capacity }}人</span>
            </div>
            <div class="meta-item">
              <el-icon :size="24"><Grid /></el-icon>
              <span>{{ roomType.size }}㎡</span>
            </div>
            <div class="meta-item">
              <el-icon :size="24"><Bed /></el-icon>
              <span>大床/双床</span>
            </div>
          </div>
          
          <div class="price-section">
            <div class="price-info">
              <span class="price-label">每晚价格</span>
              <span class="price-value">¥{{ roomType.price }}</span>
            </div>
          </div>
          
          <div class="description-section">
            <h3>房间描述</h3>
            <p>{{ roomType.description }}</p>
          </div>
          
          <div class="amenities-section">
            <h3>房间设施</h3>
            <div class="amenities-grid">
              <div v-for="amenity in roomType.amenities" :key="amenity" class="amenity-item">
                <el-icon color="#67C23A"><CircleCheck /></el-icon>
                <span>{{ amenity }}</span>
              </div>
            </div>
          </div>
          
          <div class="booking-section">
            <h3>预订信息</h3>
            <el-form :model="bookingForm" label-width="100px">
              <el-form-item label="入住日期">
                <el-date-picker
                  v-model="bookingForm.check_in"
                  type="date"
                  placeholder="选择入住日期"
                  :disabled-date="disabledDate"
                  format="YYYY-MM-DD"
                  value-format="YYYY-MM-DD"
                />
              </el-form-item>
              <el-form-item label="退房日期">
                <el-date-picker
                  v-model="bookingForm.check_out"
                  type="date"
                  placeholder="选择退房日期"
                  :disabled-date="disabledDate"
                  format="YYYY-MM-DD"
                  value-format="YYYY-MM-DD"
                />
              </el-form-item>
              <el-form-item label="入住人数">
                <el-input-number v-model="bookingForm.guests" :min="1" :max="roomType.capacity" />
              </el-form-item>
              <el-form-item v-if="totalPrice > 0" label="总价">
                <span class="total-price">¥{{ totalPrice }}</span>
                <span class="price-detail">({{ nights }}晚 × ¥{{ roomType.price }}/晚)</span>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" size="large" :disabled="!canBook" @click="handleBooking">
                  立即预订
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </div>
      
      <div class="reviews-section">
        <h2>用户评价</h2>
        <div class="reviews-list" v-loading="reviewsLoading">
          <div v-for="review in reviews" :key="review.id" class="review-item">
            <div class="review-header">
              <el-avatar :size="48" :src="review.user_avatar">
                {{ review.username?.charAt(0).toUpperCase() }}
              </el-avatar>
              <div class="review-meta">
                <span class="reviewer-name">{{ review.username }}</span>
                <el-rate v-model="review.rating" disabled />
              </div>
              <span class="review-date">{{ formatDate(review.created_at) }}</span>
            </div>
            <h4 class="review-title">{{ review.title }}</h4>
            <p class="review-content">{{ review.content }}</p>
          </div>
          <el-empty v-if="!reviewsLoading && reviews.length === 0" description="暂无评价" />
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { roomApi } from '@/api/room'
import { reviewApi } from '@/api/review'
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const reviewsLoading = ref(false)
const roomType = ref(null)
const reviews = ref([])
const currentImage = ref('')

const defaultImages = [
  'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
  'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
  'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
  'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=800',
]

const roomImages = computed(() => {
  if (roomType.value?.images?.length) {
    return roomType.value.images
  }
  return defaultImages
})

const bookingForm = ref({
  check_in: '',
  check_out: '',
  guests: 1,
})

const disabledDate = (date) => {
  return date < new Date(new Date().setHours(0, 0, 0, 0))
}

const nights = computed(() => {
  if (bookingForm.value.check_in && bookingForm.value.check_out) {
    return dayjs(bookingForm.value.check_out).diff(dayjs(bookingForm.value.check_in), 'day')
  }
  return 0
})

const totalPrice = computed(() => {
  if (nights.value > 0 && roomType.value) {
    return nights.value * roomType.value.price
  }
  return 0
})

const canBook = computed(() => {
  return bookingForm.value.check_in && bookingForm.value.check_out && nights.value > 0
})

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD')

const fetchRoomType = async () => {
  loading.value = true
  try {
    const res = await roomApi.getType(route.params.id)
    roomType.value = res
    currentImage.value = roomImages.value[0]
    bookingForm.value.guests = 1
  } finally {
    loading.value = false
  }
}

const fetchReviews = async () => {
  reviewsLoading.value = true
  try {
    const res = await reviewApi.getList({ room_type: route.params.id })
    reviews.value = res.results || res
  } finally {
    reviewsLoading.value = false
  }
}

const handleBooking = () => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push({ name: 'Login', query: { redirect: route.fullPath } })
    return
  }
  
  router.push({
    name: 'Booking',
    params: { roomId: route.params.id },
    query: {
      check_in: bookingForm.value.check_in,
      check_out: bookingForm.value.check_out,
      guests: bookingForm.value.guests,
    },
  })
}

onMounted(() => {
  fetchRoomType()
  fetchReviews()
})
</script>

<style lang="scss" scoped>
.room-detail-page {
  min-height: 100vh;
  background: #f5f7fa;
  
  .page-header {
    background: #fff;
    padding: 20px;
    border-bottom: 1px solid var(--border-light);
    
    .header-content {
      max-width: 1200px;
      margin: 0 auto;
    }
  }
  
  .detail-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 30px 20px;
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 30px;
    
    @media (max-width: 992px) {
      grid-template-columns: 1fr;
    }
  }
  
  .gallery-section {
    .main-image {
      border-radius: 16px;
      overflow: hidden;
      margin-bottom: 15px;
      
      img {
        width: 100%;
        height: 400px;
        object-fit: cover;
      }
    }
    
    .thumbnails {
      display: flex;
      gap: 10px;
      overflow-x: auto;
      
      .thumbnail {
        flex-shrink: 0;
        width: 80px;
        height: 60px;
        border-radius: 8px;
        overflow: hidden;
        cursor: pointer;
        border: 2px solid transparent;
        transition: all 0.3s ease;
        
        &.active {
          border-color: var(--primary-color);
        }
        
        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }
    }
  }
  
  .info-section {
    background: #fff;
    border-radius: 16px;
    padding: 25px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    
    .room-title {
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 15px;
    }
    
    .room-rating {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
      
      .review-count {
        color: var(--text-secondary);
        font-size: 14px;
      }
    }
    
    .room-meta {
      display: flex;
      gap: 25px;
      padding: 20px 0;
      border-top: 1px solid var(--border-light);
      border-bottom: 1px solid var(--border-light);
      margin-bottom: 20px;
      
      .meta-item {
        display: flex;
        align-items: center;
        gap: 8px;
        color: var(--text-regular);
      }
    }
    
    .price-section {
      background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
      padding: 20px;
      border-radius: 12px;
      margin-bottom: 25px;
      
      .price-info {
        .price-label {
          font-size: 14px;
          color: var(--text-secondary);
        }
        
        .price-value {
          font-size: 36px;
          font-weight: bold;
          color: var(--primary-color);
          margin-left: 10px;
        }
      }
    }
    
    .description-section,
    .amenities-section,
    .booking-section {
      margin-bottom: 25px;
      
      h3 {
        font-size: 18px;
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 2px solid var(--primary-color);
        display: inline-block;
      }
    }
    
    .amenities-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;
      
      .amenity-item {
        display: flex;
        align-items: center;
        gap: 8px;
        color: var(--text-regular);
      }
    }
    
    .total-price {
      font-size: 28px;
      font-weight: bold;
      color: var(--primary-color);
    }
    
    .price-detail {
      color: var(--text-secondary);
      margin-left: 10px;
    }
  }
  
  .reviews-section {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px 40px;
    
    h2 {
      font-size: 24px;
      margin-bottom: 25px;
    }
    
    .review-item {
      background: #fff;
      padding: 25px;
      border-radius: 12px;
      margin-bottom: 15px;
      
      .review-header {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 15px;
        
        .review-meta {
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 5px;
          
          .reviewer-name {
            font-weight: 600;
          }
        }
        
        .review-date {
          color: var(--text-secondary);
          font-size: 14px;
        }
      }
      
      .review-title {
        font-size: 16px;
        margin-bottom: 10px;
      }
      
      .review-content {
        color: var(--text-secondary);
        line-height: 1.8;
      }
    }
  }
}
</style>
