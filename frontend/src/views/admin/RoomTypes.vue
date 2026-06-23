<template>
  <div class="admin-room-types-page">
    <el-card class="table-card">
      <template #header>
        <div class="card-header">
          <span>房型管理</span>
          <el-button type="primary" :icon="Plus" @click="handleAdd">添加房型</el-button>
        </div>
      </template>
      
      <el-table :data="roomTypes" v-loading="loading" stripe>
        <el-table-column prop="name" label="房型名称" width="150" />
        <el-table-column label="图片" width="100">
          <template #default="{ row }">
            <el-image 
              v-if="row.image_url || row.image" 
              :src="row.image_url || row.image" 
              :preview-src-list="[row.image_url || row.image]"
              fit="cover"
              style="width: 60px; height: 40px; border-radius: 4px;"
            />
            <span v-else style="color: #999;">暂无图片</span>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" show-overflow-tooltip />
        <el-table-column prop="price" label="价格" width="100">
          <template #default="{ row }">
            ¥{{ row.price }}/晚
          </template>
        </el-table-column>
        <el-table-column prop="capacity" label="容纳人数" width="100">
          <template #default="{ row }">
            {{ row.capacity }}人
          </template>
        </el-table-column>
        <el-table-column prop="size" label="面积" width="100">
          <template #default="{ row }">
            {{ row.size }}㎡
          </template>
        </el-table-column>
        <el-table-column label="设施" width="250">
          <template #default="{ row }">
            <el-tag v-for="item in row.amenities?.slice(0, 3)" :key="item" size="small" style="margin: 2px">
              {{ item }}
            </el-tag>
            <el-tag v-if="row.amenities?.length > 3" size="small" type="info">
              +{{ row.amenities.length - 3 }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="is_active" label="启用状态" width="100">
          <template #default="{ row }">
            <el-switch v-model="row.is_active" @change="handleStatusChange(row)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" text size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" text size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="房型名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入房型名称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入描述" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="价格" prop="price">
              <el-input-number v-model="form.price" :min="0" :precision="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="容纳人数" prop="capacity">
              <el-input-number v-model="form.capacity" :min="1" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="面积(㎡)" prop="size">
              <el-input-number v-model="form.size" :min="1" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="是否启用">
              <el-switch v-model="form.is_active" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="设施" prop="amenities">
          <el-select v-model="form.amenities" multiple filterable allow-create placeholder="请选择或输入设施" style="width: 100%">
            <el-option v-for="item in amenityOptions" :key="item" :label="item" :value="item" />
          </el-select>
        </el-form-item>
        <el-form-item label="房型图片">
          <el-upload
            class="image-uploader"
            :action="uploadUrl"
            :show-file-list="false"
            :before-upload="beforeImageUpload"
            :on-success="handleImageSuccess"
            :headers="uploadHeaders"
            accept="image/*"
          >
            <el-image 
              v-if="imageUrl" 
              :src="imageUrl" 
              fit="cover"
              class="uploaded-image"
            />
            <el-icon v-else class="image-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="image-tip">支持 jpg、png 格式，大小不超过 2MB</div>
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
import { ref, reactive, onMounted, computed } from 'vue'
import { roomApi } from '@/api/room'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

const loading = ref(false)
const submitting = ref(false)
const roomTypes = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('添加房型')
const formRef = ref(null)
const imageFile = ref(null)
const imageUrl = ref('')

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || '/api'
const uploadUrl = computed(() => {
  return form.id ? `${apiBaseUrl}/rooms/types/${form.id}/` : `${apiBaseUrl}/rooms/types/`
})

function getCookie(name) {
  const cookieValue = document.cookie.match('(^|;)\\s*' + name + '\\s*=\\s*([^;]+)');
  return cookieValue ? cookieValue.pop() : '';
}

const uploadHeaders = computed(() => {
  return {
    'X-CSRFToken': getCookie('csrftoken')
  }
})

const amenityOptions = [
  '免费WiFi', '空调', '液晶电视', '独立卫浴', '24小时热水', '吹风机', '洗漱用品',
  '迷你吧', '保险箱', '办公桌椅', '浴缸', '会客沙发', '茶几', '迷你厨房',
  '儿童拖鞋', '儿童牙刷', '打印机', '传真机', '中央空调', '智能电视',
]

const form = reactive({
  id: null,
  name: '',
  description: '',
  price: 100,
  capacity: 2,
  size: 30,
  amenities: [],
  is_active: true,
})

const rules = {
  name: [{ required: true, message: '请输入房型名称', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'change' }],
  capacity: [{ required: true, message: '请输入容纳人数', trigger: 'change' }],
  size: [{ required: true, message: '请输入面积', trigger: 'change' }],
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

const resetForm = () => {
  Object.assign(form, {
    id: null,
    name: '',
    description: '',
    price: 100,
    capacity: 2,
    size: 30,
    amenities: [],
    is_active: true,
  })
  imageFile.value = null
  imageUrl.value = ''
}

const handleAdd = () => {
  resetForm()
  dialogTitle.value = '添加房型'
  dialogVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(form, {
    id: row.id,
    name: row.name,
    description: row.description,
    price: row.price,
    capacity: row.capacity,
    size: row.size,
    amenities: row.amenities || [],
    is_active: row.is_active,
  })
  imageUrl.value = row.image_url || row.image || ''
  imageFile.value = null
  dialogTitle.value = '编辑房型'
  dialogVisible.value = true
}

const beforeImageUpload = (file) => {
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
  
  imageFile.value = file
  const reader = new FileReader()
  reader.onload = (e) => {
    imageUrl.value = e.target.result
  }
  reader.readAsDataURL(file)
  return false
}

const handleImageSuccess = (response) => {
  if (response.image_url) {
    imageUrl.value = response.image_url
  }
  ElMessage.success('图片上传成功')
}

const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    submitting.value = true
    try {
      const formData = new FormData()
      formData.append('name', form.name)
      formData.append('description', form.description || '')
      formData.append('price', form.price)
      formData.append('capacity', form.capacity)
      formData.append('size', form.size)
      formData.append('is_active', form.is_active)
      formData.append('amenities', JSON.stringify(form.amenities))
      
      if (imageFile.value) {
        formData.append('image', imageFile.value)
      }
      
      if (form.id) {
        await roomApi.updateTypeWithImage(form.id, formData)
        ElMessage.success('更新成功')
      } else {
        await roomApi.createTypeWithImage(formData)
        ElMessage.success('添加成功')
      }
      dialogVisible.value = false
      fetchRoomTypes()
    } finally {
      submitting.value = false
    }
  })
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该房型吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    })
    
    await roomApi.deleteType(row.id)
    ElMessage.success('删除成功')
    fetchRoomTypes()
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      console.error('删除失败:', error)
      ElMessage.error(error.response?.data?.detail || error.message || '删除失败')
    }
  }
}

const handleStatusChange = async (row) => {
  await roomApi.updateType(row.id, { is_active: row.is_active })
  ElMessage.success('状态更新成功')
}

onMounted(() => {
  fetchRoomTypes()
})
</script>

<style lang="scss" scoped>
.admin-room-types-page {
  .table-card {
    border-radius: 12px;
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }
  
  .image-uploader {
    :deep(.el-upload) {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      transition: border-color 0.3s;
      
      &:hover {
        border-color: #409eff;
      }
    }
    
    .image-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 120px;
      height: 120px;
      text-align: center;
      line-height: 120px;
    }
    
    .uploaded-image {
      width: 120px;
      height: 120px;
      display: block;
    }
  }
  
  .image-tip {
    font-size: 12px;
    color: #909399;
    margin-top: 8px;
  }
}
</style>
