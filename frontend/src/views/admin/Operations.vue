<template>
  <div class="operations-page">
    <el-tabs v-model="activeTab">
      <el-tab-pane label="促销活动" name="promotions">
        <Promotions />
      </el-tab-pane>
      <el-tab-pane label="优惠券管理" name="coupons">
        <Coupons />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import Promotions from './operations/Promotions.vue'
import Coupons from './operations/Coupons.vue'

const activeTab = ref('promotions')
</script>

<style lang="scss" scoped>
.operations-page {
  :deep(.el-tabs__header) {
    margin-bottom: 20px;
  }
}
</style>
