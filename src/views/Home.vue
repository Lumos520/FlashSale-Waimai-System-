<template>
  <div class="min-h-screen bg-gray-50 pb-12">
    
   <header class="bg-white shadow-sm sticky top-0 z-50">
  <div class="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between">
    <!-- 左侧 Logo 与 定位 -->
    <div class="flex items-center space-x-6">
      <div class="flex items-center space-x-2 cursor-pointer hover:opacity-80 transition" @click="$router.push('/')">
        <div class="w-10 h-10 bg-primary rounded-xl flex items-center justify-center text-white font-bold text-xl">
          <i class="fas fa-bolt"></i>
        </div>
        <span class="text-2xl font-extrabold text-gray-900 tracking-wider">闪购外卖</span>
      </div>
      <div class="hidden md:flex items-center text-gray-600 hover:text-primary cursor-pointer transition">
        <i class="fas fa-map-marker-alt mr-1"></i>
        <span class="font-medium">上海市浦东新区</span>
        <i class="fas fa-chevron-down ml-1 text-xs"></i>
      </div>
    </div>

    <!-- 核心搜索框 -->
    <div class="flex-1 max-w-2xl mx-8">
      <div class="relative flex items-center group">
        <input 
          type="text" 
          placeholder="搜索商家、美食、饮品..." 
          class="w-full bg-gray-100 border-2 border-transparent focus:border-primary/50 focus:bg-white rounded-full py-2.5 pl-5 pr-24 outline-none transition-all"
        >
        <button class="absolute right-1 top-1 bottom-1 bg-primary text-white px-6 rounded-full font-bold hover:bg-orange-600 transition-colors shadow-sm">
          搜索
        </button>
      </div>
    </div>

    <!-- 右侧个人中心 -->
    <div class="flex items-center space-x-6">
      <div @click="$router.push('/orders')" class="flex flex-col items-center text-gray-600 hover:text-primary cursor-pointer transition">
  <i class="fas fa-file-invoice text-xl mb-0.5"></i>
  <span class="text-xs font-medium">我的订单</span>
</div>
      <div class="flex flex-col items-center text-gray-600 hover:text-primary cursor-pointer transition">
        <i class="fas fa-shopping-cart text-xl mb-0.5"></i>
        <span class="text-xs font-medium">购物车</span>
      </div>

      <!-- 登录状态切换区域 (修改部分) -->
      <div class="relative">
        <!-- 如果已登录 -->
        <div v-if="isLoggedIn" class="flex items-center cursor-pointer" @click="showMenu = !showMenu">
          <img src="https://ui-avatars.com/api/?name=User&background=ff6b00&color=fff" 
               class="w-10 h-10 rounded-full border-2 border-orange-100 shadow-sm hover:ring-2 ring-orange-200 transition">
        </div>
        
        <!-- 如果未登录 -->
        <button v-else @click="$router.push('/login')" 
                class="text-sm font-bold text-gray-700 hover:text-primary transition px-4 py-2 border border-gray-200 rounded-lg hover:border-primary">
          登录 / 注册
        </button>

        <!-- 点击后触发的下拉菜单 (固定在右侧) -->
        <div v-if="isLoggedIn && showMenu" class="absolute right-0 top-14 w-32 bg-white shadow-xl rounded-xl border border-gray-100 p-2 z-50">
          <button class="w-full text-left px-4 py-2 text-sm hover:bg-gray-50 rounded-lg text-gray-700">个人设置</button>
          <button @click="logout" class="w-full text-left px-4 py-2 text-sm text-red-500 hover:bg-red-50 rounded-lg">退出登录</button>
        </div>
      </div>
    </div>
  </div>
