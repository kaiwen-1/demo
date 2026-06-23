<template>
  <div class="user-center-page">
    <div class="page-header">
      <h1>个人中心</h1>
      <p>管理您的个人信息</p>
    </div>
    
    <div class="user-container">
      <div class="user-sidebar">
        <div class="user-avatar">
          <el-upload
            class="avatar-uploader"
            :show-file-list="false"
            :before-upload="beforeAvatarUpload"
            accept="image/*"
          >
            <el-avatar :size="80" :src="avatarUrl || userStore.user?.avatar_url || userStore.user?.avatar">
              {{ userStore.user?.username?.charAt(0).toUpperCase() }}
            </el-avatar>
            <div class="avatar-overlay">
              <el-icon><Camera /></el-icon>
              <span>更换头像</span>
            </div>
          </el-upload>
          <h3>{{ userStore.user?.username }}</h3>
          <el-tag :type="getRoleType(userStore.user?.role)">
            {{ getRoleLabel(userStore.user?.role) }}
          </el-tag>
        </div>
        
        <el-menu :default-active="$route.path" router>
          <el-menu-item index="/user">
            <el-icon><User /></el-icon>
            <span>个人信息</span>
          </el-menu-item>
          <el-menu-item index="/user/bookings">
            <el-icon><Calendar /></el-icon>
            <span>我的预订</span>
          </el-menu-item>
          <el-menu-item index="/user/favorites">
            <el-icon><Star /></el-icon>
            <span>我的收藏</span>
          </el-menu-item>
          <el-menu-item index="/user/notifications">
            <el-icon><Bell /></el-icon>
            <span>消息通知</span>
            <el-badge v-if="unreadCount > 0" :value="unreadCount" class="notification-badge" />
          </el-menu-item>
        </el-menu>
      </div>
      
      <div class="user-content">
        <el-card class="info-card">
          <template #header>
            <div class="card-header">
              <span>基本信息</span>
              <el-button type="primary" text @click="editMode = !editMode">
                {{ editMode ? '取消' : '编辑' }}
              </el-button>
            </div>
          </template>
          
          <el-form
            ref="formRef"
            :model="userForm"
            :rules="rules"
            label-width="100px"
            :disabled="!editMode"
          >
            <el-form-item label="用户名">
              <el-input :model-value="userStore.user?.username" disabled />
            </el-form-item>
            
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="userForm.email" />
            </el-form-item>
            
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="userForm.phone" />
            </el-form-item>
            
            <el-form-item label="身份证号">
              <el-input v-model="userForm.id_card" placeholder="请输入身份证号" />
            </el-form-item>
            
            <el-form-item label="地址">
              <el-input v-model="userForm.address" placeholder="请输入地址" />
            </el-form-item>
            
            <el-form-item v-if="editMode">
              <el-button type="primary" :loading="saving" @click="handleSave">
                保存
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
        
        <el-card class="password-card">
          <template #header>
            <span>修改密码</span>
          </template>
          
          <el-form
            ref="passwordFormRef"
            :model="passwordForm"
            :rules="passwordRules"
            label-width="100px"
          >
            <el-form-item label="原密码" prop="old_password">
              <el-input v-model="passwordForm.old_password" type="password" show-password />
            </el-form-item>
            
            <el-form-item label="新密码" prop="new_password">
              <el-input v-model="passwordForm.new_password" type="password" show-password />
            </el-form-item>
            
            <el-form-item label="确认密码" prop="new_password_confirm">
              <el-input v-model="passwordForm.new_password_confirm" type="password" show-password />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" :loading="changingPassword" @click="handleChangePassword">
                修改密码
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { notificationApi } from '@/api/notification'
import { ElMessage } from 'element-plus'
import { Camera } from '@element-plus/icons-vue'

const userStore = useUserStore()

const editMode = ref(false)
const saving = ref(false)
const changingPassword = ref(false)
const formRef = ref(null)
const passwordFormRef = ref(null)
const unreadCount = ref(0)
const avatarUrl = ref('')
const avatarFile = ref(null)

const userForm = reactive({
  email: '',
  phone: '',
  id_card: '',
  address: '',
})

