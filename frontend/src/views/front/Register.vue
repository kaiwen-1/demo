<template>
  <div class="register-page">
    <div class="register-container">
      <div class="register-left">
        <div class="register-bg"></div>
      </div>
      
      <div class="register-right">
        <div class="register-form-container animate__animated animate__fadeInRight">
          <h2>创建账户</h2>
          <p class="subtitle">注册成为会员，开启您的旅程</p>
          
          <el-form ref="formRef" :model="registerForm" :rules="rules" class="register-form">
            <el-form-item prop="username">
              <el-input
                v-model="registerForm.username"
                placeholder="请输入用户名"
                :prefix-icon="User"
                size="large"
              />
            </el-form-item>
            
            <el-form-item prop="email">
              <el-input
                v-model="registerForm.email"
                placeholder="请输入邮箱"
                :prefix-icon="Message"
                size="large"
              />
            </el-form-item>
            
            <el-form-item prop="phone">
              <el-input
                v-model="registerForm.phone"
                placeholder="请输入手机号"
                :prefix-icon="Phone"
                size="large"
              />
            </el-form-item>
            
            <el-form-item prop="password">
              <el-input
                v-model="registerForm.password"
                type="password"
                placeholder="请输入密码"
                :prefix-icon="Lock"
                size="large"
                show-password
              />
            </el-form-item>
            
            <el-form-item prop="password_confirm">
              <el-input
                v-model="registerForm.password_confirm"
                type="password"
                placeholder="请确认密码"
                :prefix-icon="Lock"
                size="large"
                show-password
                @keyup.enter="handleRegister"
              />
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                class="register-btn"
                @click="handleRegister"
              >
                注册
              </el-button>
            </el-form-item>
            
            <div class="register-footer">
              <span>已有账户？</span>
              <router-link to="/login" class="login-link">立即登录</router-link>
            </div>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { userApi } from '@/api/user'
import { ElMessage } from 'element-plus'
import { User, Lock, Message, Phone } from '@element-plus/icons-vue'

const router = useRouter()

const formRef = ref(null)
const loading = ref(false)

const registerForm = ref({
  username: '',
  email: '',
  phone: '',
  password: '',
  password_confirm: '',
})

const validatePass = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入密码'))
  } else if (value !== registerForm.value.password) {
    callback(new Error('两次输入密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' },
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' },
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6个字符', trigger: 'blur' },
  ],
  password_confirm: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validatePass, trigger: 'blur' },
  ],
}

const handleRegister = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      await userApi.register(registerForm.value)
      ElMessage.success('注册成功，请登录')
      router.push('/login')
    } catch (error) {
      console.error(error)
    } finally {
      loading.value = false
    }
  })
}
</script>

<style lang="scss" scoped>
.register-page {
  min-height: 100vh;
  display: flex;
  
  .register-container {
    display: flex;
    width: 100%;
    
    @media (max-width: 768px) {
      flex-direction: column-reverse;
    }
  }
  
  .register-left {
    flex: 1;
    position: relative;
    overflow: hidden;
    
    @media (max-width: 768px) {
      height: 250px;
    }
    
    .register-bg {
      position: absolute;
      inset: 0;
      background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1920') center/cover;
    }
    
    .register-content {
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
  
  .register-right {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px;
    background: #fff;
    
    @media (max-width: 768px) {
      padding: 30px 20px;
    }
    
    .register-form-container {
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
      
      .register-form {
        .register-btn {
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
      
      .register-footer {
        text-align: center;
        color: var(--text-secondary);
        
        .login-link {
          color: var(--primary-color);
          font-weight: 500;
          margin-left: 5px;
          
          &:hover {
            text-decoration: underline;
          }
        }
      }
    }
  }
}
</style>
