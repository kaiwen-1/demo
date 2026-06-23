<template>
  <div class="system-config-component">
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        添加配置
      </el-button>
    </div>
    
    <el-table :data="configs" v-loading="loading" stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="key" label="配置键" width="200" />
      <el-table-column prop="value" label="配置值" show-overflow-tooltip />
      <el-table-column prop="description" label="描述" />
      <el-table-column label="更新时间" width="180">
        <template #default="{ row }">
          {{ formatDate(row.updated_at) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" text @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" text @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-dialog v-model="dialogVisible" :title="editingConfig ? '编辑配置' : '添加配置'" width="500px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="配置键" prop="key">
          <el-input v-model="form.key" placeholder="请输入配置键" :disabled="!!editingConfig" />
        </el-form-item>
        <el-form-item label="配置值" prop="value">
          <el-input v-model="form.value" type="textarea" :rows="4" placeholder="请输入配置值" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" placeholder="请输入描述" />
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
import { systemApi } from '@/api/system'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'

const loading = ref(false)
const saving = ref(false)
const configs = ref([])
const dialogVisible = ref(false)
const editingConfig = ref(null)
const formRef = ref(null)

const form = reactive({
  key: '',
  value: '',
  description: '',
})

const rules = {
  key: [{ required: true, message: '请输入配置键', trigger: 'blur' }],
  value: [{ required: true, message: '请输入配置值', trigger: 'blur' }],
}

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm:ss')

const fetchConfigs = async () => {
  loading.value = true
  try {
    const res = await systemApi.getConfigs()
    configs.value = res.results || res
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  form.key = ''
  form.value = ''
  form.description = ''
  editingConfig.value = null
}

const handleAdd = () => {
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (config) => {
  editingConfig.value = config
  form.key = config.key
  form.value = config.value
  form.description = config.description || ''
  dialogVisible.value = true
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    saving.value = true
    try {
      if (editingConfig.value) {
        await systemApi.updateConfig(editingConfig.value.key, form)
        ElMessage.success('更新成功')
      } else {
        await systemApi.createConfig(form)
        ElMessage.success('添加成功')
      }
      dialogVisible.value = false
      fetchConfigs()
    } finally {
      saving.value = false
    }
  })
}

const handleDelete = async (config) => {
  await ElMessageBox.confirm('确定要删除该配置吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await systemApi.deleteConfig(config.key)
  ElMessage.success('删除成功')
  fetchConfigs()
}

onMounted(() => {
  fetchConfigs()
})
</script>

<style lang="scss" scoped>
.system-config-component {
  .toolbar {
    margin-bottom: 20px;
  }
}
</style>
