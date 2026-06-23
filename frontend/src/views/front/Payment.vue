<template>
  <div class="payment-page">
    <div class="page-header">
      <h1>订单支付</h1>
      <p>请选择支付方式完成支付</p>
    </div>
    
    <div class="payment-container" v-loading="loading">
      <div class="order-info">
        <h3>订单信息</h3>
        <div class="info-item">
          <span class="label">订单号</span>
          <span class="value">{{ payment?.payment_no }}</span>
        </div>
        <div class="info-item">
          <span class="label">房型</span>
          <span class="value">{{ payment?.booking_info?.room_type }}</span>
        </div>
        <div class="info-item">
          <span class="label">房间号</span>
          <span class="value">{{ payment?.booking_info?.room_number }}</span>
        </div>
        <div class="info-item">
          <span class="label">入住日期</span>
          <span class="value">{{ payment?.booking_info?.check_in_date }}</span>
        </div>
        <div class="info-item">
          <span class="label">退房日期</span>
          <span class="value">{{ payment?.booking_info?.check_out_date }}</span>
        </div>
        <div class="info-item total">
          <span class="label">支付金额</span>
          <span class="value">¥{{ payment?.amount }}</span>
        </div>
      </div>
      
      <div class="payment-methods">
        <h3>选择支付方式</h3>
        <div class="method-list">
          <div 
            class="method-item" 
            :class="{ active: selectedMethod === 'alipay' }"
            @click="selectedMethod = 'alipay'"
          >
            <div class="method-icon alipay">
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M21.422 15.358c-3.83-1.153-6.055-1.84-7.373-2.322.632-1.327 1.076-2.879 1.33-4.65h-3.49v-1.58h4.44V5.39h-4.44V3h-2.22v2.39H5.39v1.416h4.28v1.58H6.05v1.416h7.05c-.21 1.19-.548 2.262-1.005 3.213-1.897-.468-3.664-.728-5.295-.728-2.866 0-4.3 1.094-4.3 2.866 0 1.695 1.392 2.866 4.05 2.866 2.042 0 3.918-.684 5.628-2.052 2.328 1.012 5.556 2.172 9.684 3.474l.06-.018v-1.583zm-14.65.186c-1.56 0-2.34-.438-2.34-1.248 0-.858.858-1.296 2.574-1.296 1.356 0 2.838.21 4.446.636-1.248 1.26-2.67 1.908-4.68 1.908z"/>
              </svg>
            </div>
            <span>支付宝</span>
            <div class="check-icon" v-if="selectedMethod === 'alipay'">
              <el-icon><Check /></el-icon>
            </div>
          </div>
          
          <div 
            class="method-item" 
            :class="{ active: selectedMethod === 'wechat' }"
            @click="selectedMethod = 'wechat'"
          >
            <div class="method-icon wechat">
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M8.691 2.188C3.891 2.188 0 5.476 0 9.53c0 2.212 1.17 4.203 3.002 5.55a.59.59 0 0 1 .213.665l-.39 1.48c-.019.07-.048.141-.048.213 0 .163.13.295.29.295a.326.326 0 0 0 .167-.054l1.903-1.114a.864.864 0 0 1 .717-.098 10.16 10.16 0 0 0 2.837.403c.276 0 .543-.027.811-.05-.857-2.578.157-4.972 1.932-6.446 1.703-1.415 3.882-1.98 5.853-1.838-.576-3.583-4.196-6.348-8.596-6.348zM5.785 5.991c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178A1.17 1.17 0 0 1 4.623 7.17c0-.651.52-1.18 1.162-1.18zm5.813 0c.642 0 1.162.529 1.162 1.18a1.17 1.17 0 0 1-1.162 1.178 1.17 1.17 0 0 1-1.162-1.178c0-.651.52-1.18 1.162-1.18zm5.34 2.867c-1.797-.052-3.746.512-5.28 1.786-1.72 1.428-2.687 3.72-1.78 6.22.942 2.453 3.666 4.229 6.884 4.229.826 0 1.622-.12 2.361-.336a.722.722 0 0 1 .598.082l1.584.926a.272.272 0 0 0 .14.047c.134 0 .24-.111.24-.247 0-.06-.023-.12-.038-.177l-.327-1.233a.582.582 0 0 1-.023-.156.49.49 0 0 1 .201-.398C23.024 18.48 24 16.82 24 14.98c0-3.21-2.931-5.837-6.656-6.088V8.89c-.135-.01-.27-.027-.407-.03zm-2.53 3.274c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.97-.982zm4.844 0c.535 0 .969.44.969.982a.976.976 0 0 1-.969.983.976.976 0 0 1-.969-.983c0-.542.434-.982.969-.982z"/>
              </svg>
            </div>
            <span>微信支付</span>
            <div class="check-icon" v-if="selectedMethod === 'wechat'">
              <el-icon><Check /></el-icon>
            </div>
          </div>
          
          <div 
            class="method-item" 
            :class="{ active: selectedMethod === 'bank_card' }"
            @click="selectedMethod = 'bank_card'"
          >
            <div class="method-icon bank-card">
              <el-icon :size="28"><CreditCard /></el-icon>
            </div>
            <span>银行卡支付</span>
            <div class="check-icon" v-if="selectedMethod === 'bank_card'">
              <el-icon><Check /></el-icon>
            </div>
          </div>
        </div>
      </div>
      
      <div class="payment-actions">
        <el-button 
          type="primary" 
          size="large" 
          :loading="paying" 
          @click="handlePay"
          class="pay-btn"
        >
          立即支付 ¥{{ payment?.amount }}
        </el-button>
        <el-button size="large" @click="handleCancel" :disabled="paying">
          取消支付
        </el-button>
      </div>
    </div>
    
    <el-dialog 
      v-model="showPayDialog" 
      title="模拟支付" 
      width="400px"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
    >
      <div class="pay-dialog-content">
        <div class="qr-code-placeholder">
          <el-icon :size="80"><Promotion /></el-icon>
          <p>模拟支付二维码</p>
          <p class="amount">¥{{ payment?.amount }}</p>
        </div>
        <el-progress :percentage="payProgress" :show-text="false" />
        <p class="progress-text">支付处理中... {{ payProgress }}%</p>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { paymentApi } from '@/api/payment'
