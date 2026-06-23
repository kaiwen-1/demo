import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { userApi } from '@/api/user'

const USER_STORAGE_KEY = 'hotel_user'

function loadUserFromStorage() {
  try {
    const storedUser = localStorage.getItem(USER_STORAGE_KEY)
    if (storedUser) {
      const user = JSON.parse(storedUser)
      return user
    }
  } catch (e) {
    console.error('Failed to load user from storage:', e)
  }
  return null
}

function saveUserToStorage(userData) {
  try {
    if (userData) {
      localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(userData))
    } else {
      localStorage.removeItem(USER_STORAGE_KEY)
    }
  } catch (e) {
    console.error('Failed to save user to storage:', e)
  }
}

export const useUserStore = defineStore('user', () => {
  const user = ref(loadUserFromStorage())
  const isLoggedIn = computed(() => !!user.value)
  const isAdmin = computed(() => user.value?.role === 'admin')
  const isCustomer = computed(() => user.value?.role === 'customer')

  async function login(credentials) {
    const res = await userApi.login(credentials)
    user.value = res.user
    saveUserToStorage(res.user)
    return res
  }

  async function logout() {
    try {
      await userApi.logout()
    } catch {
    }
    user.value = null
    saveUserToStorage(null)
  }

  async function fetchProfile() {
    try {
      const res = await userApi.getProfile()
      user.value = res
      saveUserToStorage(res)
      return res
    } catch {
      const storedUser = loadUserFromStorage()
      if (storedUser) {
        user.value = storedUser
      }
      return user.value
    }
  }

  async function updateProfile(data) {
    const res = await userApi.updateProfile(data)
    user.value = res
    saveUserToStorage(res)
    return res
  }

  async function updateProfileWithAvatar(formData) {
    if (!user.value?.id) {
      throw new Error('User ID is required')
    }
    const res = await userApi.updateProfileWithAvatar(user.value.id, formData)
    user.value = res
    saveUserToStorage(res)
    return res
  }

  async function changePassword(data) {
    await userApi.changePassword(data)
    return true
  }

  return {
    user,
    isLoggedIn,
    isAdmin,
    isCustomer,
    login,
    logout,
    fetchProfile,
    updateProfile,
    updateProfileWithAvatar,
    changePassword,
  }
})
