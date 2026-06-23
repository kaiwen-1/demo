<template>
  <div class="home-page">
    <section class="hero-section">
      <div class="hero-particles" ref="particlesRef">
        <div v-for="i in 50" :key="i" class="particle" :style="getParticleStyle(i)"></div>
      </div>
      
      <div class="hero-bg">
        <div class="bg-shape shape-1"></div>
        <div class="bg-shape shape-2"></div>
        <div class="bg-shape shape-3"></div>
      </div>
      
      <div class="hero-content">
        <h1 class="hero-title">
          <span class="title-line animate__animated animate__fadeInUp">探索</span>
          <span class="title-line title-gradient animate__animated animate__fadeInUp animate__delay-1s">星辰酒店</span>
          <span class="title-line animate__animated animate__fadeInUp animate__delay-2s">的奢华之旅</span>
        </h1>
        
        <p class="hero-desc animate__animated animate__fadeInUp animate__delay-3s">
          在这里，每一次入住都是一场难忘的旅程<br />
          我们用心服务，只为给您最完美的体验
        </p>
        
        <div class="hero-stats animate__animated animate__fadeInUp animate__delay-4s">
          <div class="stat-item">
            <span class="stat-number" ref="statRooms">0</span>
            <span class="stat-label">精选客房</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <span class="stat-number" ref="statGuests">0</span>
            <span class="stat-label">满意客户</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <span class="stat-number">4.9</span>
            <span class="stat-label">客户评分</span>
          </div>
        </div>
        
        <div class="hero-actions animate__animated animate__fadeInUp animate__delay-5s">
          <router-link to="/rooms" class="action-btn primary">
            <el-icon class="btn-icon left-icon"><ArrowLeft /></el-icon>
            <span>立即探索</span>
            <el-icon class="btn-icon right-icon"><ArrowRight /></el-icon>
          </router-link>
        </div>
        
        <div class="scroll-indicator animate__animated animate__fadeIn animate__delay-5s" @click="scrollToRooms">
          <div class="mouse">
            <div class="wheel"></div>
          </div>
          <span>向下滚动</span>
        </div>
      </div>
    </section>
    

    
    <section class="rooms-section" ref="roomsSection">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">精选推荐</span>
          <h2 class="section-title">探索我们的房型</h2>
          <p class="section-desc">每一间客房都经过精心设计，为您带来极致的舒适体验</p>
        </div>
        
        <div class="rooms-filter">
          <button 
            v-for="filter in roomFilters" 
            :key="filter.value"
            :class="['filter-btn', { active: activeFilter === filter.value }]"
            @click="activeFilter = filter.value"
          >
            {{ filter.label }}
          </button>
        </div>
        
        <div class="rooms-grid" v-loading="loading">
          <div 
            v-for="(type, index) in filteredRoomTypes" 
            :key="type.id"
            class="room-card"
            :style="{ animationDelay: `${index * 0.1}s` }"
            @mouseenter="hoveredRoom = type.id"
            @mouseleave="hoveredRoom = null"
          >
            <div class="room-image-wrapper">
              <img :src="type.image || defaultImage" :alt="type.name" class="room-image" />
              <div class="room-overlay">
                <div class="overlay-content">
                  <router-link :to="`/rooms/${type.id}`" class="overlay-btn">
                    <el-icon><View /></el-icon>
                    查看详情
                  </router-link>
                </div>
              </div>
              <div class="room-badge">
                <span class="badge-price">¥{{ type.price }}</span>
                <span class="badge-unit">/晚</span>
              </div>
              <div class="room-favorite" @click.stop>
                <el-icon :class="{ active: favorites.includes(type.id) }">
                  <Star />
                </el-icon>
              </div>
            </div>
            
            <div class="room-content">
              <div class="room-header">
                <h3 class="room-name">{{ type.name }}</h3>
                <div class="room-rating">
                  <el-icon color="#fbbf24"><Star /></el-icon>
                  <span>4.9</span>
                  <span class="rating-count">({{ Math.floor(Math.random() * 100) + 50 }})</span>
                </div>
              </div>
              
              <p class="room-desc">{{ type.description }}</p>
              
              <div class="room-features">
                <div class="feature-item">
                  <el-icon><User /></el-icon>
                  <span>{{ type.capacity }}人</span>
                </div>
                <div class="feature-item">
                  <el-icon><Grid /></el-icon>
                  <span>{{ type.size }}㎡</span>
                </div>
                <div class="feature-item">
                  <el-icon><Bed /></el-icon>
                  <span>大床</span>
                </div>
              </div>
              
              <div class="room-amenities">
                <el-tag 
                  v-for="amenity in type.amenities?.slice(0, 4)" 
                  :key="amenity" 
                  size="small"
                  effect="plain"
                >
                  {{ amenity }}
                </el-tag>
              </div>
              
              <div class="room-footer">
                <div class="price-info">
                  <span class="price-label">起价</span>
                  <span class="price-value">¥{{ type.price }}</span>
                </div>
                <router-link :to="`/booking/${type.id}`" class="book-btn">
                  立即预订
                  <el-icon><ArrowRight /></el-icon>
                </router-link>
              </div>
            </div>
          </div>
        </div>
        
        <div class="view-all">
          <router-link to="/rooms" class="view-all-btn">
            查看全部房型
            <el-icon><ArrowRight /></el-icon>
          </router-link>
        </div>
      </div>
    </section>
    
    <section class="features-section">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">我们的优势</span>
          <h2 class="section-title">为什么选择星辰酒店</h2>
          <p class="section-desc">我们致力于为每一位客人提供超越期待的服务体验</p>
        </div>
        
        <div class="features-grid">
          <div class="feature-card" v-for="(feature, index) in features" :key="index">
            <div class="feature-icon" :style="{ background: feature.gradient }">
              <el-icon :size="32">{{ feature.icon }}</el-icon>
            </div>
            <h3 class="feature-title">{{ feature.title }}</h3>
            <p class="feature-desc">{{ feature.desc }}</p>
            <div class="feature-stats">
              <span class="stats-value">{{ feature.stats }}</span>
              <span class="stats-label">{{ feature.statsLabel }}</span>
            </div>
          </div>
        </div>
      </div>
    </section>
    
    <section class="experience-section">
      <div class="experience-bg">
        <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=1920" alt="experience" />
        <div class="experience-overlay"></div>
      </div>
      
      <div class="experience-content">
        <div class="experience-left">
          <span class="section-tag">特色体验</span>
          <h2 class="experience-title">开启您的<br />奢华之旅</h2>
          <p class="experience-desc">
            从入住的那一刻起，您将感受到无微不至的关怀。
            我们的每一项服务都经过精心设计，只为让您拥有难忘的住宿体验。
          </p>
          
          <div class="experience-list">
            <div class="list-item" v-for="(item, index) in experienceList" :key="index">
              <div class="item-icon">
                <el-icon><Check /></el-icon>
              </div>
              <div class="item-content">
                <h4>{{ item.title }}</h4>
                <p>{{ item.desc }}</p>
              </div>
            </div>
          </div>
          
          <router-link to="/rooms" class="experience-btn">
            探索更多
            <el-icon><ArrowRight /></el-icon>
          </router-link>
        </div>
        
        <div class="experience-right">
          <div class="image-stack">
            <div class="stack-image stack-1">
              <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600" alt="room" />
            </div>
            <div class="stack-image stack-2">
              <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=600" alt="room" />
            </div>
            <div class="stack-card">
              <div class="card-icon">
                <el-icon><Trophy /></el-icon>
              </div>
              <div class="card-content">
                <span class="card-value">4.9</span>
                <span class="card-label">客户评分</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    
    <section class="reviews-section">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">客户评价</span>
          <h2 class="section-title">听听他们的故事</h2>
          <p class="section-desc">来自真实客人的入住体验分享</p>
        </div>
        
        <div class="reviews-wrapper" v-loading="reviewsLoading">
          <div class="reviews-track" :style="{ transform: `translateX(-${reviewIndex * 100}%)` }">
            <div 
              v-for="(review, index) in reviews" 
              :key="review.id" 
              class="review-slide"
            >
              <div class="review-card">
                <div class="review-quote">
                  <el-icon :size="48"><ChatQuoteRound /></el-icon>
                </div>
                <div class="review-rating">
                  <el-rate v-model="review.rating" disabled />
                </div>
                <p class="review-content">"{{ review.content }}"</p>
                <div class="review-author">
                  <el-avatar :size="56" :src="review.user_avatar">
                    {{ review.username?.charAt(0).toUpperCase() }}
                  </el-avatar>
                  <div class="author-info">
                    <span class="author-name">{{ review.username }}</span>
                    <span class="author-title">{{ review.room_type?.name }}入住客人</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="reviews-nav">
            <button class="nav-btn prev" @click="prevReview">
              <el-icon><ArrowLeft /></el-icon>
            </button>
            <div class="nav-dots">
              <span 
                v-for="(_, index) in reviews" 
                :key="index"
                :class="['dot', { active: reviewIndex === index }]"
                @click="reviewIndex = index"
              ></span>
            </div>
            <button class="nav-btn next" @click="nextReview">
              <el-icon><ArrowRight /></el-icon>
            </button>
          </div>
        </div>
      </div>
    </section>
    
    <section class="cta-section">
      <div class="cta-container">
        <div class="cta-content">
          <h2 class="cta-title">准备好开启您的旅程了吗？</h2>
          <p class="cta-desc">立即预订，享受专属优惠和贴心服务</p>
          <div class="cta-actions">
            <router-link to="/rooms" class="cta-btn primary">
              立即预订
              <el-icon><ArrowRight /></el-icon>
            </router-link>
            <router-link to="/register" class="cta-btn secondary">
              注册会员
            </router-link>
          </div>
        </div>
        
        <div class="cta-decoration">
          <div class="deco-circle circle-1"></div>
          <div class="deco-circle circle-2"></div>
          <div class="deco-circle circle-3"></div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { roomApi } from '@/api/room'