import { ElMessage, ElMessageBox } from 'element-plus'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const paying = ref(false)
const payment = ref(null)
const selectedMethod = ref('alipay')
const showPayDialog = ref(false)
const payProgress = ref(0)

const fetchPayment = async () => {
  loading.value = true
  try {
    const res = await paymentApi.getPayment(route.params.id)
    payment.value = res
    
    if (res.status !== 'pending') {
      if (res.status === 'success') {
        ElMessage.success('该订单已支付成功')
        router.push('/user/bookings')
      } else {
        ElMessage.warning('该订单已取消或已退款')
        router.push('/user/bookings')
      }
    }
  } catch (error) {
    ElMessage.error('获取支付信息失败')
    router.push('/user/bookings')
  } finally {
    loading.value = false
  }
}

const handlePay = async () => {
  try {
    await ElMessageBox.confirm(
      `确认使用${getPaymentMethodName(selectedMethod.value)}支付 ¥${payment.value.amount}？`,
      '确认支付',
      {
        confirmButtonText: '确认支付',
        cancelButtonText: '取消',
        type: 'info',
      }
    )
    
    paying.value = true
    showPayDialog.value = true
    payProgress.value = 0
    
    const progressInterval = setInterval(() => {
      if (payProgress.value < 90) {
        payProgress.value += 10
      }
    }, 200)
    
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    clearInterval(progressInterval)
    
    const res = await paymentApi.pay(payment.value.id)
    
    payProgress.value = 100
    
    await new Promise(resolve => setTimeout(resolve, 500))
    
    showPayDialog.value = false
    paying.value = false
    
    ElMessage.success('支付成功！预订已确认')
    router.push('/user/bookings')
    
  } catch (error) {
    if (error !== 'cancel') {
      showPayDialog.value = false
      paying.value = false
      payProgress.value = 0
      ElMessage.error('支付失败，请重试')
    }
  }
}