</header>
    <main class="max-w-7xl mx-auto px-4 mt-6">
      
      <!-- 2. 营销 Banner 矩阵 -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
        <div class="md:col-span-2 relative h-48 md:h-64 rounded-2xl overflow-hidden cursor-pointer group shadow-sm hover:shadow-md transition">
          <img src="/images/1.jpg" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
          <div class="absolute inset-0 bg-gradient-to-r from-black/60 to-transparent flex items-center px-8">
            <div class="text-white">
              <span class="bg-red-500 text-xs font-bold px-2 py-1 rounded mb-2 inline-block">美妙大牌日</span>
              <h2 class="text-3xl font-extrabold mb-2">有瑞幸就够了</h2>
              <p class="text-lg opacity-90">多品类 9.9起 ></p>
            </div>
          </div>
        </div>
        <div class="relative h-48 md:h-64 rounded-2xl overflow-hidden cursor-pointer group shadow-sm hover:shadow-md transition">
          <img src="/images/1.jpg" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
          <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent flex items-end p-6">
            <div class="text-white">
              <span class="bg-blue-600 text-xs font-bold px-2 py-1 rounded mb-2 inline-block">超大牌</span>
              <h3 class="text-xl font-bold mb-1">鸡柳大人</h3>
              <p class="text-sm opacity-90">全场低至4折</p>
            </div>
          </div>
        </div>
      </div>

      <!-- 3. 图文分类导航 -->
      <div class="bg-white rounded-2xl p-6 shadow-sm mb-8">
        <div class="grid grid-cols-5 md:grid-cols-10 gap-4">
          <div v-for="cat in categories" :key="cat.name" class="flex flex-col items-center cursor-pointer group">
            <div class="w-14 h-14 rounded-full overflow-hidden mb-2 ring-2 ring-transparent group-hover:ring-primary/30 transition-all p-1">
               <img src="/images/1.jpg" class="w-full h-full object-cover rounded-full group-hover:scale-110 transition-transform">
            </div>
            <span class="text-sm text-gray-700 group-hover:text-primary transition">{{ cat.name }}</span>
          </div>
        </div>
      </div>

      <!-- 4. 今日限时秒杀区 -->
      <div class="mb-8">
        <div class="flex items-end justify-between mb-4">
          <h2 class="text-2xl font-extrabold text-gray-900 flex items-center">
            <i class="fas fa-bolt text-red-500 mr-2"></i> 今日秒杀
          </h2>
          <span class="text-sm text-gray-500 cursor-pointer hover:text-primary">查看更多 ></span>
        </div>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div v-for="i in 4" :key="i" class="bg-white p-4 rounded-xl shadow-sm hover:shadow-md transition cursor-pointer border border-red-50 hover:border-red-200">
            <div class="aspect-square w-full overflow-hidden rounded-lg mb-3 relative">
              <img src="/images/1.jpg" class="w-full h-full object-cover">
            </div>
            <h4 class="font-bold text-gray-800 truncate mb-2">香辣鸡腿堡套餐</h4>
            <div class="flex items-baseline justify-between">
              <div>
                <span class="text-red-500 font-bold text-lg">¥9.9</span>
                <span class="text-gray-400 line-through text-xs ml-1">¥25</span>
              </div>
              <!-- 修改这里：添加了 @click 跳转到秒杀商品详情页 -->
              <button @click="$router.push(`/flash/${i}`)" class="bg-red-500 px-3 py-1 rounded-full text-xs font-bold text-white hover:bg-red-600 transition">马上抢</button>
            </div>
          </div>
        </div>
      </div>

      <!-- 5. 推荐商家列表 -->
      <div class="bg-white rounded-2xl shadow-sm p-6">
        <div class="flex items-center space-x-6 border-b border-gray-100 pb-4 mb-6">
          <div class="font-bold text-lg text-primary border-b-2 border-primary pb-4 -mb-[25px] cursor-pointer">综合推荐</div>
          <div class="text-gray-600 hover:text-primary cursor-pointer transition font-medium">销量最高</div>
          <div class="text-gray-600 hover:text-primary cursor-pointer transition font-medium">距离最近</div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <!-- 修改这里：在最外层的 div 添加了 @click 动态跳转到对应的店铺详情页 -->
          <div v-for="shop in merchants" :key="shop.id" 
               @click="$router.push(`/shop/${shop.id}`)"
               class="group flex flex-col bg-white rounded-xl border border-gray-100 hover:border-primary/30 hover:shadow-xl transition-all cursor-pointer overflow-hidden">
            <div class="h-48 relative overflow-hidden">
              <img src="/images/1.jpg" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
            </div>
            <div class="p-4 flex-1 flex flex-col">
              <h3 class="text-lg font-bold text-gray-900 mb-1 group-hover:text-primary transition-colors truncate">{{ shop.name }}</h3>
              <div class="flex items-center text-orange-500 font-bold text-sm mb-2">
                <i class="fas fa-star text-xs mr-1"></i> {{ shop.rating }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isLoggedIn = ref(false)
const showMenu = ref(false) // 新增：控制下拉菜单开关

// 页面加载时检查登录状态
onMounted(() => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true'
})

// 退出登录逻辑
const logout = () => {
  localStorage.removeItem('isLoggedIn')
  isLoggedIn.value = false
  showMenu.value = false // 退出时关闭菜单
  router.push('/')
  // 强制刷新页面以确保头部状态同步更新
  window.location.reload()
}

const categories = ref([
  { name: '附近美食' }, { name: '奶茶咖啡' }, { name: '小吃快餐' },
  { name: '美食榜单' }, { name: '自助餐' }, { name: '烧烤烤肉' },
  { name: '日韩料理' }, { name: '汉堡披萨' }, { name: '火锅' }, { name: '全部分类' }
])

const merchants = ref([
  { id: 1, name: '苍穹烧烤 (高新店)', rating: 4.8, image: '/images/1.jpg' },
  { id: 2, name: '麦当劳 (软件园店)', rating: 4.9, image: '/images/1.jpg' },
  { id: 3, name: '达美乐比萨 (高新店)', rating: 4.7, image: '/images/1.jpg' },
  { id: 4, name: '霸王茶姬 (大学城店)', rating: 4.9, image: '/images/1.jpg' }
])
</script>