import { reviewApi } from '@/api/review'
import dayjs from 'dayjs'

const router = useRouter()
const loading = ref(false)
const reviewsLoading = ref(false)
const roomTypes = ref([])
const reviews = ref([])
const favorites = ref([])
const hoveredRoom = ref(null)
const reviewIndex = ref(0)
const activeFilter = ref('all')
const defaultImage = 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800'

const roomFilters = [
  { label: '全部', value: 'all' },
  { label: '标准间', value: 'standard' },
  { label: '豪华间', value: 'deluxe' },
  { label: '套房', value: 'suite' },
]

const features = [
  {
    icon: 'Medal',
    title: '品质保障',
    desc: '严格筛选每一间客房，确保达到五星级标准',
    stats: '100%',
    statsLabel: '品质达标',
    gradient: 'linear-gradient(135deg, #667eea, #764ba2)',
  },
  {
    icon: 'Clock',
    title: '24小时服务',
    desc: '全天候贴心服务，随时解决您的需求',
    stats: '24/7',
    statsLabel: '全天候',
    gradient: 'linear-gradient(135deg, #f093fb, #f5576c)',
  },
  {
    icon: 'Wallet',
    title: '价格透明',
    desc: '无隐藏费用，所见即所得，放心预订',
    stats: '0',
    statsLabel: '隐藏费用',
    gradient: 'linear-gradient(135deg, #4facfe, #00f2fe)',
  },
  {
    icon: 'ShieldCheck',
    title: '安全保障',
    desc: '完善的安保系统，保障您的入住安全',
    stats: '99.9%',
    statsLabel: '安全率',
    gradient: 'linear-gradient(135deg, #43e97b, #38f9d7)',
  },
]

