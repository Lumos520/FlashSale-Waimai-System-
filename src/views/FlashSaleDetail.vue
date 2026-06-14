<template>
  <div class="min-h-screen bg-gray-50 pb-12">
    <!-- 顶部返回导航 -->
    <header class="bg-white shadow-sm sticky top-0 z-50">
      <div class="max-w-4xl mx-auto px-4 h-16 flex items-center justify-between">
        <button @click="$router.push('/')" class="text-gray-600 hover:text-primary flex items-center font-bold">
          <i class="fas fa-chevron-left mr-2"></i> 返回首页
        </button>
        <span class="font-bold text-gray-800">限时秒杀专区</span>
        <div class="w-10"></div>
      </div>
    </header>

    <main class="max-w-4xl mx-auto px-4 mt-6">
      <div class="bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-100 grid grid-cols-1 md:grid-cols-2 gap-8 p-6">
        <!-- 左侧商品大图 -->
        <div class="rounded-xl overflow-hidden h-80 bg-gray-100">
          <img :src="item.image" class="w-full h-full object-cover">
        </div>

        <!-- 右侧秒杀面板 -->
        <div class="flex flex-col justify-between">
          <div>
            <!-- 秒杀倒计时 -->
            <div class="bg-red-50 text-red-600 px-4 py-2 rounded-xl flex items-center justify-between mb-4">
              <span class="font-bold text-sm"><i class="fas fa-stopwatch mr-1"></i> 限时秒杀中</span>
              <span class="font-mono text-sm">距结束 01:24:15</span>
            </div>

            <h1 class="text-2xl font-extrabold text-gray-900 mb-2">{{ item.title }}</h1>
            <p class="text-gray-500 text-sm mb-4">{{ item.desc }}</p>

            <!-- 价格块 -->
            <div class="flex items-baseline space-x-3 mb-6">
              <span class="text-3xl font-extrabold text-red-500">¥{{ item.flashPrice }}</span>
              <span class="text-gray-400 line-through text-sm">原价 ¥{{ item.originalPrice }}</span>
              <span class="bg-red-100 text-red-600 text-xs px-2 py-0.5 rounded-full font-bold">
                {{ Math.round((item.flashPrice/item.originalPrice)*100)/10 }}折
              </span>
            </div>

            <!-- 抢购进度条 -->
            <div class="mb-6">
              <div class="flex justify-between text-xs text-gray-500 mb-1">
                <span>已抢 {{ item.soldPercent }}%</span>
                <span>仅剩 {{ item.stock }} 件</span>
              </div>
              <div class="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                <div class="bg-red-500 h-full transition-all" :style="{ width: item.soldPercent + '%' }"></div>
              </div>
            </div>
          </div>

          <!-- 抢购按钮 -->
          <button @click="goToPay" class="w-full bg-red-500 hover:bg-red-600 text-white py-3.5 rounded-xl font-bold text-lg shadow-lg shadow-red-500/20 transition-all flex items-center justify-center space-x-2">
            <i class="fas fa-bolt"></i>
            <span>立即抢购</span>
          </button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const item = ref({
  id: 1,
  title: '大牌香辣鸡腿堡单人餐',
  desc: '含香辣鸡腿堡1个 + 薯条(中)1份 + 可乐(中)1杯，大牌品质，超值秒杀。',
  flashPrice: 9.9,
  originalPrice: 25.0,
  soldPercent: 65,
  stock: 12,
  image: '/images/1.jpg' // 会读取 public/images/1.jpg
})

onMounted(() => {
  // 根据不同的路由 id 加载不同商品（这里用模拟数据）
  const id = route.params.id
  if (id === '2') {
    item.value = {
      id: 2,
      title: '霸王茶姬·伯牙绝弦超值双杯',
      desc: '经典茉莉雪芽茶底，牛乳黄金比例，网红爆款，秒杀立减。',
      flashPrice: 19.9,
      originalPrice: 36.0,
      soldPercent: 88,
      stock: 5,
      image: '/images/1.jpg'
    }
  }
})

const goToPay = () => {
  // 将秒杀商品信息临时存入本地，传给收银台
  localStorage.setItem('checkout_item', JSON.stringify({
    name: item.value.title,
    price: item.value.flashPrice,
    quantity: 1,
    deliveryFee: 0
  }))
  router.push('/checkout')
}
</script>