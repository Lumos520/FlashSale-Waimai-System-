<template>
  <div class="min-h-screen flex flex-col justify-center bg-gray-50">
    <div class="max-w-md w-full mx-auto bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
      <h2 class="text-2xl font-bold text-center mb-8">用户注册</h2>
      <form class="space-y-4" @submit.prevent="handleRegister">
        <div>
          <label class="block text-sm font-medium mb-1">手机号</label>
          <input v-model="phone" type="tel" required class="w-full px-4 py-2 border rounded-xl" placeholder="输入手机号">
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">密码</label>
          <input v-model="password" type="password" required class="w-full px-4 py-2 border rounded-xl" placeholder="设置密码">
        </div>
        <button type="submit" class="w-full bg-primary text-white py-2 rounded-xl font-bold">立即注册</button>
      </form>
      <p class="text-center text-sm mt-4 text-gray-500">
        已有账号？<router-link to="/login" class="text-primary font-bold">去登录</router-link>
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

const handleRegister = () => {
  // 从 localStorage 获取现有的用户列表（模拟读取文件）
  let users = JSON.parse(localStorage.getItem('user_db') || '[]')
  
  // 检查手机号是否已存在
  if (users.find(u => u.phone === phone.value)) {
    alert('该手机号已被注册')
    return
  }

  // 保存新用户（模拟写入文件）
  users.push({ phone: phone.value, password: password.value })
  localStorage.setItem('user_db', JSON.stringify(users))
  
  alert('注册成功，请登录')
  router.push('/login')
}
</script>