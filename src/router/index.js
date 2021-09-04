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
import CreateTask from '../views/user/task/CreateTask.vue'
import EditTask from '../views/user/task/EditTask.vue'
import TaskAssignedHistory from '../views/user/task/TaskAssignedHistory.vue'
import TodoList from '../views/user/todos/TodoList.vue'

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
    path: '/taskListDetail/:teamID/:taskListID',
    name: 'TaskList',
    component: TaskList,
    props: true,
  },
  {
    path: '/createTask/:teamID/:taskListID',
    name: 'CreateTask',
    component: CreateTask,
    props: true,
  },
  {
    path: '/editTask/:teamID/:taskID',
    name: 'EditTask',
    component: EditTask,
    props: true,
  },
  {
    path: '/taskAssignHistory/:userList/:assigendUserList/:assigendDateList',
    name: 'TaskAssignedHistory',
    component: TaskAssignedHistory,
    props: true,
  },
  {
    path: '/todos',
    name: 'TodoList',
    component: TodoList,
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
