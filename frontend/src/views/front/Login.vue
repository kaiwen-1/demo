<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-left">
        <div class="login-bg"></div>
      </div>
      
      <div class="login-right">
        <div class="login-form-container animate__animated animate__fadeInRight">
          <h2>欢迎登录</h2>
          <p class="subtitle">登录您的账户，开启舒适之旅</p>
          
          <el-form ref="formRef" :model="loginForm" :rules="rules" class="login-form">
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                :prefix-icon="User"
                size="large"
              />
            </el-form-item>
            
            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                :prefix-icon="Lock"
                size="large"
                show-password
                @keyup.enter="handleLogin"
              />
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                class="login-btn"
                @click="handleLogin"
              >
                登录
              </el-button>
            </el-form-item>
            
            <div class="login-footer">
              <span>还没有账户？</span>
              <router-link to="/register" class="register-link">立即注册</router-link>
            </div>
          </el-form>
          
          <div class="demo-accounts">
            <p>演示账户：</p>
            <div class="accounts-list">
              <el-tag @click="fillDemo('admin', 'admin123')">管理员: admin/admin123</el-tag>
              <el-tag type="success" @click="fillDemo('user', 'user23')">客户: user/user23</el-tag>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const formRef = ref(null)
const loading = ref(false)

const loginForm = ref({
  username: '',
  password: '',
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

const handleLogin = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      await userStore.login(loginForm.value)
      ElMessage.success('登录成功')
      
      const redirect = route.query.redirect || '/'
      router.push(redirect)
    } catch (error) {
      console.error(error)
    } finally {
      loading.value = false
    }
  })
}

const fillDemo = (username, password) => {
  loginForm.value.username = username
  loginForm.value.password = password
}
</script>

<style lang="scss" scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  
  .login-container {
    display: flex;
    width: 100%;
    
    @media (max-width: 768px) {
      flex-direction: column;
    }
  }
  
  .login-left {
    flex: 1;
    position: relative;
    overflow: hidden;
    
    @media (max-width: 768px) {
      height: 300px;
    }
    
    .login-bg {
      position: absolute;
      inset: 0;
      background: url('https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1920') center/cover;
    }
    
    .login-content {
      position: relative;
      z-index: 1;
      height: 100%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      background: linear-gradient(135deg, rgba(255, 255, 255, 0.55), rgba(240, 242, 255, 0.45));
      color: #1a1a3e;
      text-align: center;
      padding: 20px;
      
      h1 {
        font-size: 48px;
        margin-bottom: 20px;
        background: linear-gradient(135deg, var(--primary-color), #a855f7);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
      }
      
      p {
        font-size: 20px;
        color: rgba(26, 26, 46, 0.7);
      }
    }
  }
  
  .login-right {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px;
    background: #fff;
    
    @media (max-width: 768px) {
      padding: 30px 20px;
    }
    
    .login-form-container {
      width: 100%;
      max-width: 400px;
      
      h2 {
        font-size: 32px;
        margin-bottom: 10px;
        color: var(--text-primary);
      }
      
      .subtitle {
        color: var(--text-secondary);
        margin-bottom: 30px;
      }
      
      .login-form {
        .login-btn {
          width: 100%;
          height: 48px;
          font-size: 16px;
          background: linear-gradient(135deg, var(--primary-color), #a855f7);
          border: none;
          
          &:hover {
            opacity: 0.9;
          }
        }
      }
      
      .login-footer {
        text-align: center;
        color: var(--text-secondary);
        
        .register-link {
          color: var(--primary-color);
          font-weight: 500;
          margin-left: 5px;
          
          &:hover {
            text-decoration: underline;
          }
        }
      }
      
      .demo-accounts {
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid var(--border-light);
        
        p {
          color: var(--text-secondary);
          margin-bottom: 10px;
        }
        
        .accounts-list {
          display: flex;
          flex-wrap: wrap;
          gap: 10px;
          
          .el-tag {
            cursor: pointer;
            transition: all 0.3s ease;
            
            &:hover {
              transform: translateY(-2px);
            }
          }
        }
      }
    }
  }
}
</style>
