<template>
  <div class="min-h-screen bg-gray-50 pb-24">
    <!-- 顶部导航 -->
    <header class="bg-white sticky top-0 z-40 border-b border-gray-100 shadow-sm">
      <div class="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
        <button @click="$router.push('/')" class="text-gray-600 hover:text-primary font-bold flex items-center transition">
          <i class="fas fa-chevron-left mr-2"></i> 返回首页
        </button>
        <div class="flex items-center space-x-2">
          <span class="font-extrabold text-lg text-gray-900">{{ shopName }}</span>
          <span class="bg-orange-100 text-orange-600 text-xs px-2 py-0.5 rounded font-bold">营业中</span>
        </div>
        <div class="w-20"></div> <!-- 占位符保持居中 -->
      </div>
    </header>

    <!-- 商家头部信息卡片 -->
    <div class="max-w-6xl mx-auto px-4 mt-4">
      <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 flex items-start space-x-4">
        <img src="https://ui-avatars.com/api/?name=Shop&background=3b82f6&color=fff" class="w-16 h-16 rounded-xl shadow-sm">
        <div>
          <h2 class="text-xl font-extrabold text-gray-900 mb-1">苍穹烧烤 (高新店)</h2>
          <p class="text-sm text-gray-500 mb-2">⭐ 4.8 评分 | 月售 3000+ | 约 30 分钟送达</p>
          <div class="flex space-x-2">
            <span class="text-xs text-red-500 bg-red-50 border border-red-100 px-1.5 py-0.5 rounded">满30减15</span>
            <span class="text-xs text-red-500 bg-red-50 border border-red-100 px-1.5 py-0.5 rounded">新客立减5元</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 点餐主体区域 -->
    <main class="max-w-6xl mx-auto px-4 mt-6 grid grid-cols-4 gap-6">
      <!-- 1. 左侧菜品分类栏 -->
      <aside class="col-span-1 bg-white rounded-2xl p-4 shadow-sm border border-gray-100 h-fit sticky top-24">
        <nav class="space-y-1">
          <button 
            v-for="(cat, idx) in categories" 
            :key="idx"
            @click="activeCat = idx"
            :class="['w-full text-left px-4 py-3 rounded-xl font-bold text-sm transition', activeCat === idx ? 'bg-primary/10 text-primary' : 'text-gray-600 hover:bg-gray-50']"
          >
            {{ cat }}
          </button>
        </nav>
      </aside>

      <!-- 2. 右侧菜品列表 -->
      <section class="col-span-3 space-y-6">
        <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
          <h2 class="text-xl font-extrabold mb-6 text-gray-900 border-b pb-3">{{ categories[activeCat] }}</h2>
          
          <div v-if="filteredDishes.length === 0" class="text-center py-12 text-gray-400">
            <i class="fas fa-box-open text-4xl mb-3"></i>
            <p>该分类下暂无菜品哦~</p>
          </div>

          <div class="grid grid-cols-1 gap-6">
            <!-- 单个菜品行 -->
            <div v-for="dish in filteredDishes" :key="dish.id" class="flex items-center justify-between border-b border-gray-50 pb-6 last:border-0 last:pb-0">
              <div class="flex items-center space-x-4">
                <div class="w-24 h-24 rounded-xl overflow-hidden bg-gray-100 shadow-sm border border-gray-50">
                  <img :src="dish.image || '/images/1.jpg'" class="w-full h-full object-cover">
                </div>
                <div class="flex flex-col h-24 justify-between py-1">
                  <div>
                    <h4 class="font-extrabold text-gray-900 text-lg">{{ dish.name }}</h4>
                    <p class="text-gray-400 text-xs mt-1">{{ dish.sale || '月售 0 份' }}</p>
                  </div>
                  <span class="text-primary font-black text-xl"><span class="text-sm">¥</span>{{ dish.price }}</span>
                </div>
              </div>

              <!-- 购物车数量加减按钮 -->
              <div class="flex items-center space-x-3">
                <button 
                  v-if="getCartQty(dish.id) > 0" 
                  @click="updateCart(dish, -1)" 
                  class="w-8 h-8 rounded-full border-2 border-gray-200 text-gray-500 hover:border-primary hover:text-primary flex items-center justify-center font-bold text-lg transition"
                >
                  -
                </button>
                <span v-if="getCartQty(dish.id) > 0" class="font-bold text-gray-800 w-4 text-center">{{ getCartQty(dish.id) }}</span>
                <button 
                  @click="updateCart(dish, 1)" 
                  class="w-8 h-8 rounded-full bg-primary text-white hover:bg-orange-600 flex items-center justify-center font-bold text-lg transition shadow-md shadow-orange-500/20"
                >
                  +
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- 3. 底部悬浮购物车结算条 -->
    <transition name="slide-up">
      <footer v-if="totalQty > 0" class="fixed bottom-6 left-1/2 -translate-x-1/2 w-[90%] max-w-4xl bg-gray-900 text-white h-16 rounded-full shadow-2xl flex items-center justify-between px-6 z-50 overflow-hidden">
        <div class="flex items-center space-x-4">
          <div class="relative w-12 h-12 bg-primary rounded-full flex items-center justify-center text-xl shadow-lg shadow-orange-500/40 -mt-4 ring-4 ring-gray-900">
            <i class="fas fa-shopping-basket"></i>
            <span class="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] w-5 h-5 rounded-full flex items-center justify-center font-bold border-2 border-gray-900">
              {{ totalQty }}
            </span>
          </div>
          <div>
            <span class="text-xl font-black">¥{{ totalPrice.toFixed(1) }}</span>
            <p class="text-[10px] text-gray-400">另需配送费 ¥{{ deliveryFee }}</p>
          </div>
        </div>
        <button @click="checkout" class="bg-primary hover:bg-orange-600 text-white font-bold h-full px-8 -mr-6 transition-colors text-lg flex items-center justify-center">
          去结算 <i class="fas fa-arrow-right ml-2 text-sm"></i>
        </button>
      </footer>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const shopName = ref('苍穹烧烤 (高新店)')
