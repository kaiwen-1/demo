<template>
  <div class="coupons-component">
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        添加优惠券
      </el-button>
    </div>
    
    <el-table :data="coupons" v-loading="loading" stripe>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="code" label="优惠券码" width="150" />
      <el-table-column prop="name" label="名称" />
      <el-table-column label="类型" width="100">
        <template #default="{ row }">
          <el-tag :type="row.coupon_type === 'fixed' ? 'success' : 'warning'">
            {{ row.coupon_type_display }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="discount_value" label="优惠值" width="100" />
      <el-table-column prop="min_amount" label="最低消费" width="100" />
      <el-table-column label="剩余/总数" width="120">
        <template #default="{ row }">
          {{ row.remaining_count }} / {{ row.total_count }}
        </template>
      </el-table-column>
      <el-table-column label="有效期" width="200">
        <template #default="{ row }">
          {{ formatDate(row.start_time) }} 至 {{ formatDate(row.end_time) }}
        </template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.is_active ? 'success' : 'danger'">
            {{ row.is_active ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" text @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" text @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-dialog v-model="dialogVisible" :title="editingCoupon ? '编辑优惠券' : '添加优惠券'" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="优惠券码" prop="code">
          <el-input v-model="form.code" placeholder="请输入优惠券码">
            <template #append>
              <el-button @click="generateCode">随机生成</el-button>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入优惠券名称" />
        </el-form-item>
        <el-form-item label="类型" prop="coupon_type">
          <el-select v-model="form.coupon_type">
            <el-option label="固定金额" value="fixed" />
            <el-option label="百分比折扣" value="percentage" />
          </el-select>
        </el-form-item>
        <el-form-item label="优惠值" prop="discount_value">
          <el-input-number v-model="form.discount_value" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="最低消费" prop="min_amount">
          <el-input-number v-model="form.min_amount" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item v-if="form.coupon_type === 'percentage'" label="最大优惠" prop="max_discount">
          <el-input-number v-model="form.max_discount" :min="0" :precision="2" placeholder="不限" />
        </el-form-item>
        <el-form-item label="发放总数" prop="total_count">
          <el-input-number v-model="form.total_count" :min="1" />
        </el-form-item>
        <el-form-item label="每人限领" prop="per_user_limit">
          <el-input-number v-model="form.per_user_limit" :min="1" />
        </el-form-item>
        <el-form-item label="有效期" prop="timeRange">
          <el-date-picker
            v-model="timeRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
        </el-form-item>
        <el-form-item label="状态" prop="is_active">
          <el-switch v-model="form.is_active" />
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
const coupons = ref([])
const dialogVisible = ref(false)
const editingCoupon = ref(null)
const formRef = ref(null)
const timeRange = ref([])

const form = reactive({
  code: '',
  name: '',
  coupon_type: 'fixed',
  discount_value: 10,
  min_amount: 0,
  max_discount: null,
  total_count: 100,
  per_user_limit: 1,
  is_active: true,
})

const rules = {
  code: [{ required: true, message: '请输入优惠券码', trigger: 'blur' }],
  name: [{ required: true, message: '请输入优惠券名称', trigger: 'blur' }],
  discount_value: [{ required: true, message: '请输入优惠值', trigger: 'blur' }],
  total_count: [{ required: true, message: '请输入发放总数', trigger: 'blur' }],
}

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

const generateCode = () => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  let code = ''
  for (let i = 0; i < 8; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  form.code = code
}

const fetchCoupons = async () => {
  loading.value = true
  try {
    const res = await operationApi.getCoupons()
    coupons.value = res.results || res
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  form.code = ''
  form.name = ''
  form.coupon_type = 'fixed'
  form.discount_value = 10
  form.min_amount = 0
  form.max_discount = null
  form.total_count = 100
  form.per_user_limit = 1
  form.is_active = true
  timeRange.value = []
  editingCoupon.value = null
}

const handleAdd = () => {
  resetForm()
  generateCode()
  dialogVisible.value = true
}

const handleEdit = (coupon) => {
  editingCoupon.value = coupon
  form.code = coupon.code
  form.name = coupon.name
  form.coupon_type = coupon.coupon_type
  form.discount_value = coupon.discount_value
  form.min_amount = coupon.min_amount
  form.max_discount = coupon.max_discount
  form.total_count = coupon.total_count
  form.per_user_limit = coupon.per_user_limit
  form.is_active = coupon.is_active
  if (coupon.start_time && coupon.end_time) {
    timeRange.value = [coupon.start_time, coupon.end_time]
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
      if (editingCoupon.value) {
        await operationApi.updateCoupon(editingCoupon.value.id, data)
        ElMessage.success('更新成功')
      } else {
        await operationApi.createCoupon(data)
        ElMessage.success('添加成功')
      }
      dialogVisible.value = false
      fetchCoupons()
    } finally {
      saving.value = false
    }
  })
}

const handleDelete = async (coupon) => {
  await ElMessageBox.confirm('确定要删除该优惠券吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
  
  await operationApi.deleteCoupon(coupon.id)
  ElMessage.success('删除成功')
  fetchCoupons()
}

onMounted(() => {
  fetchCoupons()
})
</script>

<style lang="scss" scoped>
.coupons-component {
  .toolbar {
    margin-bottom: 20px;
  }
}
</style>
