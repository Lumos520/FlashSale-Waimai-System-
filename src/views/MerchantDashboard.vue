<template>
  <div class="flex h-screen bg-slate-50 overflow-hidden">
    <!-- 侧边栏 -->
    <aside class="w-64 bg-slate-900 text-white flex flex-col transition-all">
      <div class="h-16 flex items-center px-6 border-b border-slate-800">
        <i class="fas fa-store text-blue-500 text-xl mr-3"></i>
        <span class="text-lg font-bold tracking-wider">商家工作台</span>
      </div>
      <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
        <button @click="currentTab = 'dashboard'" :class="['w-full flex items-center px-4 py-3 rounded-xl font-medium transition', currentTab === 'dashboard' ? 'bg-blue-600 text-white shadow-lg shadow-blue-500/20' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
          <i class="fas fa-chart-line w-6"></i> 经营数据
        </button>
        <!-- 🌟 订单管理 Tab (带新订单红点提示) -->
        <button @click="currentTab = 'orders'" :class="['w-full flex items-center px-4 py-3 rounded-xl font-medium transition', currentTab === 'orders' ? 'bg-blue-600 text-white shadow-lg shadow-blue-500/20' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
          <i class="fas fa-clipboard-list w-6"></i> 订单管理
          <span v-if="pendingOrders.length > 0" class="ml-auto bg-red-500 text-white text-[10px] w-5 h-5 flex items-center justify-center rounded-full font-bold">{{ pendingOrders.length }}</span>
        </button>
        <button @click="currentTab = 'dishes'" :class="['w-full flex items-center px-4 py-3 rounded-xl font-medium transition', currentTab === 'dishes' ? 'bg-blue-600 text-white shadow-lg shadow-blue-500/20' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
          <i class="fas fa-hamburger w-6"></i> 菜品管理
        </button>
      </nav>
      <div class="p-4 border-t border-slate-800">
        <button @click="logout" class="w-full flex items-center px-4 py-2 text-sm text-slate-400 hover:text-white hover:bg-slate-800 rounded-lg transition">
          <i class="fas fa-sign-out-alt w-6"></i> 退出登录
        </button>
      </div>
    </aside>

    <!-- 主内容区 -->
    <main class="flex-1 flex flex-col h-screen overflow-hidden relative">
      <header class="h-16 bg-white shadow-sm flex items-center justify-between px-8 z-10">
        <h1 class="text-xl font-bold text-slate-800">
          {{ currentTab === 'dashboard' ? '数据概览' : (currentTab === 'orders' ? '订单管理' : '菜品管理') }}
        </h1>
        <div class="flex items-center space-x-2 border-l pl-4">
          <img src="https://ui-avatars.com/api/?name=Shop&background=3b82f6&color=fff" class="w-8 h-8 rounded-full">
          <span class="text-sm font-bold text-slate-700">苍穹烧烤 (高新店)</span>
        </div>
      </header>

      <!-- 滚动内容区 -->
      <div class="flex-1 overflow-y-auto p-8">
        
        <!-- Tab 1: 数据概览 -->
        <div v-if="currentTab === 'dashboard'">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100 flex items-center space-x-4">
              <div class="w-14 h-14 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center text-2xl"><i class="fas fa-wallet"></i></div>
              <div>
                <p class="text-sm text-slate-500 font-medium mb-1">今日营业额 (元)</p>
                <h3 class="text-2xl font-black text-slate-800">{{ totalRevenue.toFixed(2) }}</h3>
              </div>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100 flex items-center space-x-4">
              <div class="w-14 h-14 bg-green-50 text-green-600 rounded-2xl flex items-center justify-center text-2xl"><i class="fas fa-receipt"></i></div>
              <div>
                <p class="text-sm text-slate-500 font-medium mb-1">今日有效订单</p>
                <!-- 更新为有效订单数 -->
                <h3 class="text-2xl font-black text-slate-800">{{ validOrdersCount }}</h3>
              </div>
            </div>
          </div>

          <!-- 🌟 最新实时订单 -->
          <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-6">
            <h3 class="text-lg font-bold text-slate-800 mb-6 flex items-center">
              最新实时订单 
              <span v-if="pendingOrders.length > 0" class="ml-2 bg-red-500 text-white text-xs px-2 py-0.5 rounded-full animate-pulse">您有 {{ pendingOrders.length }} 笔新订单待处理</span>
            </h3>
            <div class="space-y-4">
              <div v-for="order in pendingOrders.slice(0, 5)" :key="order.id" class="flex items-center justify-between p-4 border border-blue-100 rounded-xl bg-blue-50/50">
                <div class="flex items-center space-x-4">
                  <span class="w-12 h-12 bg-blue-100 text-blue-600 font-black rounded-lg flex items-center justify-center text-sm">#{{ order.id.slice(-4) }}</span>
                  <div>
                    <p class="font-bold text-slate-800">{{ order.name }}</p>
                    <p class="text-sm text-slate-500 mt-1">{{ order.time }} 下单 · 预计收入 ¥{{ order.totalPrice.toFixed(2) }}</p>
                  </div>
                </div>
                <!-- 新增了拒单操作 -->
                <div class="flex space-x-2">
                  <button @click="acceptOrder(order.id)" class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2.5 rounded-lg font-bold text-sm shadow-md transition transform hover:scale-105">接 单</button>
                  <button @click="cancelOrder(order.id)" class="bg-red-50 hover:bg-red-100 text-red-500 px-4 py-2.5 rounded-lg font-bold text-sm transition">拒 单</button>
                </div>
              </div>
              <div v-if="pendingOrders.length === 0" class="text-center py-8 text-slate-400">
                <i class="fas fa-coffee text-4xl mb-3 text-slate-200"></i>
                <p>暂无待处理的新订单</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 🌟 Tab 2: 订单管理 (完整列表 + 操作按钮) -->
        <div v-if="currentTab === 'orders'" class="bg-white rounded-2xl shadow-sm border border-slate-100 p-6">
          <h3 class="text-lg font-bold text-slate-800 mb-6">全部订单记录</h3>
          <table class="w-full text-left">
            <thead>
              <tr class="text-slate-500 text-sm border-b border-slate-100">
                <th class="pb-3 font-medium">订单编号</th>
                <th class="pb-3 font-medium">商品内容</th>
                <th class="pb-3 font-medium">实付金额</th>
                <th class="pb-3 font-medium">下单时间</th>
                <th class="pb-3 font-medium">状态</th>
                <th class="pb-3 font-medium text-right">操作</th> <!-- 新增操作列 -->
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in myOrders" :key="order.id" class="border-b border-slate-50 hover:bg-slate-50 transition">
                <td class="py-4 font-bold text-slate-800 text-sm">{{ order.id }}</td>
                <td class="py-4 text-slate-700 text-sm">{{ order.name }}</td>
                <td class="py-4 font-bold text-slate-800 text-sm">¥{{ order.totalPrice.toFixed(2) }}</td>
                <td class="py-4 text-slate-500 text-sm">{{ order.time }}</td>
                <td class="py-4">
                  <!-- 完善的状态徽章 -->
                  <span v-if="order.status === 'pending'" class="bg-red-100 text-red-600 px-2 py-1 rounded text-xs font-bold border border-red-200">待接单</span>
                  <span v-else-if="order.status === 'accepted'" class="bg-blue-100 text-blue-600 px-2 py-1 rounded text-xs font-bold border border-blue-200">制作中</span>
                  <span v-else-if="order.status === 'ready'" class="bg-green-100 text-green-600 px-2 py-1 rounded text-xs font-bold border border-green-200">已出餐</span>
                  <span v-else-if="order.status === 'cancelled'" class="bg-gray-100 text-gray-500 px-2 py-1 rounded text-xs font-bold border border-gray-200">已取消</span>
                </td>
                <td class="py-4 text-right space-x-3">
                  <!-- 针对不同状态显示不同操作 -->
                  <template v-if="order.status === 'pending'">
                    <button @click="acceptOrder(order.id)" class="text-blue-600 hover:text-blue-800 text-sm font-bold">接单</button>
                    <button @click="cancelOrder(order.id)" class="text-red-500 hover:text-red-700 text-sm font-bold">取消</button>
                  </template>
                  <template v-else-if="order.status === 'accepted'">
                    <button @click="completeOrder(order.id)" class="text-green-600 hover:text-green-800 text-sm font-bold">标记已出餐</button>
                  </template>
                  <span v-else class="text-gray-400 text-sm">-</span>
                </td>
              </tr>
              <tr v-if="myOrders.length === 0">
                <td colspan="6" class="py-8 text-center text-slate-400">还没有任何订单产生</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Tab 3: 菜品管理 -->
        <div v-if="currentTab === 'dishes'" class="bg-white rounded-2xl shadow-sm border border-slate-100 p-6">
           <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold text-slate-800">本店菜品列表</h3>
            <button @click="showAddModal = true" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-bold text-sm shadow-md transition flex items-center">
              <i class="fas fa-plus mr-2"></i> 上架新菜品
            </button>
          </div>
          <table class="w-full text-left">
            <thead>
              <tr class="text-slate-500 text-sm border-b border-slate-100">
                <th class="pb-3 font-medium">菜品名称</th>
                <th class="pb-3 font-medium">价格</th>
                <th class="pb-3 font-medium text-right">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="dish in myDishes" :key="dish.id" class="border-b border-slate-50 hover:bg-slate-50 transition">
                <td class="py-4 font-bold text-slate-800 flex items-center">
                   <div class="w-10 h-10 bg-gray-200 rounded mr-3 overflow-hidden">
                     <img :src="dish.image || '/images/1.jpg'" class="w-full h-full object-cover">
                   </div>
                   {{ dish.name }}
                </td>
                <td class="py-4 text-blue-600 font-bold">¥{{ dish.price }}</td>
                <td class="py-4 text-right space-x-2">
                  <button @click="deleteDish(dish.id)" class="text-red-500 hover:text-red-700 text-sm font-medium">删除</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </main>

    <!-- 弹窗：上架新菜品 -->
    <div v-if="showAddModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center z-50">
      <div class="bg-white w-full max-w-md rounded-2xl shadow-2xl p-6">
        <h3 class="text-xl font-bold text-slate-800 mb-4">新增菜品</h3>
        <form @submit.prevent="handleAddDish" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-slate-700 mb-1">菜品名称</label>
            <input v-model="newDish.name" type="text" required class="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-blue-500">
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-700 mb-1">价格 (元)</label>
            <input v-model="newDish.price" type="number" step="0.1" required class="w-full px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-blue-500">
          </div>
          <div class="flex space-x-3 mt-6">
            <button type="button" @click="showAddModal = false" class="flex-1 px-4 py-2 border border-slate-200 rounded-lg font-bold">取消</button>
            <button type="submit" class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg font-bold">确认上架</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const currentTab = ref('dashboard') // 默认进入概览