const experienceList = [
  { title: '专属管家服务', desc: '一对一贴心服务，满足您的所有需求' },
  { title: '精致餐饮体验', desc: '米其林星级主厨，为您呈现美食盛宴' },
  { title: '休闲娱乐设施', desc: '泳池、健身房、SPA，尽享惬意时光' },
]

const filteredRoomTypes = computed(() => {
  if (activeFilter.value === 'all') return roomTypes.value
  return roomTypes.value.filter(type => {
    if (activeFilter.value === 'standard') return type.name.includes('标准')
    if (activeFilter.value === 'deluxe') return type.name.includes('豪华')
    if (activeFilter.value === 'suite') return type.name.includes('套房') || type.name.includes('商务')
    return true
  })
})

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD')

const getParticleStyle = (index) => {
  const size = Math.random() * 4 + 2
  return {
    width: `${size}px`,
    height: `${size}px`,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    animationDelay: `${Math.random() * 5}s`,
    animationDuration: `${Math.random() * 10 + 10}s`,
  }
}

const scrollToRooms = () => {
  document.querySelector('.rooms-section')?.scrollIntoView({ behavior: 'smooth' })
}

const prevReview = () => {
  reviewIndex.value = reviewIndex.value > 0 ? reviewIndex.value - 1 : reviews.value.length - 1
}

