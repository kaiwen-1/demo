<template>
  <div class="admin-reviews-page">
    <el-card class="table-card">
      <template #header>
        <div class="card-header">
          <span>评论管理</span>
        </div>
      </template>
      
      <el-table :data="reviews" v-loading="loading" stripe>
        <el-table-column label="用户" width="150">
          <template #default="{ row }">
            <div class="user-cell">
              <el-avatar :size="36" :src="row.user_avatar">
                {{ row.username?.charAt(0).toUpperCase() }}
              </el-avatar>
              <span>{{ row.username }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="房型" width="120">
          <template #default="{ row }">
            {{ row.room_type?.name }}
          </template>
        </el-table-column>
        <el-table-column prop="rating" label="评分" width="150">
          <template #default="{ row }">
            <el-rate v-model="row.rating" disabled />
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" width="150" />
        <el-table-column prop="content" label="内容" show-overflow-tooltip />
        <el-table-column prop="is_visible" label="显示状态" width="100">
          <template #default="{ row }">
            <el-switch v-model="row.is_visible" @change="handleStatusChange(row)" />
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.created_at) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
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
          @size-change="fetchReviews"
          @current-change="fetchReviews"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { reviewApi } from '@/api/review'
import { ElMessage, ElMessageBox } from 'element-plus'
import dayjs from 'dayjs'

const loading = ref(false)
const reviews = ref([])

const pagination = reactive({
  page: 1,
  pageSize: 10,
  total: 0,
})

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

const fetchReviews = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
    }
    const res = await reviewApi.getList(params)
    reviews.value = res.results || res
    pagination.total = res.count || reviews.value.length
  } finally {
    loading.value = false
  }
}

const handleStatusChange = async (row) => {
  await reviewApi.updateReview(row.id, { is_visible: row.is_visible })
  ElMessage.success('状态更新成功')
}

const handleDelete = async (row) => {
  await ElMessageBox.confirm('确定要删除该评论吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await reviewApi.deleteReview(row.id)
  ElMessage.success('删除成功')
  fetchReviews()
}

onMounted(() => {
  fetchReviews()
})
</script>

<style lang="scss" scoped>
.admin-reviews-page {
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
    gap: 10px;
  }
  
  .pagination {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
  }
}
</style>
