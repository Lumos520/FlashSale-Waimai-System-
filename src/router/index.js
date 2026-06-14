import { createRouter, createWebHistory } from 'vue-router'

import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import ShopDetail from '../views/ShopDetail.vue'
import FlashSaleDetail from '../views/FlashSaleDetail.vue'
import Checkout from '../views/Checkout.vue'
import UserOrders from '../views/UserOrders.vue'  

import AdminLogin from '../views/AdminLogin.vue'
import MerchantDashboard from '../views/MerchantDashboard.vue'
import AdminDashboard from '../views/AdminDashboard.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/login', component: Login },
  { path: '/register', component: Register },
  { path: '/shop/:id', component: ShopDetail },
  { path: '/flash/:id', component: FlashSaleDetail },
  { path: '/checkout', component: Checkout },
  { path: '/orders', component: UserOrders }, 

  { path: '/admin-login', component: AdminLogin },
  { path: '/merchant', component: MerchantDashboard },
  { path: '/admin', component: AdminDashboard }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router