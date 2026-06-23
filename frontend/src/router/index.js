import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const routes = [
  {
    path: '/',
    component: () => import('@/layouts/FrontLayout.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('@/views/front/Home.vue'),
        meta: { title: '首页' },
      },
      {
        path: 'rooms',
        name: 'Rooms',
        component: () => import('@/views/front/Rooms.vue'),
        meta: { title: '房间列表' },
      },
      {
        path: 'rooms/:id',
        name: 'RoomDetail',
        component: () => import('@/views/front/RoomDetail.vue'),
        meta: { title: '房间详情' },
      },
      {
        path: 'booking/:roomId',
        name: 'Booking',
        component: () => import('@/views/front/Booking.vue'),
        meta: { title: '预订房间', requiresAuth: true },
      },
      {
        path: 'payment/:id',
        name: 'Payment',
        component: () => import('@/views/front/Payment.vue'),
        meta: { title: '订单支付', requiresAuth: true },
      },
      {
        path: 'user',
        name: 'UserCenter',
        component: () => import('@/views/front/UserCenter.vue'),
        meta: { title: '个人中心', requiresAuth: true },
      },
      {
        path: 'user/bookings',
        name: 'UserBookings',
        component: () => import('@/views/front/UserBookings.vue'),
        meta: { title: '我的预订', requiresAuth: true },
      },
      {
        path: 'user/favorites',
        name: 'UserFavorites',
        component: () => import('@/views/front/Favorites.vue'),
        meta: { title: '我的收藏', requiresAuth: true },
      },
      {
        path: 'user/notifications',
        name: 'UserNotifications',
        component: () => import('@/views/front/Notifications.vue'),
        meta: { title: '消息通知', requiresAuth: true },
      },
      {
        path: 'login',
        name: 'Login',
        component: () => import('@/views/front/Login.vue'),
        meta: { title: '登录', guest: true },
      },
      {
        path: 'register',
        name: 'Register',
        component: () => import('@/views/front/Register.vue'),
        meta: { title: '注册', guest: true },
      },
    ],
  },
  {
    path: '/admin',
    component: () => import('@/layouts/AdminLayout.vue'),
    meta: { requiresAdmin: true },
    children: [
      {
        path: '',
        name: 'AdminDashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: { title: '数据统计' },
      },
      {
        path: 'rooms',
        name: 'AdminRooms',
        component: () => import('@/views/admin/Rooms.vue'),
        meta: { title: '房间管理' },
      },
      {
        path: 'room-types',
        name: 'AdminRoomTypes',
        component: () => import('@/views/admin/RoomTypes.vue'),
        meta: { title: '房型管理' },
      },
      {
        path: 'bookings',
        name: 'AdminBookings',
        component: () => import('@/views/admin/Bookings.vue'),
        meta: { title: '预订管理' },
      },
      {
        path: 'users',
        name: 'AdminUsers',
        component: () => import('@/views/admin/Users.vue'),
        meta: { title: '用户管理' },
      },
      {
        path: 'reviews',
        name: 'AdminReviews',
        component: () => import('@/views/admin/Reviews.vue'),
        meta: { title: '评论管理' },
      },
      {
        path: 'operations',
        name: 'AdminOperations',
        component: () => import('@/views/admin/Operations.vue'),
        meta: { title: '运营管理' },
      },

      {
        path: 'system',
        name: 'AdminSystem',
        component: () => import('@/views/admin/System.vue'),
        meta: { title: '系统设置' },
      },
    ],
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFound.vue'),
    meta: { title: '页面未找到' },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  },
})

router.beforeEach(async (to, from, next) => {
  document.title = `${to.meta.title || '首页'} - 酒店管理系统`
  
  const userStore = useUserStore()
  
  const requiresAuth = to.meta.requiresAuth || to.meta.requiresAdmin
  const hasUser = !!userStore.user
  
  if (requiresAuth && !hasUser) {
    const result = await userStore.fetchProfile()
    if (!result) {
      next({ name: 'Login', query: { redirect: to.fullPath } })
      return
    }
  }
  
  if (to.meta.guest && userStore.user) {
    next({ name: 'Home' })
  } else if (to.meta.requiresAdmin && !userStore.isAdmin) {
    next({ name: 'Home' })
  } else {
    next()
  }
})

export default router