const nextReview = () => {
  reviewIndex.value = reviewIndex.value < reviews.value.length - 1 ? reviewIndex.value + 1 : 0
}

const animateNumbers = () => {
  const animateValue = (element, start, end, duration) => {
    if (!element) return
    let startTimestamp = null
    const step = (timestamp) => {
      if (!startTimestamp) startTimestamp = timestamp
      const progress = Math.min((timestamp - startTimestamp) / duration, 1)
      element.textContent = Math.floor(progress * (end - start) + start)
      if (progress < 1) {
        window.requestAnimationFrame(step)
      }
    }
    window.requestAnimationFrame(step)
  }
  
  setTimeout(() => {
    animateValue(document.querySelector('.stat-item:first-child .stat-number'), 0, 18, 2000)
    animateValue(document.querySelector('.stat-item:nth-child(3) .stat-number'), 0, 9999, 2000)
  }, 4500)
}

const fetchRoomTypes = async () => {
  loading.value = true
  try {
    const res = await roomApi.getTypes()
    roomTypes.value = res.results || res
  } finally {
    loading.value = false
  }
}

const fetchReviews = async () => {
  reviewsLoading.value = true
  try {
    const res = await reviewApi.getList({ page_size: 5 })
    reviews.value = res.results || res
  } finally {
    reviewsLoading.value = false
  }
}

let autoPlayInterval = null

onMounted(() => {
  fetchRoomTypes()
  fetchReviews()
  animateNumbers()
  
  autoPlayInterval = setInterval(() => {
    nextReview()
  }, 5000)
})

onUnmounted(() => {
  if (autoPlayInterval) {
    clearInterval(autoPlayInterval)
  }
})
</script>

<style lang="scss" scoped>
.home-page {
  overflow-x: hidden;
}

