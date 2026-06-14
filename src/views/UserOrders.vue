<template>
  <div class="min-h-screen bg-gray-50 pb-12">
    <!-- 顶部导航 -->
    <header class="bg-white shadow-sm sticky top-0 z-50">
      <div class="max-w-3xl mx-auto px-4 h-16 flex items-center justify-between">
        <button @click="$router.push('/')" class="text-gray-600 hover:text-primary font-bold transition">
          <i class="fas fa-chevron-left mr-2"></i> 返回首页
        </button>
        <span class="font-bold text-lg text-gray-900">我的订单</span>
        <div class="w-20"></div> <!-- 占位保持居中 -->
      </div>
    </header>

    <main class="max-w-3xl mx-auto px-4 mt-6">
      <div v-if="orders.length === 0" class="text-center py-24 bg-white rounded-3xl shadow-sm border border-gray-100">
        <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4 text-gray-400 text-4xl">
          <i class="fas fa-file-invoice"></i>
        </div>
        <h3 class="text-lg font-bold text-gray-800 mb-2">暂无订单记录</h3>
        <p class="text-sm text-gray-400 mb-6">您还没有下过单，快去逛逛吧~</p>
        <button @click="$router.push('/')" class="bg-primary hover:bg-orange-600 text-white font-bold px-8 py-3 rounded-full shadow-lg shadow-orange-500/30 transition">
          去点餐
        </button>
      </div>

      <div v-else class="space-y-4">
        <!-- 订单卡片 -->
        <div v-for="order in orders" :key="order.id" class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition">
          <!-- 头部：店铺与状态 -->
          <div class="flex justify-between items-center border-b border-gray-50 pb-4 mb-4">
            <div class="font-bold text-gray-800 flex items-center text-lg">
              <i class="fas fa-store mr-2 text-primary"></i> 闪购自营商家
              <i class="fas fa-chevron-right text-gray-300 text-sm ml-2"></i>
            </div>
            <div :class="statusConfig(order.status).color" class="font-extrabold text-sm">
              {{ statusConfig(order.status).text }}
            </div>
          </div>

          <!-- 内容：商品与价格 -->
          <div class="flex justify-between items-center mb-6">
            <div class="flex items-center space-x-4">
              <div class="w-16 h-16 bg-gray-100 rounded-xl flex items-center justify-center text-gray-400 text-2xl">
                <i class="fas fa-shopping-bag"></i>
              </div>
              <div>
                <p class="font-bold text-gray-900 text-lg">{{ order.name }}</p>
                <p class="text-xs text-gray-400 mt-1">订单号：{{ order.id }}</p>
                <p class="text-xs text-gray-400 mt-0.5">下单时间：{{ order.time }}</p>
              </div>
            </div>
            <div class="font-black text-2xl text-gray-900">
              <span class="text-sm">¥</span>{{ order.totalPrice.toFixed(2) }}
            </div>
          </div>

          <!-- 🌟 亮点：动态进度条 (仅在未取消的订单上显示) -->
          <div v-if="order.status !== 'cancelled'" class="mb-4">
            <div class="flex justify-between text-xs font-bold text-gray-400 mb-2 px-1">
              <span :class="order.status === 'pending' ? 'text-primary' : 'text-gray-800'">等待接单</span>
              <span :class="order.status === 'accepted' ? 'text-blue-500' : (order.status === 'ready' ? 'text-gray-800' : '')">商家制作中</span>
              <span :class="order.status === 'ready' ? 'text-green-500' : ''">已出餐/待取</span>
            </div>
            <div class="w-full bg-gray-100 rounded-full h-2.5 overflow-hidden">
              <div class="h-full transition-all duration-700 ease-out" 
                   :class="statusConfig(order.status).barColor" 
                   :style="{ width: statusConfig(order.status).progress + '%' }">
              </div>
            </div>
          </div>

          <!-- 底部：操作按钮 -->
          <div class="flex justify-end space-x-3 pt-2">
            <button class="px-4 py-2 border border-gray-200 rounded-lg text-sm font-bold text-gray-600 hover:bg-gray-50 transition">联系商家</button>
            <button @click="$router.push('/')" class="px-4 py-2 bg-primary text-white rounded-lg text-sm font-bold hover:bg-orange-600 transition shadow-md shadow-orange-500/20">
              再来一单
            </button>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const orders = ref([])
let timer = null

// 状态字典映射 (配置文字、颜色和进度条)
const statusConfig = (status) => {
  const config = {
    'pending':   { text: '等待商家接单', color: 'text-primary',   barColor: 'bg-primary',   progress: 15 },
    'accepted':  { text: '商家正在制作', color: 'text-blue-500',  barColor: 'bg-blue-500',  progress: 60 },
    'ready':     { text: '已出餐 / 待取', color: 'text-green-500', barColor: 'bg-green-500', progress: 100 },
    'cancelled': { text: '订单已取消',   color: 'text-gray-400',  barColor: '',             progress: 0 }
  }
  return config[status] || config['pending']
}

// 也是用雷达探测！每隔一小段时间去本地缓存读取最新状态
const fetchOrders = () => {
  const saved = localStorage.getItem('merchant_orders')
  if (saved) {
    orders.value = JSON.parse(saved)
  }
}

onMounted(() => {
  fetchOrders()
  // 每隔 1.5 秒更新一次页面，这样商家点接单，用户手机立马变
  timer = setInterval(fetchOrders, 1500)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>