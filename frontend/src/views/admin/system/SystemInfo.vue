<template>
  <div class="system-info-component">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-card header="系统信息" v-loading="loading">
          <el-descriptions :column="1" border>
            <el-descriptions-item label="操作系统">{{ info.system?.os }}</el-descriptions-item>
            <el-descriptions-item label="系统版本">{{ info.system?.os_version }}</el-descriptions-item>
            <el-descriptions-item label="Python版本">{{ info.system?.python_version }}</el-descriptions-item>
            <el-descriptions-item label="Django版本">{{ info.system?.django_version }}</el-descriptions-item>
            <el-descriptions-item label="时区">{{ info.time?.timezone }}</el-descriptions-item>
            <el-descriptions-item label="当前时间">{{ info.time?.current }}</el-descriptions-item>
            <el-descriptions-item label="调试模式">
              <el-tag :type="info.debug ? 'danger' : 'success'">
                {{ info.debug ? '开启' : '关闭' }}
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
        </el-card>
      </el-col>
      
      <el-col :span="12">
        <el-card header="数据库信息">
          <el-descriptions :column="1" border>
            <el-descriptions-item label="数据库引擎">{{ info.database?.engine }}</el-descriptions-item>
            <el-descriptions-item label="数据库名称">{{ info.database?.name }}</el-descriptions-item>
            <el-descriptions-item label="连接状态">
              <el-tag :type="dbStatus.status === 'healthy' ? 'success' : 'danger'">
                {{ dbStatus.message }}
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
        </el-card>
        
        <el-card header="系统操作" style="margin-top: 20px">
          <div class="action-buttons">
            <el-button type="primary" @click="handleBackup" :loading="backingUp">
              <el-icon><Download /></el-icon>
              备份数据库
            </el-button>
            <el-button type="warning" @click="handleClearCache" :loading="clearingCache">
              <el-icon><Delete /></el-icon>
              清除缓存
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { systemApi } from '@/api/system'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const backingUp = ref(false)
const clearingCache = ref(false)

const info = reactive({
  system: {},
  database: {},
  time: {},
  debug: false,
})

const dbStatus = reactive({
  status: '',
  message: '',
})

const fetchSystemInfo = async () => {
  loading.value = true
  try {
    const res = await systemApi.getSystemInfo()
    Object.assign(info, res)
  } finally {
    loading.value = false
  }
}

const fetchDbStatus = async () => {
  try {
    const res = await systemApi.getDatabaseStatus()
    dbStatus.status = res.status
    dbStatus.message = res.message
  } catch (error) {
    dbStatus.status = 'error'
    dbStatus.message = '连接失败'
  }
}

const handleBackup = async () => {
  backingUp.value = true
  try {
    const res = await systemApi.backupDatabase()
    const blob = new Blob([res.data], { type: 'application/json' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `database_backup_${res.timestamp}.json`
    a.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('备份成功')
  } catch (error) {
    ElMessage.error('备份失败')
  } finally {
    backingUp.value = false
  }
}

const handleClearCache = async () => {
  clearingCache.value = true
  try {
    await systemApi.clearCache()
    ElMessage.success('缓存已清除')
  } catch (error) {
    ElMessage.error('清除缓存失败')
  } finally {
    clearingCache.value = false
  }
}

onMounted(() => {
  fetchSystemInfo()
  fetchDbStatus()
})
</script>

<style lang="scss" scoped>
.system-info-component {
  .action-buttons {
    display: flex;
    gap: 15px;
  }
}
</style>
