<template>
  <div class="admin-bookings-page">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="订单状态">
          <el-select v-model="searchForm.status" placeholder="全部状态" clearable>
            <el-option label="待确认" value="pending" />
            <el-option label="已确认" value="confirmed" />
            <el-option label="已入住" value="checked_in" />
            <el-option label="已退房" value="checked_out" />
            <el-option label="已取消" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="入住日期">
          <el-date-picker
            v-model="searchForm.check_in_date"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="搜索">
          <el-input v-model="searchForm.keyword" placeholder="用户名/房间号/联系人" clearable />
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
          <span>预订列表</span>
          <div class="header-actions">
            <el-tag v-for="(count, status) in statusCounts" :key="status" style="margin-left: 10px">
              {{ getStatusLabel(status) }}: {{ count }}
            </el-tag>
          </div>
        </div>
      </template>
      
      <el-table :data="bookings" v-loading="loading" stripe>
        <el-table-column prop="id" label="订单号" width="80" />
        <el-table-column label="用户" width="100">
          <template #default="{ row }">
            {{ row.user?.username }}
          </template>
        </el-table-column>
        <el-table-column label="房间" width="150">
          <template #default="{ row }">
            {{ row.room?.room_number }} - {{ row.room?.room_type?.name }}
          </template>
        </el-table-column>
        <el-table-column label="入住日期" width="120">
          <template #default="{ row }">
            {{ row.check_in_date }}
          </template>
        </el-table-column>
        <el-table-column label="退房日期" width="120">
          <template #default="{ row }">
            {{ row.check_out_date }}
          </template>
        </el-table-column>
        <el-table-column prop="guests" label="人数" width="60">
          <template #default="{ row }">
            {{ row.guests }}人
          </template>
        </el-table-column>
        <el-table-column prop="total_price" label="金额" width="100">
          <template #default="{ row }">
            ¥{{ row.total_price }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="联系人" width="120">
          <template #default="{ row }">
            {{ row.contact_name }}<br />
            <small>{{ row.contact_phone }}</small>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <template v-if="row.status === 'pending'">
              <el-button type="success" text size="small" @click="handleConfirm(row)">确认</el-button>
              <el-button type="danger" text size="small" @click="handleCancel(row)">取消</el-button>
            </template>
            <template v-else-if="row.status === 'confirmed'">
              <el-button type="primary" text size="small" @click="handleCheckIn(row)">办理入住</el-button>
              <el-button type="danger" text size="small" @click="handleCancel(row)">取消</el-button>
            </template>
            <template v-else-if="row.status === 'checked_in'">
              <el-button type="warning" text size="small" @click="handleCheckOut(row)">办理退房</el-button>
            </template>
            <el-button type="info" text size="small" @click="viewDetail(row)">详情</el-button>
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
          @size-change="fetchBookings"
          @current-change="fetchBookings"
        />
      </div>
    </el-card>
    
    <el-dialog v-model="detailVisible" title="预订详情" width="600px">
      <el-descriptions :column="2" border v-if="currentBooking">
        <el-descriptions-item label="订单号">{{ currentBooking.id }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusType(currentBooking.status)">
            {{ getStatusLabel(currentBooking.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="用户">{{ currentBooking.user?.username }}</el-descriptions-item>
        <el-descriptions-item label="房间">{{ currentBooking.room?.room_number }}</el-descriptions-item>
        <el-descriptions-item label="房型">{{ currentBooking.room?.room_type?.name }}</el-descriptions-item>
        <el-descriptions-item label="入住人数">{{ currentBooking.guests }}人</el-descriptions-item>
        <el-descriptions-item label="入住日期">{{ currentBooking.check_in_date }}</el-descriptions-item>
        <el-descriptions-item label="退房日期">{{ currentBooking.check_out_date }}</el-descriptions-item>
        <el-descriptions-item label="订单金额">¥{{ currentBooking.total_price }}</el-descriptions-item>
        <el-descriptions-item label="联系人">{{ currentBooking.contact_name }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentBooking.contact_phone }}</el-descriptions-item>
        <el-descriptions-item label="特殊要求" :span="2">
          {{ currentBooking.special_requests || '无' }}
        </el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">{{ currentBooking.created_at }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { bookingApi } from '@/api/booking'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const bookings = ref([])
const detailVisible = ref(false)
const currentBooking = ref(null)

const searchForm = reactive({
  status: null,
  check_in_date: null,
  keyword: '',
})

const pagination = reactive({
  page: 1,
  pageSize: 10,
  total: 0,
})

const statusCounts = computed(() => {
  const counts = {}
  bookings.value.forEach((b) => {
    counts[b.status] = (counts[b.status] || 0) + 1
  })
  return counts
})

const getStatusType = (status) => {
  const types = {
    pending: 'warning',
    confirmed: 'primary',
    checked_in: 'success',
    checked_out: 'info',
    cancelled: 'danger',
  }
  return types[status] || 'info'
}

const getStatusLabel = (status) => {
  const labels = {
    pending: '待确认',
    confirmed: '已确认',
    checked_in: '已入住',
    checked_out: '已退房',
    cancelled: '已取消',
  }
  return labels[status] || status
}

const fetchBookings = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
      ...searchForm,
    }
    const res = await bookingApi.getList(params)
    bookings.value = res.results || res
    pagination.total = res.count || bookings.value.length
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.page = 1
  fetchBookings()
}

const resetSearch = () => {
  Object.assign(searchForm, {
    status: null,
    check_in_date: null,
    keyword: '',
  })
  handleSearch()
}

const handleConfirm = async (row) => {
  await ElMessageBox.confirm('确定要确认此预订吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'info',
  })
  
  await bookingApi.confirm(row.id)
  ElMessage.success('确认成功')
  fetchBookings()
}

const handleCancel = async (row) => {
  await ElMessageBox.confirm('确定要取消此预订吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await bookingApi.cancel(row.id)
  ElMessage.success('取消成功')
  fetchBookings()
}

const handleCheckIn = async (row) => {
  await ElMessageBox.confirm('确定要办理入住吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'info',
  })
  
  await bookingApi.checkIn(row.id)
  ElMessage.success('入住成功')
  fetchBookings()
}

const handleCheckOut = async (row) => {
  await ElMessageBox.confirm('确定要办理退房吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'info',
  })
  
  await bookingApi.checkOut(row.id)
  ElMessage.success('退房成功')
  fetchBookings()
}

const viewDetail = (row) => {
  currentBooking.value = row
  detailVisible.value = true
}

onMounted(() => {
  fetchBookings()
})
</script>

<style lang="scss" scoped>
.admin-bookings-page {
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
  
  :deep(.el-tag) {
    padding: 2px 8px;
    font-size: 12px;
    border-radius: 4px;
    white-space: nowrap;
  }
  
  :deep(.el-table-column[prop="status"] .cell) {
    padding: 0 10px;
    text-align: center;
  }
}
</style>
