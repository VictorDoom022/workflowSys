import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import AdminHome from '../views/admin/AdminHome.vue'
import UserDetails from '../views/admin/UserDetails.vue'
import UserHome from '../views/user/UserHome.vue'
import TeamList from '../views/user/groups/TeamList.vue'
import GroupSettings from '../views/user/groups/GroupSettings.vue'
import TaskListList from '../views/user/teams/TaskListList.vue'
import TeamSettings from '../views/user/teams/TeamSettings.vue'
import TaskList from '../views/user/task/TaskList.vue'

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
  {
    path: '/teamDetail/:groupID/:teamID',
    name: 'TaskListList',
    component: TaskListList,
    props: true,
  },
  {
    path: '/teamSettings/:groupID/:teamID',
    name: 'TeamSettings',
    component: TeamSettings,
    props: true,
  },
  {
    path: '/taskListDetail/:taskListID',
    name: 'TaskList',
    component: TaskList,
    props: true,
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