const passwordForm = reactive({
  old_password: '',
  new_password: '',
  new_password_confirm: '',
})

const rules = {
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' },
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' },
  ],
}

const validatePass = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入密码'))
  } else if (value !== passwordForm.new_password) {
    callback(new Error('两次输入密码不一致'))
  } else {
    callback()
  }
}

const passwordRules = {
  old_password: [{ required: true, message: '请输入原密码', trigger: 'blur' }],
  new_password: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6个字符', trigger: 'blur' },
  ],
  new_password_confirm: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    { validator: validatePass, trigger: 'blur' },
  ],
}

const getRoleType = (role) => {
  const types = { admin: 'danger', customer: 'success' }
  return types[role] || 'info'
}

const getRoleLabel = (role) => {
  const labels = { admin: '管理员', customer: '客户' }
  return labels[role] || '未知'
}

const initForm = () => {
  if (userStore.user) {
    userForm.email = userStore.user.email || ''
    userForm.phone = userStore.user.phone || ''
    userForm.id_card = userStore.user.id_card || ''
    userForm.address = userStore.user.address || ''
    avatarUrl.value = userStore.user.avatar_url || userStore.user.avatar || ''
  }
}

const beforeAvatarUpload = async (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  
  avatarFile.value = file
  const reader = new FileReader()
  reader.onload = (e) => {
    avatarUrl.value = e.target.result
  }
  reader.readAsDataURL(file)
  
  const formData = new FormData()
  formData.append('avatar', file)
  
  try {
    await userStore.updateProfileWithAvatar(formData)
    ElMessage.success('头像更新成功')
  } catch (error) {
    ElMessage.error('头像更新失败')
  }
  
  return false
}

const fetchUnreadCount = async () => {
  try {
    const res = await notificationApi.getUnreadCount()
    unreadCount.value = res.unread_count
  } catch (error) {
    console.error('获取未读消息数量失败')
  }
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    saving.value = true
    try {
      await userStore.updateProfile(userForm)
      ElMessage.success('保存成功')
      editMode.value = false
    } finally {
      saving.value = false
    }
  })
}

const handleChangePassword = async () => {
  if (!passwordFormRef.value) return
  
  await passwordFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    changingPassword.value = true
    try {
      await userStore.changePassword(passwordForm)
      ElMessage.success('密码修改成功')
      passwordFormRef.value.resetFields()
    } finally {
      changingPassword.value = false
    }
  })
}

onMounted(() => {
  initForm()
  fetchUnreadCount()
})
</script>

<style lang="scss" scoped>
.user-center-page {
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
  
  .user-container {
    max-width: 1200px;
    margin: -20px auto 40px;
    padding: 0 20px;
    display: flex;
    gap: 20px;
    
    @media (max-width: 768px) {
      flex-direction: column;
    }
  }
  
  .user-sidebar {
    width: 250px;
    flex-shrink: 0;
    
    @media (max-width: 768px) {
      width: 100%;
    }
    
    .user-avatar {
      background: #fff;
      border-radius: 12px;
      padding: 30px 20px;
      text-align: center;
      margin-bottom: 15px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      h3 {
        margin: 15px 0 10px;
        font-size: 18px;
      }
      
      .avatar-uploader {
        position: relative;
        display: inline-block;
        cursor: pointer;
        
        .avatar-overlay {
          position: absolute;
          top: 0;
          left: 0;
          width: 80px;
          height: 80px;
          border-radius: 50%;
          background: rgba(0, 0, 0, 0.5);
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          opacity: 0;
          transition: opacity 0.3s;
          color: #fff;
          
          .el-icon {
            font-size: 20px;
            margin-bottom: 4px;
          }
          
          span {
            font-size: 12px;
          }
        }
        
        &:hover .avatar-overlay {
          opacity: 1;
        }
      }
    }
    
    .el-menu {
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      
      .notification-badge {
        margin-left: 8px;
      }
    }
  }
  
  .user-content {
    flex: 1;
    
    .el-card {
      margin-bottom: 20px;
      border-radius: 12px;
      
      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
    }
  }
}
</style>
