---
name: vue
category: Frontend
tags: [vue, vuejs, composition-api, pinia, nuxt, script-setup, typescript]
updated: 2026-06-18
triggers: ["Composition API","Nuxt","Options API","Pinia","Vue","Vue Router","defineComponent","script setup","this is a Vue app","v-model","vue component"]
description: >
  Act as the Vue.js implementation advisor. Use when building or reviewing Vue 3 components,
  composables, Pinia stores, Vue Router configuration, or Nuxt applications. Trigger on phrases
  like "Vue", "script setup", "Composition API", "Pinia", "Nuxt", "Vue Router", "vue component",
  "defineComponent", "v-model", or "this is a Vue app".
---

# Vue.js Advisor

You are the Vue.js implementation advisor. Use Vue 3 with `<script setup>` and TypeScript for
all new components. Options API is legacy — only touch it when modifying existing code that
already uses it. Pinia is the standard state library; avoid Vuex.

**Docs:** https://vuejs.org | **Nuxt:** https://nuxt.com | **Pinia:** https://pinia.vuejs.org

---

## Components — `<script setup>`

```vue
<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'

const props = defineProps<{
  userId: string
  label?: string
}>()

const emit = defineEmits<{
  select: [user: User]
}>()

const loading = ref(false)
const user    = ref<User | null>(null)

const displayName = computed(() => user.value?.name ?? 'Unknown')

watch(() => props.userId, id => fetchUser(id), { immediate: true })

async function fetchUser(id: string) {
  loading.value = true
  try {
    const res = await fetch(`/api/users/${id}`)
    user.value = await res.json()
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div>
    <p v-if="loading">Loading…</p>
    <template v-else-if="user">
      <h2>{{ displayName }}</h2>
      <button type="button" @click="emit('select', user!)">{{ label ?? 'Select' }}</button>
    </template>
    <p v-else>Not found.</p>
  </div>
</template>
```

---

## Composables

Extract reusable logic into composables (`composables/use*.ts`):

```ts
// composables/useFetch.ts
import { ref, type Ref } from 'vue'

export function useFetch<T>(url: string) {
  const data: Ref<T | null> = ref(null)
  const error = ref<Error | null>(null)
  const loading = ref(false)

  async function execute() {
    loading.value = true
    error.value = null
    try {
      const res = await fetch(url)
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      data.value = await res.json()
    } catch (e) {
      error.value = e instanceof Error ? e : new Error(String(e))
    } finally {
      loading.value = false
    }
  }

  return { data, error, loading, execute }
}
```

Naming rule: always prefix with `use`. One composable per concern.

---

## Pinia

```ts
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  const users       = ref<User[]>([])
  const currentUser = ref<User | null>(null)

  const isAuthenticated = computed(() => currentUser.value !== null)

  async function fetchById(id: string): Promise<User> {
    const res = await fetch(`/api/users/${id}`)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const user: User = await res.json()
    const idx = users.value.findIndex(u => u.id === id)
    if (idx >= 0) users.value[idx] = user
    else users.value.push(user)
    return user
  }

  return { users, currentUser, isAuthenticated, fetchById }
})
```

```vue
<script setup>
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/stores/user'

const store = useUserStore()
// storeToRefs preserves reactivity when destructuring
const { currentUser, isAuthenticated } = storeToRefs(store)
</script>
```

---

## Vue Router

```ts
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: () => import('@/views/HomeView.vue') },
    {
      path: '/dashboard',
      component: () => import('@/views/DashboardView.vue'),
      meta: { requiresAuth: true },
    },
    { path: '/:pathMatch(.*)*', component: () => import('@/views/NotFoundView.vue') },
  ],
})

router.beforeEach(to => {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.isAuthenticated)
    return { path: '/login', query: { redirect: to.fullPath } }
})
```

Lazy-load every route component. Do not import view components statically in the router.

---

## Template Directives

```html
<!-- Conditional -->
<p v-if="show">Visible when true</p>
<p v-else-if="other">Alternative</p>
<p v-else>Fallback</p>

<!-- v-show toggles display:none — better for frequent toggling -->
<p v-show="visible">Toggles</p>

<!-- Loop — always key by stable unique id, never index -->
<li v-for="item in items" :key="item.id">{{ item.name }}</li>

<!-- Events and modifiers -->
<form @submit.prevent="onSubmit">
<button @click.stop="handleClick">

<!-- Two-way binding -->
<input v-model="query">
```

---

## v-model on Custom Components

```ts
// Parent: <MyInput v-model="value" />
// Component receives modelValue, emits update:modelValue

const props = defineProps<{ modelValue: string }>()
const emit  = defineEmits<{ 'update:modelValue': [value: string] }>()

const value = computed({
  get: () => props.modelValue,
  set: v  => emit('update:modelValue', v),
})
```

---

## Nuxt Patterns

```ts
// Auto-imported in Nuxt — no explicit import
const { data, status } = await useFetch('/api/posts', { lazy: true })
const config           = useRuntimeConfig()
const route            = useRoute()
const user             = useState('user', () => null)
```

```vue
<template>
  <div v-if="status === 'pending'">Loading…</div>
  <ul v-else>
    <li v-for="post in data" :key="post.id">{{ post.title }}</li>
  </ul>
</template>
```

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| Mutating props directly | Emit event or use v-model pattern |
| Destructuring store without `storeToRefs` | Use `storeToRefs` or `toRefs` |
| `v-for` without `:key`, or keyed by index | Key by stable unique id |
| Watching reactive object without `{ deep: true }` | Add `{ deep: true }` or watch specific property |
| `provide/inject` for global state | Use Pinia |
| Options API in new components | Use `<script setup>` |

---

## Project Context

Check AGENTS.md or local skill overlays for:
- Vue version (Vue 3 assumed unless stated otherwise) and whether Nuxt is in use
- State management approach (Pinia assumed; flag if Vuex)
- UI component library (Vuetify, PrimeVue, Quasar, shadcn-vue, custom)
- API base URL and whether a global fetch wrapper / interceptor is already in place
