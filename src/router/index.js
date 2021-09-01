import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import AdminHome from '../views/admin/AdminHome.vue'
import UserDetails from '../views/admin/UserDetails.vue'
import UserHome from '../views/user/UserHome.vue'
import TeamList from '../views/user/TeamList.vue'
import GroupSettings from '../views/user/GroupSettings.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
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
  {
    path: '/groupDetail/:groupID',
    name: 'TeamList',
    component: TeamList,
    props: true,
  },
  {
    path: '/groupSettings/:groupID',
    name: 'GroupSettings',
    component: GroupSettings,
    props: true,
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
