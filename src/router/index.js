import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../views/Login.vue'
import AdminHome from '../views/admin/AdminHome.vue'
import UserDetails from '../views/admin/UserDetails.vue'
import UserHome from '../views/user/UserHome.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/adminHome',
    name: 'AdminHome',
    component: AdminHome
  },
  {
    path: '/userDetails/:userID',
    name: 'UserDetails',
    component: UserDetails,
    props: true,
  },
  {
    path: '/userHome',
    name: 'UserHome',
    component: UserHome
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router