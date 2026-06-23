<template>
  <div class="promotions-component">
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        添加活动
      </el-button>
    </div>
    
    <el-table :data="promotions" v-loading="loading" stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="title" label="活动标题" />
      <el-table-column label="优惠类型" width="120">
        <template #default="{ row }">
          <el-tag>{{ row.discount_type_display }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="discount_value" label="优惠值" width="100" />
      <el-table-column label="活动时间" width="200">
        <template #default="{ row }">
          {{ formatDate(row.start_time) }} 至 {{ formatDate(row.end_time) }}
        </template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="getStatusType(row.status)">{{ row.status_display }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" text @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" text @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-dialog v-model="dialogVisible" :title="editingPromotion ? '编辑活动' : '添加活动'" width="700px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="活动标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入活动标题" />
        </el-form-item>
        <el-form-item label="活动描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入活动描述" />
        </el-form-item>
        <el-form-item label="活动图片" prop="image">
          <el-upload
            class="promotion-uploader"
            :action="uploadUrl"
            :show-file-list="false"
            :on-success="handleUploadSuccess"
            :headers="uploadHeaders"
          >
            <el-image v-if="form.image" :src="form.image" style="width: 200px; height: 120px" fit="cover" />
            <el-icon v-else class="promotion-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="优惠类型" prop="discount_type">
          <el-select v-model="form.discount_type">
            <el-option label="百分比折扣" value="percentage" />
            <el-option label="固定金额" value="fixed" />
            <el-option label="特价" value="special" />
          </el-select>
        </el-form-item>
        <el-form-item label="优惠值" prop="discount_value">
          <el-input-number v-model="form.discount_value" :min="0" :precision="2" />
          <span class="form-tip">{{ form.discount_type === 'percentage' ? '(百分比，如10表示打9折)' : '(金额)' }}</span>
        </el-form-item>
        <el-form-item label="活动时间" prop="timeRange">
          <el-date-picker
            v-model="timeRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status">
            <el-option label="草稿" value="draft" />
            <el-option label="进行中" value="active" />
            <el-option label="已暂停" value="paused" />
            <el-option label="已结束" value="ended" />
          </el-select>
        </el-form-item>
        <el-form-item label="排序" prop="sort_order">
          <el-input-number v-model="form.sort_order" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { operationApi } from '@/api/operation'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'

const loading = ref(false)
const saving = ref(false)
const promotions = ref([])
const dialogVisible = ref(false)
const editingPromotion = ref(null)
const formRef = ref(null)
const timeRange = ref([])

const uploadUrl = import.meta.env.VITE_API_BASE_URL + '/rooms/upload-image/'
const uploadHeaders = {}

const form = reactive({
  title: '',
  description: '',
  image: '',
  discount_type: 'percentage',
  discount_value: 10,
  status: 'draft',
  sort_order: 0,
  room_types: [],
})

const rules = {
  title: [{ required: true, message: '请输入活动标题', trigger: 'blur' }],
  discount_type: [{ required: true, message: '请选择优惠类型', trigger: 'change' }],
  discount_value: [{ required: true, message: '请输入优惠值', trigger: 'blur' }],
}

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

const getStatusType = (status) => {
  const types = { draft: 'info', active: 'success', paused: 'warning', ended: 'danger' }
  return types[status] || 'info'
}

const fetchPromotions = async () => {
  loading.value = true
  try {
    const res = await operationApi.getPromotions()
    promotions.value = res.results || res
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  form.title = ''
  form.description = ''
  form.image = ''
  form.discount_type = 'percentage'
  form.discount_value = 10
  form.status = 'draft'
  form.sort_order = 0
  form.room_types = []
  timeRange.value = []
  editingPromotion.value = null
}

const handleUploadSuccess = (response) => {
  form.image = response.url || response.image
}

const handleAdd = () => {
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (promotion) => {
  editingPromotion.value = promotion
  form.title = promotion.title
  form.description = promotion.description || ''
  form.image = promotion.image || ''
  form.discount_type = promotion.discount_type
  form.discount_value = promotion.discount_value
  form.status = promotion.status
  form.sort_order = promotion.sort_order
  form.room_types = promotion.room_types || []
  if (promotion.start_time && promotion.end_time) {
    timeRange.value = [promotion.start_time, promotion.end_time]
  }
  dialogVisible.value = true
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    const data = { ...form }
    if (timeRange.value && timeRange.value.length === 2) {
      data.start_time = timeRange.value[0]
      data.end_time = timeRange.value[1]
    }
    
    saving.value = true
    try {
      if (editingPromotion.value) {
        await operationApi.updatePromotion(editingPromotion.value.id, data)
        ElMessage.success('更新成功')
      } else {
        await operationApi.createPromotion(data)
        ElMessage.success('添加成功')
      }
      dialogVisible.value = false
      fetchPromotions()
    } finally {
      saving.value = false
    }
  })
}

const handleDelete = async (promotion) => {
  await ElMessageBox.confirm('确定要删除该活动吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await operationApi.deletePromotion(promotion.id)
  ElMessage.success('删除成功')
  fetchPromotions()
}

onMounted(() => {
  fetchPromotions()
})
</script>

<style lang="scss" scoped>
.promotions-component {
  .toolbar {
    margin-bottom: 20px;
  }
  
  .promotion-uploader {
    :deep(.el-upload) {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      
      &:hover {
        border-color: #409EFF;
      }
    }
    
    .promotion-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 200px;
      height: 120px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
  
  .form-tip {
    margin-left: 10px;
    color: var(--text-secondary);
    font-size: 12px;
  }
}
</style>