.hero-section {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f0f23 0%, #1a1a3e 50%, #0f0f23 100%);
  overflow: hidden;
  
  .hero-particles {
    position: absolute;
    inset: 0;
    pointer-events: none;
    
    .particle {
      position: absolute;
      background: rgba(255, 255, 255, 0.3);
      border-radius: 50%;
      animation: float-particle 15s infinite ease-in-out;
    }
  }
  
  .hero-bg {
    position: absolute;
    inset: 0;
    
    .bg-shape {
      position: absolute;
      border-radius: 50%;
      filter: blur(80px);
      opacity: 0.5;
      
      &.shape-1 {
        width: 600px;
        height: 600px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        top: -200px;
        right: -200px;
        animation: float 20s infinite ease-in-out;
      }
      
      &.shape-2 {
        width: 400px;
        height: 400px;
        background: linear-gradient(135deg, #f093fb, #f5576c);
        bottom: -100px;
        left: -100px;
        animation: float 15s infinite ease-in-out reverse;
      }
      
      &.shape-3 {
        width: 300px;
        height: 300px;
        background: linear-gradient(135deg, #4facfe, #00f2fe);
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        animation: pulse 10s infinite ease-in-out;
      }
    }
  }
  
  .hero-content {
    position: relative;
    z-index: 10;
    text-align: center;
    padding: 0 20px;
    max-width: 900px;
    
    .hero-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 10px 24px;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 50px;
      color: #fbbf24;
      font-size: 14px;
      margin-bottom: 30px;
      backdrop-filter: blur(10px);
    }
    
    .hero-title {
          margin-bottom: 16px;
          
          .title-line {
            display: block;
            font-size: 56px;
            font-weight: 300;
            color: #fff;
            line-height: 1.3;
            
            @media (max-width: 768px) {
              font-size: 36px;
            }
            
            &.title-gradient {
              font-size: 72px;
              font-weight: 700;
              background: linear-gradient(135deg, #667eea, #f093fb, #f5576c);
              -webkit-background-clip: text;
              -webkit-text-fill-color: transparent;
              background-size: 200% 200%;
              animation: gradient-shift 5s ease infinite;
              
              @media (max-width: 768px) {
                font-size: 48px;
              }
            }
          }
        }
        
        .hero-desc {
          font-size: 18px;
          color: rgba(255, 255, 255, 0.7);
          line-height: 1.8;
          margin-bottom: 30px;
        }
        
        .hero-stats {
          display: flex;
          justify-content: center;
          align-items: center;
          gap: 40px;
          margin-bottom: 40px;
      
      @media (max-width: 768px) {
        flex-wrap: wrap;
        gap: 20px;
      }
      
      .stat-item {
        text-align: center;
        
        .stat-number {
          display: block;
          font-size: 42px;
          font-weight: 700;
          color: #fff;
          line-height: 1;
        }
        
        .stat-label {
          font-size: 14px;
          color: rgba(255, 255, 255, 0.6);
          margin-top: 8px;
        }
      }
      
      .stat-divider {
        width: 1px;
        height: 50px;
        background: rgba(255, 255, 255, 0.2);
        
        @media (max-width: 768px) {
          display: none;
        }
      }
    }
    
    .hero-actions {
      display: flex;
      justify-content: center;
      gap: 20px;
      flex-wrap: wrap;
      
      .action-btn {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 16px 36px;
        border-radius: 50px;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        border: none;
        
        &.primary {
          background: linear-gradient(135deg, #667eea, #764ba2);
          color: #fff;
          box-shadow: 0 10px 40px rgba(102, 126, 234, 0.4);
          
          &:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 50px rgba(102, 126, 234, 0.5);
          }
          
          .btn-icon {
            transition: transform 0.3s ease;
          }
          
          &:hover .left-icon {
            transform: translateX(-5px);
          }
          
          &:hover .right-icon {
            transform: translateX(5px);
          }
        }
        
        &.secondary {
          background: rgba(255, 255, 255, 0.1);
          color: #fff;
          border: 1px solid rgba(255, 255, 255, 0.3);
          backdrop-filter: blur(10px);
          
          &:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-3px);
          }
        }
      }
    }
  }
  
  .scroll-indicator {
    margin-top: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    color: rgba(255, 255, 255, 0.6);
    font-size: 12px;
    
    .mouse {
      width: 24px;
      height: 40px;
      border: 2px solid rgba(255, 255, 255, 0.3);
      border-radius: 12px;
      position: relative;
      
      .wheel {
        position: absolute;
        top: 8px;
        left: 50%;
        transform: translateX(-50%);
        width: 4px;
        height: 8px;
        background: #fff;
        border-radius: 2px;
        animation: scroll-wheel 2s infinite;
      }
    }
    
    &:hover {
      color: #fff;
    }
  }
}