const showAddModal = ref(false)

// 菜品相关
const myDishes = ref([])
const newDish = ref({ name: '', price: '' })

// 🌟 订单相关
const myOrders = ref([])

// 计算属性：筛选出 "待接单" 的订单
const pendingOrders = computed(() => {
  return myOrders.value.filter(o => o.status === 'pending')
})

// 计算属性：有效订单数 (接单、已出餐)
const validOrdersCount = computed(() => {
  return myOrders.value.filter(o => o.status === 'accepted' || o.status === 'ready').length
})

// 计算属性：总营业额 (仅计算接单和已出餐后的，排除已取消的)
const totalRevenue = computed(() => {
  return myOrders.value
    .filter(o => o.status === 'accepted' || o.status === 'ready')
    .reduce((sum, order) => sum + order.totalPrice, 0)
})

// 播放来单提示音 (改为中文语音播报)
const playAlertSound = () => {
  if ('speechSynthesis' in window) {
    // 使用浏览器原生的语音合成 API
    const msg = new SpeechSynthesisUtterance('您有新的订单，请及时处理')
    msg.lang = 'zh-CN' // 设置为中文
    msg.rate = 1.0     // 语速
    msg.pitch = 1.8    // 音调
    window.speechSynthesis.speak(msg)
  } else {
    // 如果浏览器不支持语音合成，回退到原来的滴滴声
    const audio = new Audio('https://actions.google.com/sounds/v1/alarms/beep_short.ogg')
    audio.play().catch(err => {
      console.warn('浏览器策略拦截了音频自动播放，用户需先点击页面:', err)
    })
  }
}

