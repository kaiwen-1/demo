<template>
  <div class="not-found-page">
    <div class="content">
      <h1 class="error-code animate__animated animate__bounceIn">404</h1>
      <h2 class="error-title animate__animated animate__fadeInUp">页面未找到</h2>
      <p class="error-desc animate__animated animate__fadeInUp animate__delay-1s">
        抱歉，您访问的页面不存在或已被移除
      </p>
      <router-link to="/" class="btn btn-primary animate__animated animate__fadeInUp animate__delay-1s">
        <el-icon><HomeFilled /></el-icon>
        返回首页
      </router-link>
    </div>
  </div>
</template>

<script setup>
</script>

<style lang="scss" scoped>
.not-found-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  
  .content {
    text-align: center;
    color: #fff;
    
    .error-code {
      font-size: 150px;
      font-weight: bold;
      margin: 0;
      background: linear-gradient(135deg, var(--primary-color), #a855f7);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      line-height: 1;
      
      @media (max-width: 768px) {
        font-size: 100px;
      }
    }
    
    .error-title {
      font-size: 36px;
      margin: 20px 0;
      
      @media (max-width: 768px) {
        font-size: 24px;
      }
    }
    
    .error-desc {
      font-size: 18px;
      color: rgba(255, 255, 255, 0.7);
      margin-bottom: 30px;
    }
    
    .btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 14px 32px;
      font-size: 16px;
    }
  }
}
</style>
