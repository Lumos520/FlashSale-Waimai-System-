<template>
  <div class="min-h-screen flex flex-col justify-center bg-gray-50">
    <div class="max-w-md w-full mx-auto bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
      <h2 class="text-2xl font-bold text-center mb-8">用户登录</h2>
      <form class="space-y-4" @submit.prevent="handleLogin">
        <div>
          <label class="block text-sm font-medium mb-1">手机号</label>
          <input v-model="phone" type="tel" class="w-full px-4 py-2 border rounded-xl" placeholder="请输入手机号">
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">密码</label>
          <input v-model="password" type="password" class="w-full px-4 py-2 border rounded-xl" placeholder="请输入密码">
        </div>
        <button type="submit" class="w-full bg-primary text-white py-2 rounded-xl font-bold">登 录</button>
      </form>
      <p class="text-center text-sm mt-4 text-gray-500">
        还没有账号？<router-link to="/register" class="text-primary font-bold">免费注册</router-link>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const phone = ref('')
const password = ref('')
const router = useRouter()

const handleLogin = () => {
  const users = JSON.parse(localStorage.getItem('user_db') || '[]')
  const user = users.find(u => u.phone === phone.value && u.password === password.value)
  
  if (user) {
    localStorage.setItem('isLoggedIn', 'true')
    router.push('/')
  } else {
    alert('账号或密码错误')
  }
}
</script>