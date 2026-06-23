<template>
  <div class="admin-layout">
    <aside class="sidebar" :class="{ collapsed: isCollapsed }">
      <div class="sidebar-header">
        <el-icon :size="28"><House /></el-icon>
        <span v-show="!isCollapsed" class="logo-text">酒店管理</span>
      </div>
      
      <el-menu
        :default-active="$route.path"
        :collapse="isCollapsed"
        router
        class="sidebar-menu"
      >
        <el-menu-item index="/admin">
          <el-icon><DataAnalysis /></el-icon>
          <template #title>数据统计</template>
        </el-menu-item>
        
        <el-sub-menu index="rooms">
          <template #title>
            <el-icon><OfficeBuilding /></el-icon>
            <span>房间管理</span>
          </template>
          <el-menu-item index="/admin/rooms">房间列表</el-menu-item>
          <el-menu-item index="/admin/room-types">房型管理</el-menu-item>
        </el-sub-menu>
        
        <el-menu-item index="/admin/bookings">
          <el-icon><Calendar /></el-icon>
          <template #title>预订管理</template>
        </el-menu-item>
        
        <el-menu-item index="/admin/users">
          <el-icon><User /></el-icon>
          <template #title>用户管理</template>
        </el-menu-item>
        
        <el-menu-item index="/admin/reviews">
          <el-icon><ChatDotRound /></el-icon>
          <template #title>评论管理</template>
        </el-menu-item>
        
        <el-menu-item index="/admin/operations">
          <el-icon><Present /></el-icon>
          <template #title>运营管理</template>
        </el-menu-item>
        

        
        <el-menu-item index="/admin/system">
          <el-icon><Setting /></el-icon>
          <template #title>系统设置</template>
        </el-menu-item>
      </el-menu>
    </aside>
    
    <div class="main-container">
      <header class="admin-header">
        <div class="header-left">
          <el-button
            :icon="isCollapsed ? Expand : Fold"
            circle
            @click="isCollapsed = !isCollapsed"
          />
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/admin' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ $route.meta.title }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        
        <div class="header-right">
          <el-button :icon="House" @click="$router.push('/')">前台首页</el-button>
          <el-dropdown trigger="click" @command="handleCommand">
            <div class="user-info">
              <el-avatar :size="36" :src="userStore.user?.avatar">
                {{ userStore.user?.username?.charAt(0).toUpperCase() }}
              </el-avatar>
              <span>{{ userStore.user?.username }}</span>
              <el-icon><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="user">
                  <el-icon><User /></el-icon>
                  个人中心
                </el-dropdown-item>
                <el-dropdown-item command="logout" divided>
                  <el-icon><SwitchButton /></el-icon>
                  退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>
      
      <main class="admin-main">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useUserStore } from '@/stores/user'
import { useRouter } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import { Fold, Expand } from '@element-plus/icons-vue'

const userStore = useUserStore()
const router = useRouter()
const isCollapsed = ref(false)

const handleCommand = async (command) => {
  switch (command) {
    case 'user':
      router.push('/user')
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
.admin-layout {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  width: 240px;
  background: linear-gradient(180deg, #1a1a2e 0%, #16213e 100%);
  transition: width 0.3s ease;
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  z-index: 100;
  
  &.collapsed {
    width: 64px;
  }
  
  .sidebar-header {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    color: #fff;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    
    .logo-text {
      font-size: 18px;
      font-weight: bold;
      background: linear-gradient(135deg, var(--primary-color), #a855f7);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
  }
  
  .sidebar-menu {
    border-right: none;
    background: transparent;
    
    :deep(.el-menu-item),
    :deep(.el-sub-menu__title) {
      color: rgba(255, 255, 255, 0.7);
      
      &:hover {
        background: rgba(255, 255, 255, 0.1);
        color: #fff;
      }
    }
    
    :deep(.el-menu-item.is-active) {
      background: linear-gradient(90deg, var(--primary-color), transparent);
      color: #fff;
    }
    
    :deep(.el-sub-menu .el-menu-item) {
      padding-left: 50px !important;
      background: #16213e;
      
      &:hover {
        background: rgba(255, 255, 255, 0.1);
        color: #fff;
      }
      
      &.is-active {
        background: linear-gradient(90deg, var(--primary-color), transparent);
        color: #fff;
      }
    }
    
    :deep(.el-sub-menu .el-menu) {
      background: #16213e;
      border: none;
    }
  }
}

.main-container {
  flex: 1;
  margin-left: 240px;
  transition: margin-left 0.3s ease;
  display: flex;
  flex-direction: column;
  
  .sidebar.collapsed + & {
    margin-left: 64px;
  }
}

.admin-header {
  height: 60px;
  background: #fff;
  border-bottom: 1px solid var(--border-light);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  position: sticky;
  top: 0;
  z-index: 50;
  
  .header-left {
    display: flex;
    align-items: center;
    gap: 15px;
  }
  
  .header-right {
    display: flex;
    align-items: center;
    gap: 15px;
    
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
    }
  }
  
  :deep(.el-dropdown-menu) {
    background-color: #1a1a2e;
    border: 1px solid rgba(255, 255, 255, 0.1);
    z-index: 1000;
    overflow: visible;
    
    .el-dropdown-item {
      color: rgba(255, 255, 255, 0.7);
      
      &:hover {
        background: rgba(255, 255, 255, 0.1);
        color: #fff;
      }
    }
  }
}

.admin-main {
  flex: 1;
  padding: 20px;
  background: #f5f7fa;
}
</style>