const handleCancel = async () => {
  try {
    await ElMessageBox.confirm(
      '确定要取消支付吗？取消后预订将被取消。',
      '取消支付',
      {
        confirmButtonText: '确定取消',
        cancelButtonText: '继续支付',
        type: 'warning',
      }
    )
    
    await paymentApi.cancel(payment.value.id)
    ElMessage.info('支付已取消')
    router.push('/user/bookings')
    
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('操作失败')
    }
  }
}

const getPaymentMethodName = (method) => {
  const names = {
    alipay: '支付宝',
    wechat: '微信支付',
    bank_card: '银行卡支付'
  }
  return names[method] || method
}

onMounted(() => {
  fetchPayment()
})
</script>

<style lang="scss" scoped>
.payment-page {
  min-height: 100vh;
  background: #f5f7fa;
  
  .page-header {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
    padding: 50px 20px;
    text-align: center;
    color: #fff;
    
    h1 {
      font-size: 36px;
      margin-bottom: 10px;
      background: linear-gradient(135deg, var(--primary-color), #a855f7);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    p {
      color: rgba(255, 255, 255, 0.8);
    }
  }
  
  .payment-container {
    max-width: 600px;
    margin: -30px auto 40px;
    padding: 0 20px;
    position: relative;
    z-index: 1;
  }
  
  .order-info {
    background: #fff;
    border-radius: 16px;
    padding: 25px;
    margin-bottom: 20px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    
    h3 {
      font-size: 18px;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 2px solid var(--primary-color);
    }
    
    .info-item {
      display: flex;
      justify-content: space-between;
      padding: 12px 0;
      border-bottom: 1px solid #f0f0f0;
      
      &:last-child {
        border-bottom: none;
      }
      
      .label {
        color: var(--text-secondary);
      }
      
      .value {
        font-weight: 500;
      }
      
      &.total {
        margin-top: 10px;
        padding-top: 20px;
        border-top: 2px dashed #e0e0e0;
        border-bottom: none;
        
        .value {
          font-size: 24px;
          font-weight: bold;
          color: var(--primary-color);
        }
      }
    }
  }
  
  .payment-methods {
    background: #fff;
    border-radius: 16px;
    padding: 25px;
    margin-bottom: 20px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    
    h3 {
      font-size: 18px;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 2px solid var(--primary-color);
    }
    
    .method-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    
    .method-item {
      display: flex;
      align-items: center;
      padding: 16px;
      border: 2px solid #e8e8e8;
      border-radius: 12px;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        border-color: var(--primary-color);
        background: rgba(64, 158, 255, 0.05);
      }
      
      &.active {
        border-color: var(--primary-color);
        background: rgba(64, 158, 255, 0.1);
      }
      
      .method-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16px;
        color: #fff;
        
        &.alipay {
          background: linear-gradient(135deg, #1677ff, #40a9ff);
        }
        
        &.wechat {
          background: linear-gradient(135deg, #07c160, #2aae67);
        }
        
        &.bank-card {
          background: linear-gradient(135deg, #722ed1, #9254de);
        }
        
        svg {
          width: 28px;
          height: 28px;
        }
      }
      
      span {
        flex: 1;
        font-size: 16px;
        font-weight: 500;
      }
      
      .check-icon {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        background: var(--primary-color);
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
      }
    }
  }
  
  .payment-actions {
    background: #fff;
    border-radius: 16px;
    padding: 25px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    
    .pay-btn {
      width: 100%;
      height: 50px;
      font-size: 18px;
      margin-bottom: 12px;
    }
  }
}

.pay-dialog-content {
  text-align: center;
  padding: 20px 0;
  
  .qr-code-placeholder {
    margin-bottom: 30px;
    
    .el-icon {
      color: var(--primary-color);
    }
    
    p {
      margin-top: 10px;
      color: var(--text-secondary);
      
      &.amount {
        font-size: 24px;
        font-weight: bold;
        color: var(--primary-color);
      }
    }
  }
  
  .progress-text {
    margin-top: 15px;
    color: var(--text-secondary);
  }
}
</style>