.rooms-section {
  padding: 100px 20px;
  background: #fff;
  
  .section-container {
    max-width: 1200px;
    margin: 0 auto;
  }
  
  .section-header {
    text-align: center;
    margin-bottom: 50px;
    
    .section-tag {
      display: inline-block;
      padding: 8px 20px;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
      border-radius: 50px;
      color: #667eea;
      font-size: 14px;
      font-weight: 500;
      margin-bottom: 20px;
    }
    
    .section-title {
      font-size: 42px;
      color: #1a1a3e;
      margin-bottom: 15px;
      
      @media (max-width: 768px) {
        font-size: 32px;
      }
    }
    
    .section-desc {
      font-size: 16px;
      color: #666;
    }
  }
  
  .rooms-filter {
    display: flex;
    justify-content: center;
    gap: 12px;
    margin-bottom: 50px;
    flex-wrap: wrap;
    
    .filter-btn {
      padding: 12px 28px;
      background: #f5f5f5;
      border: none;
      border-radius: 50px;
      color: #666;
      font-size: 15px;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        background: #e8e8e8;
      }
      
      &.active {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: #fff;
      }
    }
  }
  
  .rooms-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
    gap: 30px;
    align-items: stretch;
    
    @media (max-width: 480px) {
      grid-template-columns: 1fr;
    }
    
    .room-card {
      background: #fff;
      border-radius: 24px;
      overflow: hidden;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
      transition: all 0.4s ease;
      animation: fadeInUp 0.6s ease forwards;
      opacity: 0;
      display: flex;
      flex-direction: column;
      height: 100%;
      
      &:hover {
        transform: translateY(-10px);
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
      }
      
      .room-image-wrapper {
        position: relative;
        height: 260px;
        overflow: hidden;
        
        .room-image {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.6s ease;
        }
        
        .room-overlay {
          position: absolute;
          inset: 0;
          background: linear-gradient(180deg, transparent 0%, rgba(0, 0, 0, 0.6) 100%);
          opacity: 0;
          transition: opacity 0.3s ease;
          display: flex;
          align-items: center;
          justify-content: center;
          
          .overlay-content {
            transform: translateY(20px);
            transition: transform 0.3s ease;
          }
          
          .overlay-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            background: #fff;
            border-radius: 50px;
            color: #1a1a3e;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            
            &:hover {
              background: #667eea;
              color: #fff;
            }
          }
        }
        
        .room-badge {
          position: absolute;
          top: 20px;
          right: 20px;
          background: rgba(255, 255, 255, 0.95);
          backdrop-filter: blur(10px);
          padding: 10px 18px;
          border-radius: 50px;
          box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
          
          .badge-price {
            font-size: 20px;
            font-weight: 700;
            color: #667eea;
          }
          
          .badge-unit {
            font-size: 12px;
            color: #666;
          }
        }
        
        .room-favorite {
          position: absolute;
          top: 20px;
          left: 20px;
          width: 44px;
          height: 44px;
          background: rgba(255, 255, 255, 0.95);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.3s ease;
          
          &:hover {
            transform: scale(1.1);
          }
          
          .el-icon {
            font-size: 20px;
            color: #ccc;
            transition: all 0.3s ease;
            
            &.active {
              color: #f5576c;
            }
          }
        }
        
        &:hover {
          .room-image {
            transform: scale(1.1);
          }
          
          .room-overlay {
            opacity: 1;
            
            .overlay-content {
              transform: translateY(0);
            }
          }
        }
      }
      
      .room-content {
        padding: 28px;
        flex: 1;
        display: flex;
        flex-direction: column;
        
        .room-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 15px;
          
          .room-name {
            font-size: 22px;
            font-weight: 600;
            color: #1a1a3e;
          }
          
          .room-rating {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 14px;
            color: #666;
            
            .rating-count {
              color: #999;
            }
          }
        }
        
        .room-desc {
          color: #666;
          font-size: 14px;
          line-height: 1.7;
          margin-bottom: 20px;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          overflow: hidden;
          min-height: 48px;
        }
        
        .room-features {
          display: flex;
          gap: 20px;
          margin-bottom: 20px;
          padding-bottom: 20px;
          border-bottom: 1px solid #eee;
          
          .feature-item {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #666;
            font-size: 14px;
            
            .el-icon {
              color: #667eea;
            }
          }
        }
        
        .room-amenities {
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          margin-bottom: 24px;
          min-height: 32px;
          
          .el-tag {
            background: rgba(102, 126, 234, 0.1);
            border-color: transparent;
            color: #667eea;
          }
        }
        
        .room-footer {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-top: auto;
          
          .price-info {
            .price-label {
              font-size: 12px;
              color: #999;
            }
            
            .price-value {
              display: block;
              font-size: 28px;
              font-weight: 700;
              color: #1a1a3e;
            }
          }
          
          .book-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50px;
            color: #fff;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            
            &:hover {
              transform: translateX(5px);
              box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            }
          }
        }
      }
    }
  }
  
  .view-all {
    text-align: center;
    margin-top: 50px;
    
    .view-all-btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 16px 40px;
      background: transparent;
      border: 2px solid #667eea;
      border-radius: 50px;
      color: #667eea;
      font-size: 16px;
      font-weight: 500;
      text-decoration: none;
      transition: all 0.3s ease;
      
      &:hover {
        background: #667eea;
        color: #fff;
      }
    }
  }
}

