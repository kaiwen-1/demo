<template>
  <div class="front-layout">
    <header class="header glass-effect">
      <div class="header-content">
        <router-link to="/" class="logo">
          <el-icon :size="32"><House /></el-icon>
          <span class="logo-text">星辰酒店</span>
        </router-link>
        
        <nav class="nav-menu">
          <router-link to="/" class="nav-item" :class="{ active: $route.path === '/' }">
            <el-icon><HomeFilled /></el-icon>
            <span>首页</span>
          </router-link>
          <router-link to="/rooms" class="nav-item" :class="{ active: $route.path.startsWith('/rooms') }">
            <el-icon><OfficeBuilding /></el-icon>
            <span>房间</span>
          </router-link>
        </nav>
        
        <div class="header-right">
          <template v-if="userStore.isLoggedIn">
            <el-dropdown trigger="click" @command="handleCommand">
              <div class="user-info">
                <el-avatar :size="36" :src="userStore.user?.avatar">
                  {{ userStore.user?.username?.charAt(0).toUpperCase() }}
                </el-avatar>
                <span class="username">{{ userStore.user?.username }}</span>
                <el-icon><ArrowDown /></el-icon>
              </div>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="user">
                    <el-icon><User /></el-icon>
                    个人中心
                  </el-dropdown-item>
                  <el-dropdown-item v-if="!userStore.isAdmin" command="bookings">
                    <el-icon><List /></el-icon>
                    我的预订
                  </el-dropdown-item>
                  <el-dropdown-item v-if="userStore.isAdmin" command="admin" divided>
                    <el-icon><Setting /></el-icon>
                    后台管理
                  </el-dropdown-item>
                  <el-dropdown-item command="logout" :divided="!userStore.isAdmin">
                    <el-icon><SwitchButton /></el-icon>
                    退出登录
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
          <template v-else>
            <router-link to="/login" class="nav-item">
              <el-icon><User /></el-icon>
              <span>登录</span>
            </router-link>
            <router-link to="/register" class="btn btn-primary">
              注册
            </router-link>
          </template>
        </div>
      </div>
    </header>
    
    <main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
    
    <footer class="footer" v-if="!$route.path.startsWith('/login') && !$route.path.startsWith('/register')">
      <div class="footer-content">
        <div class="footer-section">
          <h4>关于我们</h4>
          <p>星辰酒店致力于为每一位客人提供舒适、温馨的住宿体验。我们拥有多种房型，满足不同客户的需求。</p>
        </div>
        <div class="footer-section">
          <h4>联系方式</h4>
          <p><el-icon><Phone /></el-icon> 电话：400-888-8888</p>
          <p><el-icon><Message /></el-icon> 邮箱：info@starhotel.com</p>
          <p><el-icon><Location /></el-icon> 地址：北京市朝阳区星光大道88号</p>
        </div>
        <div class="footer-section">
          <h4>快速链接</h4>
          <router-link to="/rooms">房间预订</router-link>
          <router-link to="/login">会员登录</router-link>
          <router-link to="/register">会员注册</router-link>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2024 星辰酒店 All Rights Reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { useUserStore } from '@/stores/user'
import { useRouter } from 'vue-router'
import { ElMessageBox } from 'element-plus'

const userStore = useUserStore()
const router = useRouter()

const handleCommand = async (command) => {
  switch (command) {
    case 'user':
      router.push('/user')
      break
    case 'bookings':
      router.push('/user/bookings')
      break
    case 'admin':
      router.push('/admin')
      break
    case 'logout':
      await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
      await userStore.logout()
      router.push('/')
      break
  }
}
</script>

<style lang="scss" scoped>
.front-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: 70px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  
  .header-content {
    max-width: 1200px;
    margin: 0 auto;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
  }
  
  .logo {
    display: flex;
    align-items: center;
    gap: 10px;
    color: var(--primary-color);
    font-size: 24px;
    font-weight: bold;
    transition: all 0.3s ease;
    
    &:hover {
      transform: scale(1.05);
    }
    
    .logo-text {
      background: linear-gradient(135deg, var(--primary-color), #a855f7);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
  }
  
  .nav-menu {
    display: flex;
    gap: 10px;
    
    .nav-item {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 10px 20px;
      border-radius: 8px;
      color: var(--text-regular);
      font-weight: 500;
      transition: all 0.3s ease;
      
      &:hover {
        color: var(--primary-color);
        background: rgba(64, 158, 255, 0.1);
      }
      
      &.active {
        color: var(--primary-color);
        background: rgba(64, 158, 255, 0.15);
      }
    }
  }
  
  .header-right {
    display: flex;
    align-items: center;
    gap: 15px;
    
    .nav-item {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 10px 16px;
      border-radius: 8px;
      color: var(--text-regular);
      font-weight: 500;
      transition: all 0.3s ease;
      
      &:hover {
        color: var(--primary-color);
        background: rgba(64, 158, 255, 0.1);
      }
    }
    
    .user-info {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 6px 12px;
      border-radius: 25px;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        background: rgba(64, 158, 255, 0.1);
      }
      
      .username {
        font-weight: 500;
        color: var(--text-primary);
      }
    }
  }
}

.main-content {
  flex: 1;
  margin-top: 70px;
  min-height: calc(100vh - 70px - 200px);
}

.footer {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  color: #fff;
  padding: 50px 20px 20px;
  
  .footer-content {
    max-width: 1200px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 40px;
    
    @media (max-width: 768px) {
      grid-template-columns: 1fr;
      gap: 30px;
    }
  }
  
  .footer-section {
    h4 {
      font-size: 18px;
      margin-bottom: 20px;
      color: #fff;
      position: relative;
      
      &::after {
        content: '';
        position: absolute;
        bottom: -8px;
        left: 0;
        width: 40px;
        height: 2px;
        background: var(--primary-color);
      }
    }
    
    p {
      color: rgba(255, 255, 255, 0.7);
      line-height: 1.8;
      margin-bottom: 10px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    
    a {
      display: block;
      color: rgba(255, 255, 255, 0.7);
      margin-bottom: 10px;
      transition: all 0.3s ease;
      
      &:hover {
        color: var(--primary-color);
        transform: translateX(5px);
      }
    }
  }
  
  .footer-bottom {
    max-width: 1200px;
    margin: 40px auto 0;
    padding-top: 20px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    text-align: center;
    color: rgba(255, 255, 255, 0.5);
  }
}
</style>
