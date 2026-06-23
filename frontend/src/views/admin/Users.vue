<template>
  <div class="admin-users-page">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="角色">
          <el-select v-model="searchForm.role" placeholder="全部角色" clearable>
            <el-option label="管理员" value="admin" />
            <el-option label="客户" value="customer" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.is_active" placeholder="全部状态" clearable>
            <el-option label="启用" :value="true" />
            <el-option label="禁用" :value="false" />
          </el-select>
        </el-form-item>
        <el-form-item label="搜索">
          <el-input v-model="searchForm.keyword" placeholder="用户名/邮箱/手机号" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :icon="Search" @click="handleSearch">搜索</el-button>
          <el-button :icon="Refresh" @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    
    <el-card class="table-card">
      <template #header>
        <div class="card-header">
          <span>用户列表</span>
          <el-button type="primary" :icon="Plus" @click="handleAdd">添加用户</el-button>
        </div>
      </template>
      
      <el-table :data="users" v-loading="loading" stripe>
        <el-table-column label="用户" width="200">
          <template #default="{ row }">
            <div class="user-cell">
              <el-avatar :size="40" :src="row.avatar_url || row.avatar">
                {{ row.username?.charAt(0).toUpperCase() }}
              </el-avatar>
              <div class="user-info">
                <span class="username">{{ row.username }}</span>
                <span class="email">{{ row.email }}</span>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="手机号" width="130" />
        <el-table-column prop="role" label="角色" width="100">
          <template #default="{ row }">
            <el-tag :type="getRoleType(row.role)">
              {{ getRoleLabel(row.role) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="is_active" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.is_active ? 'success' : 'danger'">
              {{ row.is_active ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="注册时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.created_at) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" text size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button
              :type="row.is_active ? 'warning' : 'success'"
              text
              size="small"
              @click="handleToggleStatus(row)"
            >
              {{ row.is_active ? '禁用' : '启用' }}
            </el-button>
            <el-button type="danger" text size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="fetchUsers"
          @current-change="fetchUsers"
        />
      </div>
    </el-card>
    
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="头像">
          <el-upload
            class="avatar-uploader"
            :show-file-list="false"
            :before-upload="beforeAvatarUpload"
            accept="image/*"
          >
            <el-avatar v-if="avatarUrl" :size="80" :src="avatarUrl" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="avatar-tip">支持 jpg、png 格式，大小不超过 2MB</div>
        </el-form-item>
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" :disabled="!!form.id" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item v-if="!form.id" label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" show-password />
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="form.role" placeholder="请选择角色">
            <el-option label="管理员" value="admin" />
            <el-option label="客户" value="customer" />
          </el-select>
        </el-form-item>
        <el-form-item label="身份证号">
          <el-input v-model="form.id_card" placeholder="请输入身份证号" />
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="form.address" placeholder="请输入地址" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { userApi } from '@/api/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import dayjs from 'dayjs'

const loading = ref(false)
const submitting = ref(false)
const users = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('添加用户')
const formRef = ref(null)
const avatarFile = ref(null)
const avatarUrl = ref('')

const searchForm = reactive({
  role: null,
  is_active: null,
  keyword: '',
})

const pagination = reactive({
  page: 1,
  pageSize: 10,
  total: 0,
})

const form = reactive({
  id: null,
  username: '',
  email: '',
  phone: '',
  password: '',
  role: 'customer',
  id_card: '',
  address: '',
})

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
  role: [{ required: true, message: '请选择角色', trigger: 'change' }],
}

const getRoleType = (role) => {
  const types = { admin: 'danger', customer: 'success' }
  return types[role] || 'info'
}

const getRoleLabel = (role) => {
  const labels = { admin: '管理员', customer: '客户' }
  return labels[role] || role
}

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

const fetchUsers = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
      ...searchForm,
    }
    const res = await userApi.getList(params)
    users.value = res.results || res
    pagination.total = res.count || users.value.length
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.page = 1
  fetchUsers()
}

const resetSearch = () => {
  Object.assign(searchForm, {
    role: null,
    is_active: null,
    keyword: '',
  })
  handleSearch()
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    username: '',
    email: '',
    phone: '',
    password: '',
    role: 'customer',
    id_card: '',
    address: '',
  })
  avatarFile.value = null
  avatarUrl.value = ''
}

const beforeAvatarUpload = (file) => {
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
  return false
}

const handleAdd = () => {
  resetForm()
  dialogTitle.value = '添加用户'
  dialogVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(form, {
    id: row.id,
    username: row.username,
    email: row.email,
    phone: row.phone,
    role: row.role,
    id_card: row.id_card || '',
    address: row.address || '',
  })
  avatarUrl.value = row.avatar_url || row.avatar || ''
  avatarFile.value = null
  dialogTitle.value = '编辑用户'
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    submitting.value = true
    try {
      const formData = new FormData()
      formData.append('email', form.email)
      formData.append('phone', form.phone)
      formData.append('role', form.role)
      formData.append('id_card', form.id_card || '')
      formData.append('address', form.address || '')
      
      if (avatarFile.value) {
        formData.append('avatar', avatarFile.value)
      }
      
      if (form.id) {
        await userApi.updateUserWithAvatar(form.id, formData)
        ElMessage.success('更新成功')
      } else {
        formData.append('username', form.username)
        formData.append('password', form.password)
        await userApi.registerWithAvatar(formData)
        ElMessage.success('添加成功')
      }
      dialogVisible.value = false
      fetchUsers()
    } finally {
      submitting.value = false
    }
  })
}

const handleToggleStatus = async (row) => {
  const action = row.is_active ? '禁用' : '启用'
  await ElMessageBox.confirm(`确定要${action}该用户吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await userApi.updateUser(row.id, { is_active: !row.is_active })
  ElMessage.success(`${action}成功`)
  fetchUsers()
}

const handleDelete = async (row) => {
  await ElMessageBox.confirm('确定要删除该用户吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await userApi.deleteUser(row.id)
  ElMessage.success('删除成功')
  fetchUsers()
}

onMounted(() => {
  fetchUsers()
})
</script>

<style lang="scss" scoped>
.admin-users-page {
  .search-card {
    margin-bottom: 20px;
    border-radius: 12px;
  }
  
  .table-card {
    border-radius: 12px;
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }
  
  .user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
    
    .user-info {
      display: flex;
      flex-direction: column;
      
      .username {
        font-weight: 500;
      }
      
      .email {
        font-size: 12px;
        color: var(--text-secondary);
      }
    }
  }
  
  .avatar-uploader {
    :deep(.el-upload) {
      border: 1px dashed #d9d9d9;
      border-radius: 50%;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      transition: border-color 0.3s;
      
      &:hover {
        border-color: #409eff;
      }
    }
    
    .avatar-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 80px;
      height: 80px;
      text-align: center;
      line-height: 80px;
    }
  }
  
  .avatar-tip {
    font-size: 12px;
    color: #909399;
    margin-top: 8px;
  }
  
  .pagination {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
  }
  
  :deep(.el-select) {
    background-color: #fff;
    border-radius: 4px;
    min-width: 120px;
  }
  
  :deep(.el-tag) {
    padding: 2px 8px;
    font-size: 12px;
    border-radius: 4px;
    white-space: nowrap;
  }
  
  :deep(.el-table-column[prop="role"] .cell) {
    padding: 0 10px;
    text-align: center;
  }
  
  :deep(.el-table-column[prop="is_active"] .cell) {
    padding: 0 10px;
    text-align: center;
  }
}
</style>
