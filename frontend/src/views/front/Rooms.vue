<template>
  <div class="rooms-page">
    <div class="page-header">
      <h1>房间列表</h1>
      <p>选择您心仪的房型，开启舒适之旅</p>
    </div>
    
    <div class="page-container">
      <div class="filter-section">
        <el-form :inline="true" class="filter-form">
          <el-form-item label="入住日期">
            <el-date-picker
              v-model="filters.check_in"
              type="date"
              placeholder="选择入住日期"
              :disabled-date="disabledDate"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
              clearable
            />
          </el-form-item>
          <el-form-item label="退房日期">
            <el-date-picker
              v-model="filters.check_out"
              type="date"
              placeholder="选择退房日期"
              :disabled-date="disabledDate"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
              clearable
            />
          </el-form-item>
          <el-form-item label="房型">
            <el-select v-model="filters.room_type" placeholder="全部房型" clearable style="width: 180px;">
              <el-option
                v-for="type in roomTypes"
                :key="type.id"
                :label="type.name"
                :value="type.id"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="价格范围">
            <el-slider
              v-model="priceRange"
              range
              :min="0"
              :max="2000"
              :step="100"
              :format-tooltip="(val) => `¥${val}`"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" :icon="Search" @click="handleSearch">搜索</el-button>
            <el-button :icon="Refresh" @click="resetFilters">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <div class="rooms-grid" v-loading="loading">
        <div
          v-for="(type, index) in filteredRoomTypes"
          :key="type.id"
          class="room-card hover-lift animate__animated animate__fadeInUp"
          :style="{ animationDelay: `${index * 0.05}s` }"
        >
          <div class="room-image">
            <img :src="type.image || defaultImage" :alt="type.name" />
            <div class="room-badge">¥{{ type.price }}/晚</div>
            <div class="room-overlay">
              <router-link :to="`/rooms/${type.id}`" class="view-btn">
                <el-icon><View /></el-icon>
                查看详情
              </router-link>
            </div>
          </div>
          <div class="room-info">
            <h3 class="room-name">{{ type.name }}</h3>
            <p class="room-desc">{{ type.description }}</p>
            <div class="room-meta">
              <span><el-icon><User /></el-icon> {{ type.capacity }}人</span>
              <span><el-icon><Grid /></el-icon> {{ type.size }}㎡</span>
              <span><el-icon><Bed /></el-icon> 大床/双床</span>
            </div>
            <div class="room-amenities">
              <el-tag v-for="amenity in type.amenities?.slice(0, 4)" :key="amenity" size="small" effect="plain">
                {{ amenity }}
              </el-tag>
            </div>
            <div class="room-footer">
              <div class="room-price">
                <span class="price-label">起价</span>
                <span class="price-value">¥{{ type.price }}</span>
                <span class="price-unit">/晚</span>
              </div>
              <router-link :to="`/booking/${type.id}`" class="btn btn-primary">
                立即预订
              </router-link>
            </div>
          </div>
        </div>
      </div>
      
      <el-empty v-if="!loading && filteredRoomTypes.length === 0" description="暂无符合条件的房间" />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { roomApi } from '@/api/room'

const route = useRoute()
const loading = ref(false)
const roomTypes = ref([])
const defaultImage = 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800'

const filters = ref({
  check_in: route.query.check_in || '',
  check_out: route.query.check_out || '',
  room_type: null,
})

const priceRange = ref([0, 2000])

const disabledDate = (date) => {
  return date < new Date(new Date().setHours(0, 0, 0, 0))
}

const filteredRoomTypes = computed(() => {
  return roomTypes.value.filter((type) => {
    const priceMatch = type.price >= priceRange.value[0] && type.price <= priceRange.value[1]
    const typeMatch = !filters.value.room_type || type.id === filters.value.room_type
    return priceMatch && typeMatch
  })
})

const fetchRoomTypes = async () => {
  loading.value = true
  try {
    const res = await roomApi.getTypes()
    roomTypes.value = res.results || res
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  fetchRoomTypes()
}

const resetFilters = () => {
  filters.value = {
    check_in: '',
    check_out: '',
    room_type: null,
  }
  priceRange.value = [0, 2000]
}

onMounted(() => {
  fetchRoomTypes()
})
</script>

<style lang="scss" scoped>
.rooms-page {
  .page-header {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
    padding: 60px 20px;
    text-align: center;
    color: #fff;
    
    h1 {
      font-size: 42px;
      margin-bottom: 15px;
      background: linear-gradient(135deg, var(--primary-color), #a855f7);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    p {
      font-size: 18px;
      color: rgba(255, 255, 255, 0.8);
    }
  }
  
  .filter-section {
    background: #fff;
    padding: 25px 30px;
    border-radius: 12px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    margin-bottom: 30px;
    
    .filter-form {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
      
      :deep(.el-form-item) {
        margin-bottom: 0;
        margin-right: 20px;
      }
      
      :deep(.el-slider) {
        width: 200px;
      }
    }
  }
  
  .rooms-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
    gap: 25px;
  }
  
  .room-card {
    background: #fff;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    
    .room-image {
      position: relative;
      height: 200px;
      overflow: hidden;
      
      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
      }
      
      .room-badge {
        position: absolute;
        top: 15px;
        right: 15px;
        background: linear-gradient(135deg, var(--primary-color), #a855f7);
        color: #fff;
        padding: 6px 14px;
        border-radius: 20px;
        font-weight: bold;
        font-size: 14px;
      }
      
      .room-overlay {
        position: absolute;
        inset: 0;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.3s ease;
        
        .view-btn {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 12px 24px;
          background: #fff;
          color: var(--primary-color);
          border-radius: 25px;
          font-weight: 500;
          transform: translateY(20px);
          transition: all 0.3s ease;
        }
      }
      
      &:hover {
        img {
          transform: scale(1.1);
        }
        
        .room-overlay {
          opacity: 1;
          
          .view-btn {
            transform: translateY(0);
          }
        }
      }
    }
    
    .room-info {
      padding: 20px;
      
      .room-name {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 8px;
      }
      
      .room-desc {
        color: var(--text-secondary);
        font-size: 13px;
        line-height: 1.6;
        margin-bottom: 12px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
      
      .room-meta {
        display: flex;
        gap: 15px;
        margin-bottom: 12px;
        color: var(--text-regular);
        font-size: 13px;
        
        span {
          display: flex;
          align-items: center;
          gap: 4px;
        }
      }
      
      .room-amenities {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        margin-bottom: 15px;
      }
      
      .room-footer {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-top: 15px;
        border-top: 1px solid var(--border-light);
        
        .room-price {
          .price-label {
            font-size: 12px;
            color: var(--text-secondary);
          }
          
          .price-value {
            font-size: 24px;
            font-weight: bold;
            color: var(--primary-color);
            margin: 0 4px;
          }
          
          .price-unit {
            font-size: 12px;
            color: var(--text-secondary);
          }
        }
        
        .btn {
          padding: 8px 20px;
        }
      }
    }
  }
}
</style>
