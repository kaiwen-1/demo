<template>
  <div class="favorites-page">
    <div class="page-header">
      <h1>我的收藏</h1>
      <p>您收藏的房型列表</p>
    </div>
    
    <div class="favorites-container" v-loading="loading">
      <div class="favorites-grid" v-if="favorites.length > 0">
        <div 
          v-for="favorite in favorites" 
          :key="favorite.id" 
          class="favorite-card"
        >
          <div class="card-image">
            <img :src="favorite.room_type_image || defaultImage" :alt="favorite.room_type_name" />
            <div class="remove-btn" @click="handleRemove(favorite)">
              <el-icon><Delete /></el-icon>
            </div>
          </div>
          <div class="card-content">
            <h3>{{ favorite.room_type_name }}</h3>
            <div class="card-info">
              <span class="price">¥{{ favorite.room_type_price }}/晚</span>
              <span class="capacity">
                <el-icon><User /></el-icon>
                {{ favorite.room_type_capacity }}人
              </span>
            </div>
            <div class="card-actions">
              <router-link :to="`/rooms/${favorite.room_type}`">
                <el-button type="primary" size="small">查看详情</el-button>
              </router-link>
              <router-link :to="`/booking/${favorite.room_type}`">
                <el-button type="success" size="small">立即预订</el-button>
              </router-link>
            </div>
          </div>
        </div>
      </div>
      
      <el-empty v-else description="暂无收藏">
        <router-link to="/rooms">
          <el-button type="primary">去浏览房型</el-button>
        </router-link>
      </el-empty>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { favoriteApi } from '@/api/favorite'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const favorites = ref([])
const defaultImage = 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800'

const fetchFavorites = async () => {
  loading.value = true
  try {
    const res = await favoriteApi.getList()
    favorites.value = res.results || res
  } finally {
    loading.value = false
  }
}

const handleRemove = async (favorite) => {
  await ElMessageBox.confirm('确定要取消收藏吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  try {
    await favoriteApi.remove(favorite.id)
    ElMessage.success('已取消收藏')
    fetchFavorites()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

onMounted(() => {
  fetchFavorites()
})
</script>

<style lang="scss" scoped>
.favorites-page {
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
  
  .favorites-container {
    max-width: 1200px;
    margin: -20px auto 40px;
    padding: 0 20px;
  }
  
  .favorites-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
    
    .favorite-card {
      background: #fff;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      transition: all 0.3s ease;
      
      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
      }
      
      .card-image {
        position: relative;
        height: 200px;
        
        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
        
        .remove-btn {
          position: absolute;
          top: 10px;
          right: 10px;
          width: 36px;
          height: 36px;
          background: rgba(255, 255, 255, 0.9);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.3s ease;
          
          &:hover {
            background: #f56c6c;
            color: #fff;
          }
        }
      }
      
      .card-content {
        padding: 20px;
        
        h3 {
          font-size: 18px;
          margin-bottom: 10px;
        }
        
        .card-info {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 15px;
          
          .price {
            font-size: 20px;
            font-weight: bold;
            color: var(--primary-color);
          }
          
          .capacity {
            display: flex;
            align-items: center;
            gap: 5px;
            color: var(--text-secondary);
          }
        }
        
        .card-actions {
          display: flex;
          gap: 10px;
          
          a {
            flex: 1;
            
            .el-button {
              width: 100%;
            }
          }
        }
      }
    }
  }
}
</style>
