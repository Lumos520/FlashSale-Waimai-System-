<template>
  <div class="flex h-screen bg-slate-100 overflow-hidden">
    <!-- 侧边栏 -->
    <aside class="w-64 bg-indigo-900 text-white flex flex-col">
      <div class="h-16 flex items-center px-6 border-b border-indigo-800">
        <i class="fas fa-shield-alt text-purple-400 text-xl mr-3"></i>
        <span class="text-lg font-bold tracking-wider">平台总后台</span>
      </div>
      <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
        <a href="#" class="flex items-center px-4 py-3 bg-purple-600 rounded-xl text-white font-medium shadow-lg shadow-purple-500/20">
          <i class="fas fa-tachometer-alt w-6"></i> 平台大盘
        </a>
        <a href="#" class="flex items-center px-4 py-3 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-xl font-medium transition">
          <i class="fas fa-store w-6"></i> 商家管理
        </a>
        <a href="#" class="flex items-center px-4 py-3 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-xl font-medium transition">
          <i class="fas fa-users w-6"></i> 用户管理
        </a>
        <a href="#" class="flex items-center px-4 py-3 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-xl font-medium transition">
          <i class="fas fa-server w-6"></i> 系统配置
        </a>
      </nav>
      <div class="p-4 border-t border-indigo-800">
        <button @click="logout" class="w-full flex items-center px-4 py-2 text-sm text-indigo-300 hover:text-white hover:bg-indigo-800 rounded-lg transition">
          <i class="fas fa-sign-out-alt w-6"></i> 退出登录
        </button>
      </div>
    </aside>

    <!-- 主内容区 -->
    <main class="flex-1 flex flex-col h-screen overflow-hidden relative">
      <header class="h-16 bg-white shadow-sm flex items-center justify-between px-8 z-10">
        <h1 class="text-xl font-bold text-slate-800">平台数据中心</h1>
        <div class="flex items-center space-x-2">
          <img src="https://ui-avatars.com/api/?name=Admin&background=8b5cf6&color=fff" class="w-8 h-8 rounded-full">
          <span class="text-sm font-bold text-slate-700">超级管理员</span>
        </div>
      </header>

      <div class="flex-1 overflow-y-auto p-8">
        <!-- 平台级数据大屏卡片 -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div class="bg-gradient-to-br from-purple-600 to-indigo-700 rounded-2xl p-6 shadow-lg text-white">
            <p class="text-white/80 font-medium mb-2">平台总交易额 (GMV)</p>
            <h3 class="text-3xl font-black">¥ 892,400.50</h3>
            <p class="text-sm mt-4"><i class="fas fa-arrow-up text-green-300"></i> 较昨日 +12.5%</p>
          </div>
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100">
            <p class="text-sm text-slate-500 font-medium mb-2">入驻商家总数</p>
            <h3 class="text-3xl font-black text-slate-800">1,208</h3>
            <p class="text-sm mt-4 text-slate-400"><span class="text-green-500">+12</span> 今日新增</p>
          </div>
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100">
            <p class="text-sm text-slate-500 font-medium mb-2">注册用户总数</p>
            <h3 class="text-3xl font-black text-slate-800">45,902</h3>
            <p class="text-sm mt-4 text-slate-400"><span class="text-green-500">+340</span> 今日新增</p>
          </div>
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100">
            <p class="text-sm text-slate-500 font-medium mb-2">活跃状态异常</p>
            <h3 class="text-3xl font-black text-red-500">3</h3>
            <p class="text-sm mt-4 text-slate-400">需立即处理的投诉/退款</p>
          </div>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-6 h-96 flex flex-col items-center justify-center text-slate-400">
           <i class="fas fa-chart-area text-6xl mb-4 text-slate-200"></i>
           <p>图表区域占位 (后续可接入 ECharts 显示趋势图)</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()
const logout = () => {
  localStorage.removeItem('system_role')
  router.push('/admin-login')
}
</script>