.features-section {
  padding: 100px 20px;
  background: linear-gradient(180deg, #f8f9fa 0%, #fff 100%);
  
  .section-container {
    max-width: 1200px;
    margin: 0 auto;
  }
  
  .features-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 30px;
    
    @media (max-width: 992px) {
      grid-template-columns: repeat(2, 1fr);
    }
    
    @media (max-width: 576px) {
      grid-template-columns: 1fr;
    }
    
    .feature-card {
      background: #fff;
      border-radius: 24px;
      padding: 40px 30px;
      text-align: center;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
      transition: all 0.4s ease;
      
      &:hover {
        transform: translateY(-10px);
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
        
        .feature-icon {
          transform: scale(1.1) rotate(5deg);
        }
      }
      
      .feature-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto 25px;
        border-radius: 24px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        transition: transform 0.4s ease;
      }
      
      .feature-title {
        font-size: 20px;
        color: #1a1a3e;
        margin-bottom: 12px;
      }
      
      .feature-desc {
        color: #666;
        font-size: 14px;
        line-height: 1.7;
        margin-bottom: 20px;
      }
      
      .feature-stats {
        padding-top: 20px;
        border-top: 1px solid #eee;
        
        .stats-value {
          display: block;
          font-size: 32px;
          font-weight: 700;
          color: #1a1a3e;
        }
        
        .stats-label {
          font-size: 13px;
          color: #999;
        }
      }
    }
  }
}

.experience-section {
  position: relative;
  padding: 120px 20px;
  overflow: hidden;
  
  .experience-bg {
    position: absolute;
    inset: 0;
    
    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    
    .experience-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, rgba(15, 15, 35, 0.95), rgba(26, 26, 62, 0.9));
    }
  }
  
  .experience-content {
    position: relative;
    z-index: 10;
    max-width: 1200px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 80px;
    align-items: center;
    
    @media (max-width: 992px) {
      grid-template-columns: 1fr;
      gap: 50px;
    }
    
    .experience-left {
      .section-tag {
        display: inline-block;
        padding: 8px 20px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50px;
        color: #fbbf24;
        font-size: 14px;
        margin-bottom: 25px;
      }
      
      .experience-title {
        font-size: 48px;
        color: #fff;
        line-height: 1.2;
        margin-bottom: 25px;
        
        @media (max-width: 768px) {
          font-size: 36px;
        }
      }
      
      .experience-desc {
        font-size: 16px;
        color: rgba(255, 255, 255, 0.7);
        line-height: 1.8;
        margin-bottom: 40px;
      }
      
      .experience-list {
        margin-bottom: 40px;
        
        .list-item {
          display: flex;
          gap: 20px;
          margin-bottom: 25px;
          
          .item-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            flex-shrink: 0;
          }
          
          .item-content {
            h4 {
              color: #fff;
              font-size: 18px;
              margin-bottom: 5px;
            }
            
            p {
              color: rgba(255, 255, 255, 0.6);
              font-size: 14px;
            }
          }
        }
      }
      
      .experience-btn {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 16px 36px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        border-radius: 50px;
        color: #fff;
        font-size: 16px;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.3s ease;
        
        &:hover {
          transform: translateY(-3px);
          box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
        }
      }
    }
    
    .experience-right {
      .image-stack {
        position: relative;
        height: 500px;
        
        .stack-image {
          position: absolute;
          border-radius: 24px;
          overflow: hidden;
          box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
          
          img {
            width: 100%;
            height: 100%;
            object-fit: cover;
          }
          
          &.stack-1 {
            width: 300px;
            height: 400px;
            top: 0;
            right: 0;
            animation: float 6s ease-in-out infinite;
          }
          
          &.stack-2 {
            width: 250px;
            height: 300px;
            bottom: 0;
            left: 0;
            animation: float 6s ease-in-out infinite reverse;
            animation-delay: 1s;
          }
        }
        
        .stack-card {
          position: absolute;
          bottom: 50px;
          right: 50px;
          background: rgba(255, 255, 255, 0.95);
          backdrop-filter: blur(20px);
          border-radius: 20px;
          padding: 25px;
          display: flex;
          align-items: center;
          gap: 15px;
          box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
          
          .card-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 24px;
          }
          
          .card-content {
            .card-value {
              display: block;
              font-size: 28px;
              font-weight: 700;
              color: #1a1a3e;
            }
            
            .card-label {
              font-size: 13px;
              color: #666;
            }
          }
        }
      }
    }
  }
}

