<template>
  <div class="admin-rooms-page">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="房间号">
          <el-input v-model="searchForm.room_number" placeholder="请输入房间号" clearable />
        </el-form-item>
        <el-form-item label="房型">
          <el-select v-model="searchForm.room_type" placeholder="全部房型" clearable style="width: 180px;">
            <el-option v-for="type in roomTypes" :key="type.id" :label="type.name" :value="type.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="全部状态" clearable>
            <el-option label="空闲" value="available" />
            <el-option label="已入住" value="occupied" />
            <el-option label="维护中" value="maintenance" />
            <el-option label="清洁中" value="cleaning" />
          </el-select>
        </el-form-item>
        <el-form-item label="楼层">
          <el-select v-model="searchForm.floor" placeholder="全部楼层" clearable>
            <el-option v-for="i in 10" :key="i" :label="`${i}楼`" :value="i" />
          </el-select>
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
          <span>房间列表</span>
          <el-button type="primary" :icon="Plus" @click="handleAdd">添加房间</el-button>
        </div>
      </template>
      
      <el-table :data="rooms" v-loading="loading" stripe>
        <el-table-column prop="room_number" label="房间号" width="100" />
        <el-table-column prop="floor" label="楼层" width="80">
          <template #default="{ row }">
            {{ row.floor }}楼
          </template>
        </el-table-column>
        <el-table-column label="房型" width="150">
          <template #default="{ row }">
            {{ row.room_type?.name }}
          </template>
        </el-table-column>
        <el-table-column label="价格" width="100">
          <template #default="{ row }">
            ¥{{ row.room_type?.price }}/晚
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" show-overflow-tooltip />
        <el-table-column prop="is_active" label="启用状态" width="100">
          <template #default="{ row }">
            <el-switch v-model="row.is_active" @change="handleStatusChange(row)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" text size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="warning" text size="small" @click="handleChangeStatus(row)">更改状态</el-button>
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
          @size-change="fetchRooms"
          @current-change="fetchRooms"
        />
      </div>
    </el-card>
    
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
      destroy-on-close
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="房间号" prop="room_number">
          <el-input v-model="form.room_number" placeholder="请输入房间号" />
        </el-form-item>
        <el-form-item label="楼层" prop="floor">
          <el-input-number v-model="form.floor" :min="1" :max="50" />
        </el-form-item>
        <el-form-item label="房型" prop="room_type">
          <el-select v-model="form.room_type" placeholder="请选择房型" style="width: 100%;">
            <el-option v-for="type in roomTypes" :key="type.id" :label="type.name" :value="type.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态">
            <el-option label="空闲" value="available" />
            <el-option label="已入住" value="occupied" />
            <el-option label="维护中" value="maintenance" />
            <el-option label="清洁中" value="cleaning" />
          </el-select>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="是否启用">
          <el-switch v-model="form.is_active" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
    
    <el-dialog v-model="statusDialogVisible" title="更改房间状态" width="400px">
      <el-form label-width="80px">
        <el-form-item label="当前状态">
          <el-tag :type="getStatusType(currentRoom?.status)">
            {{ getStatusLabel(currentRoom?.status) }}
          </el-tag>
        </el-form-item>
        <el-form-item label="新状态">
          <el-select v-model="newStatus" placeholder="请选择新状态">
            <el-option label="空闲" value="available" />
            <el-option label="已入住" value="occupied" />
            <el-option label="维护中" value="maintenance" />
            <el-option label="清洁中" value="cleaning" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="statusDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="submitStatusChange">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { roomApi } from '@/api/room'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const submitting = ref(false)
const rooms = ref([])
const roomTypes = ref([])
const dialogVisible = ref(false)
const statusDialogVisible = ref(false)
const dialogTitle = ref('添加房间')
const formRef = ref(null)
const currentRoom = ref(null)
const newStatus = ref('')

const searchForm = reactive({
  room_number: '',
  room_type: null,
  status: null,
  floor: null,
})

const pagination = reactive({
  page: 1,
  pageSize: 10,
  total: 0,
})

const form = reactive({
  id: null,
  room_number: '',
  floor: 1,
  room_type: null,
  status: 'available',
  description: '',
  is_active: true,
})

const rules = {
  room_number: [{ required: true, message: '请输入房间号', trigger: 'blur' }],
  floor: [{ required: true, message: '请输入楼层', trigger: 'change' }],
  room_type: [{ required: true, message: '请选择房型', trigger: 'change' }],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }],
}

const getStatusType = (status) => {
  const types = {
    available: 'success',
    occupied: 'warning',
    maintenance: 'danger',
    cleaning: 'info',
  }
  return types[status] || 'info'
}

const getStatusLabel = (status) => {
  const labels = {
    available: '空闲',
    occupied: '已入住',
    maintenance: '维护中',
    cleaning: '清洁中',
  }
  return labels[status] || status
}

const fetchRoomTypes = async () => {
  const res = await roomApi.getTypes()
  roomTypes.value = res.results || res
}

const fetchRooms = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
      ...searchForm,
    }
    const res = await roomApi.getList(params)
    rooms.value = res.results || res
    pagination.total = res.count || rooms.value.length
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.page = 1
  fetchRooms()
}

const resetSearch = () => {
  Object.assign(searchForm, {
    room_number: '',
    room_type: null,
    status: null,
    floor: null,
  })
  handleSearch()
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    room_number: '',
    floor: 1,
    room_type: null,
    status: 'available',
    description: '',
    is_active: true,
  })
}

const handleAdd = () => {
  resetForm()
  dialogTitle.value = '添加房间'
  dialogVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(form, {
    id: row.id,
    room_number: row.room_number,
    floor: row.floor,
    room_type: row.room_type?.id || row.room_type,
    status: row.status,
    description: row.description,
    is_active: row.is_active,
  })
  dialogTitle.value = '编辑房间'
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    submitting.value = true
    try {
      if (form.id) {
        await roomApi.updateRoom(form.id, form)
        ElMessage.success('更新成功')
      } else {
        await roomApi.createRoom(form)
        ElMessage.success('添加成功')
      }
      dialogVisible.value = false
      fetchRooms()
    } finally {
      submitting.value = false
    }
  })
}

const handleDelete = async (row) => {
  await ElMessageBox.confirm('确定要删除该房间吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await roomApi.deleteRoom(row.id)
  ElMessage.success('删除成功')
  fetchRooms()
}

const handleStatusChange = async (row) => {
  await roomApi.updateRoom(row.id, { is_active: row.is_active })
  ElMessage.success('状态更新成功')
}

const handleChangeStatus = (row) => {
  currentRoom.value = row
  newStatus.value = row.status
  statusDialogVisible.value = true
}

const submitStatusChange = async () => {
  submitting.value = true
  try {
    await roomApi.changeStatus(currentRoom.value.id, newStatus.value)
    ElMessage.success('状态更新成功')
    statusDialogVisible.value = false
    fetchRooms()
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  fetchRoomTypes()
  fetchRooms()
})
</script>

<style lang="scss" scoped>
.admin-rooms-page {
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
  
  :deep(.el-select:hover) {
    border-color: var(--primary-color);
  }
  
  :deep(.el-select .el-input__wrapper) {
    background-color: #fff;
  }
  
  :deep(.el-tag) {
    padding: 2px 8px;
    font-size: 12px;
    border-radius: 4px;
    white-space: nowrap;
  }
  
  :deep(.el-table-column[prop="floor"] .cell) {
    padding: 0 10px;
    text-align: center;
  }
  
  :deep(.el-table-column[prop="status"] .cell) {
    padding: 0 10px;
    text-align: center;
  }
}
</style>
