<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4">
    <div class="max-w-md w-full bg-white p-8 rounded-3xl shadow-xl border border-gray-100 relative">
      <h2 class="text-2xl font-black text-center mb-6 text-gray-900">闪购收银台</h2>
      
      <!-- 订单信息卡片 -->
      <div class="bg-gray-50 rounded-2xl p-5 mb-6 border border-gray-100">
        <span class="text-xs text-gray-400 block mb-1">支付内容</span>
        <h4 class="font-extrabold text-gray-800 text-lg mb-3 truncate">{{ order.name }}</h4>
        <div class="flex justify-between text-sm text-gray-500 mb-1">
          <span>商品金额</span>
          <span>¥{{ order.price.toFixed(1) }}</span>
        </div>
        <div class="flex justify-between text-sm text-gray-500 pb-3 border-b border-gray-200">
          <span>配送费</span>
          <span>¥{{ order.deliveryFee }}</span>
        </div>
        <div class="flex justify-between items-baseline pt-3">
          <span class="font-bold text-gray-800">应付总额</span>
          <span class="text-2xl font-black text-primary">¥{{ (order.price + order.deliveryFee).toFixed(1) }}</span>
        </div>
      </div>

      <!-- 支付方式选择 -->
      <h5 class="text-sm font-bold text-gray-500 mb-3">选择支付方式</h5>
      <div class="space-y-3 mb-8">
        <label 
          v-for="method in payMethods" 
          :key="method.id"
          class="flex items-center justify-between p-4 border rounded-2xl cursor-pointer hover:border-primary transition"
          :class="payMethod === method.id ? 'border-primary bg-orange-50/20' : 'border-gray-100'"
          @click="payMethod = method.id"
        >
          <div class="flex items-center space-x-3">
            <i :class="[method.icon, method.color, 'text-xl']"></i>
            <span class="font-bold text-sm text-gray-800">{{ method.name }}</span>
          </div>
          <input type="radio" :checked="payMethod === method.id" class="accent-primary w-4 h-4">
        </label>
      </div>

      <!-- 立即支付按钮 -->
      <button 
        @click="handlePay"
        :disabled="isPaying"
        class="w-full bg-primary text-white py-3.5 rounded-2xl font-bold text-lg shadow-lg hover:bg-orange-600 transition disabled:opacity-50"
      >
        <span v-if="!isPaying">确认支付</span>
        <span v-else><i class="fas fa-spinner fa-spin mr-2"></i>正在创建安全支付...</span>
      </button>

      <!-- 优雅的支付成功模态弹窗 -->
      <div v-if="showSuccessModal" class="absolute inset-0 bg-white rounded-3xl p-8 flex flex-col items-center justify-center text-center z-50">
        <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center text-green-500 text-3xl mb-4 animate-bounce">
          <i class="fas fa-check"></i>
        </div>
        <h3 class="text-2xl font-black text-gray-900 mb-2">支付成功</h3>
        <p class="text-gray-500 text-sm mb-6">商家已收到您的订单，厨房正在加急备餐中！</p>
        <button @click="$router.push('/')" class="bg-primary text-white font-bold px-8 py-2.5 rounded-full hover:bg-orange-600 transition">
          返回首页
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const payMethod = ref('wx')
const isPaying = ref(false)
const showSuccessModal = ref(false)

const order = ref({
  name: '闪购外卖超值组合餐',
  price: 0,
  quantity: 1,
  deliveryFee: 4
})

const payMethods = [
  { id: 'wx', name: '微信支付', icon: 'fab fa-weixin', color: 'text-green-500' },
  { id: 'alipay', name: '支付宝', icon: 'fab fa-alipay', color: 'text-blue-500' }
]

onMounted(() => {
  const raw = localStorage.getItem('checkout_item')
  if (raw) {
    order.value = JSON.parse(raw)
  }
})

const handlePay = () => {
  isPaying.value = true
  
  // 模拟 1.5 秒的网络请求延迟
  setTimeout(() => {
    isPaying.value = false
    showSuccessModal.value = true
    
    // 🌟 核心逻辑：支付成功后，生成真实订单存入本地！
    const savedOrders = JSON.parse(localStorage.getItem('merchant_orders') || '[]')
    const newOrder = {
      id: 'OD' + Date.now().toString().slice(-6), // 生成类似 OD123456 的订单号
      name: order.value.name,
      totalPrice: order.value.price + order.value.deliveryFee,
      time: new Date().toLocaleTimeString('zh-CN', { hour12: false }), // 当前时间
      status: 'pending' // 状态标记为：pending(待接单)
    }
    
    // 把新订单插到数组最前面，并存入 LocalStorage
    savedOrders.unshift(newOrder)
    localStorage.setItem('merchant_orders', JSON.stringify(savedOrders))

    // 清除购物车缓存
    localStorage.removeItem('checkout_item')
  }, 1500)
}
</script>