.reviews-section {
  padding: 100px 20px;
  background: #fff;
  
  .section-container {
    max-width: 800px;
    margin: 0 auto;
  }
  
  .reviews-wrapper {
    position: relative;
    overflow: hidden;
    
    .reviews-track {
      display: flex;
      transition: transform 0.5s ease;
    }
    
    .review-slide {
      flex: 0 0 100%;
      padding: 0 20px;
    }
    
    .review-card {
      background: linear-gradient(135deg, #f8f9fa, #fff);
      border-radius: 24px;
      padding: 50px;
      text-align: center;
      
      .review-quote {
        color: #667eea;
        opacity: 0.2;
        margin-bottom: 20px;
      }
      
      .review-rating {
        margin-bottom: 25px;
      }
      
      .review-content {
        font-size: 20px;
        color: #1a1a3e;
        line-height: 1.8;
        margin-bottom: 35px;
        font-style: italic;
      }
      
      .review-author {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 15px;
        
        .author-info {
          text-align: left;
          
          .author-name {
            display: block;
            font-size: 18px;
            font-weight: 600;
            color: #1a1a3e;
          }
          
          .author-title {
            font-size: 14px;
            color: #666;
          }
        }
      }
    }
    
    .reviews-nav {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 20px;
      margin-top: 40px;
      
      .nav-btn {
        width: 48px;
        height: 48px;
        background: #f5f5f5;
        border: none;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s ease;
        
        &:hover {
          background: #667eea;
          color: #fff;
        }
      }
      
      .nav-dots {
        display: flex;
        gap: 10px;
        
        .dot {
          width: 10px;
          height: 10px;
          background: #ddd;
          border-radius: 50%;
          cursor: pointer;
          transition: all 0.3s ease;
          
          &.active {
            width: 30px;
            border-radius: 5px;
            background: #667eea;
          }
        }
      }
    }
  }
}

.cta-section {
  padding: 100px 20px;
  background: linear-gradient(135deg, #0f0f23, #1a1a3e);
  position: relative;
  overflow: hidden;
  
  .cta-container {
    max-width: 800px;
    margin: 0 auto;
    text-align: center;
    position: relative;
    z-index: 10;
    
    .cta-content {
      .cta-title {
        font-size: 42px;
        color: #fff;
        margin-bottom: 20px;
        
        @media (max-width: 768px) {
          font-size: 32px;
        }
      }
      
      .cta-desc {
        font-size: 18px;
        color: rgba(255, 255, 255, 0.7);
        margin-bottom: 40px;
      }
      
      .cta-actions {
        display: flex;
        justify-content: center;
        gap: 20px;
        flex-wrap: wrap;
        
        .cta-btn {
          display: inline-flex;
          align-items: center;
          gap: 10px;
          padding: 18px 40px;
          border-radius: 50px;
          font-size: 16px;
          font-weight: 500;
          text-decoration: none;
          transition: all 0.3s ease;
          
          &.primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.4);
            
            &:hover {
              transform: translateY(-3px);
              box-shadow: 0 15px 50px rgba(102, 126, 234, 0.5);
            }
          }
          
          &.secondary {
            background: transparent;
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: #fff;
            
            &:hover {
              background: rgba(255, 255, 255, 0.1);
              border-color: rgba(255, 255, 255, 0.5);
            }
          }
        }
      }
    }
    
    .cta-decoration {
      .deco-circle {
        position: absolute;
        border-radius: 50%;
        border: 1px solid rgba(255, 255, 255, 0.1);
        
        &.circle-1 {
          width: 300px;
          height: 300px;
          top: -150px;
          left: -150px;
        }
        
        &.circle-2 {
          width: 500px;
          height: 500px;
          bottom: -250px;
          right: -250px;
        }
        
        &.circle-3 {
          width: 200px;
          height: 200px;
          top: 50%;
          right: -100px;
          transform: translateY(-50%);
        }
      }
    }
  }
}

@keyframes float-particle {
  0%, 100% {
    transform: translateY(0) translateX(0);
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  90% {
    opacity: 1;
  }
  100% {
    transform: translateY(-100vh) translateX(50px);
    opacity: 0;
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
}

@keyframes pulse {
  0%, 100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.3;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.2);
    opacity: 0.5;
  }
}

@keyframes gradient-shift {
  0%, 100% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
}

@keyframes scroll-wheel {
  0% {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
  100% {
    opacity: 0;
    transform: translateX(-50%) translateY(12px);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