const activeCat = ref(0)
const categories = ['招牌必点', '商家上新', '美味小食', '冰爽饮品']
const cart = ref([])
const deliveryFee = 4

// 默认的一些系统菜品
const defaultDishes = [
  { id: 101, categoryIdx: 0, name: '苍穹烤羊肉串(5串)', price: 28.0, sale: '月售 1200+ 份', image: '/images/1.jpg' },
  { id: 102, categoryIdx: 0, name: '蜜汁烤翅(一对)', price: 12.0, sale: '月售 800+ 份', image: '/images/1.jpg' },
  { id: 301, categoryIdx: 2, name: '脆皮炸薯条', price: 9.0, sale: '月售 1500+ 份', image: '/images/1.jpg' },
  { id: 401, categoryIdx: 3, name: '手打柠檬红茶', price: 10.0, sale: '月售 3000+ 份', image: '/images/1.jpg' }
]

const dishes = ref([...defaultDishes])

// ⚡ 关键联动逻辑：页面加载时，去读取 B端商家上架的新菜品
onMounted(() => {
  const merchantSavedDishes = localStorage.getItem('merchant_dishes')
  if (merchantSavedDishes) {
    const newDishes = JSON.parse(merchantSavedDishes)
    // 我们把商家新上的菜，默认放到分类1（商家上新）里
    newDishes.forEach(d => d.categoryIdx = 1) 
    
    // 把商家新上的菜和默认的菜合并显示
    dishes.value = [...defaultDishes, ...newDishes]
  }
})

// 根据左侧选中的分类过滤右侧菜品
const filteredDishes = computed(() => {
  return dishes.value.filter(d => d.categoryIdx === activeCat.value)
})

const getCartQty = (id) => {
  const item = cart.value.find(i => i.id === id)
  return item ? item.qty : 0
}

const updateCart = (dish, val) => {
  const item = cart.value.find(i => i.id === dish.id)
  if (item) {
    item.qty += val
    if (item.qty <= 0) {
      cart.value = cart.value.filter(i => i.id !== dish.id)
    }
  } else if (val > 0) {
    cart.value.push({ ...dish, qty: 1 })
  }
}

const totalQty = computed(() => cart.value.reduce((sum, i) => sum + i.qty, 0))
const totalPrice = computed(() => cart.value.reduce((sum, i) => sum + (i.price * i.qty), 0))

const checkout = () => {
  // 把购物车结算数据写入本地，准备跳转到收银台
  localStorage.setItem('checkout_item', JSON.stringify({
    name: `${shopName.value} - 等${totalQty.value}件商品`,
    price: totalPrice.value,
    quantity: totalQty.value,
    deliveryFee: deliveryFee
  }))
  router.push('/checkout')
}
</script>

<style scoped>
.slide-up-enter-active,
.slide-up-leave-active {
  transition: all 0.3s ease-out;
}
.slide-up-enter-from,
.slide-up-leave-to {
  transform: translate(-50%, 100%);
  opacity: 0;
}
</style>