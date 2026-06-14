<template>
  <div class="min-h-screen bg-slate-900 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
    <!-- 背景装饰 -->
    <div class="absolute -top-24 -left-24 w-96 h-96 bg-blue-500/20 rounded-full blur-3xl"></div>
    <div class="absolute -bottom-24 -right-24 w-96 h-96 bg-purple-500/20 rounded-full blur-3xl"></div>

    <div class="max-w-md w-full space-y-8 bg-white/10 backdrop-blur-lg p-10 rounded-3xl shadow-2xl border border-white/20 z-10">
      <div>
        <div class="w-16 h-16 bg-blue-600 rounded-2xl mx-auto flex items-center justify-center text-white font-bold text-3xl shadow-lg shadow-blue-500/50">
          <i class="fas fa-store-alt"></i>
        </div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-white tracking-wider">业务管理系统</h2>
      </div>
      
      <!-- 角色切换 Tab -->
      <div class="flex bg-slate-800/50 rounded-xl p-1 shadow-inner">
        <button 
          @click="role = 'merchant'"
          :class="['flex-1 py-2.5 rounded-lg text-sm font-bold transition-all duration-300', role === 'merchant' ? 'bg-blue-600 text-white shadow-md' : 'text-gray-400 hover:text-white']"
        >
          商家端
        </button>
        <button 
          @click="role = 'admin'"
          :class="['flex-1 py-2.5 rounded-lg text-sm font-bold transition-all duration-300', role === 'admin' ? 'bg-purple-600 text-white shadow-md' : 'text-gray-400 hover:text-white']"
        >
          总管理端
        </button>
      </div>

      <form class="mt-8 space-y-6" @submit.prevent="handleLogin">
        <div class="space-y-4">
          <div>
            <label class="sr-only">账号</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
                <i class="fas fa-user"></i>
              </div>
              <input v-model="username" type="text" required class="block w-full pl-10 pr-3 py-3 border border-gray-600 rounded-xl bg-slate-800/50 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" placeholder="请输入管理员/商家账号">
            </div>
          </div>
          <div>
            <label class="sr-only">密码</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
                <i class="fas fa-lock"></i>
              </div>
              <input v-model="password" type="password" required class="block w-full pl-10 pr-3 py-3 border border-gray-600 rounded-xl bg-slate-800/50 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" placeholder="请输入密码 (随意输入即可测试)">
            </div>
          </div>
        </div>

        <button type="submit" :class="['w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-lg text-sm font-bold text-white transition-all hover:scale-[1.02]', role === 'merchant' ? 'bg-blue-600 hover:bg-blue-500 shadow-blue-600/30' : 'bg-purple-600 hover:bg-purple-500 shadow-purple-600/30']">
          <i class="fas fa-sign-in-alt mr-2 mt-0.5"></i> 立即登录
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const role = ref('merchant') // 默认选中的标签页
const username = ref('')
const password = ref('')

const handleLogin = () => {
  // 模拟登录成功，记录端的状态
  localStorage.setItem('system_role', role.value)
  
  if (role.value === 'merchant') {
    router.push('/merchant')
  } else {
    router.push('/admin')
  }
}
</script>