// 读取本地数据的函数
let isFirstLoad = true // 标记是否为首次加载，防止刚进页面就响铃
const loadData = () => {
  const savedDishes = localStorage.getItem('merchant_dishes')
  if (savedDishes) myDishes.value = JSON.parse(savedDishes)

  const savedOrders = localStorage.getItem('merchant_orders')
  if (savedOrders) {
    const parsedOrders = JSON.parse(savedOrders)
    
    // 获取缓存中新的待接单数量
    const newPendingCount = parsedOrders.filter(o => o.status === 'pending').length
    // 获取当前页面已知的待接单数量
    const oldPendingCount = myOrders.value.filter(o => o.status === 'pending').length
    
    // 如果不是初次加载，且待接单数量增加了，说明来新订单了！
    if (!isFirstLoad && newPendingCount > oldPendingCount) {
      playAlertSound()
    }

    myOrders.value = parsedOrders
  }
  isFirstLoad = false
}

let timer = null

onMounted(() => {
  loadData()
  // 每隔 2 秒自动检查一次有没有新订单
  timer = setInterval(() => {
    loadData()
  }, 2000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})

// 🌟 订单操作方法集
const updateOrderStatus = (orderId, status) => {
  const order = myOrders.value.find(o => o.id === orderId)
  if (order) {
    order.status = status
    localStorage.setItem('merchant_orders', JSON.stringify(myOrders.value))
  }
}

const acceptOrder = (orderId) => updateOrderStatus(orderId, 'accepted')    // 接单
const completeOrder = (orderId) => updateOrderStatus(orderId, 'ready')      // 已出餐
const cancelOrder = (orderId) => updateOrderStatus(orderId, 'cancelled')    // 取消/拒单

// 菜品管理
const handleAddDish = () => {
  const dish = { id: Date.now(), name: newDish.value.name, price: Number(newDish.value.price), image: '/images/1.jpg', categoryIdx: 1 }
  myDishes.value.push(dish)
  localStorage.setItem('merchant_dishes', JSON.stringify(myDishes.value))
  newDish.value = { name: '', price: '' }
  showAddModal.value = false
}
const deleteDish = (id) => {
  myDishes.value = myDishes.value.filter(d => d.id !== id)
  localStorage.setItem('merchant_dishes', JSON.stringify(myDishes.value))
}

const logout = () => {
  localStorage.removeItem('system_role')
  router.push('/admin-login')
}
</script>