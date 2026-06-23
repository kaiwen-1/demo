<template>
  <div class="system-page">
    <el-tabs v-model="activeTab">
      <el-tab-pane label="系统信息" name="info">
        <SystemInfo />
      </el-tab-pane>
      <el-tab-pane label="参数配置" name="config">
        <SystemConfig />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import SystemInfo from './system/SystemInfo.vue'
import SystemConfig from './system/SystemConfig.vue'

const activeTab = ref('info')
</script>

<style lang="scss" scoped>
.system-page {
  :deep(.el-tabs__header) {
    margin-bottom: 20px;
  }
}
</style>
