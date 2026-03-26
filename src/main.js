import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import { useJourneyStore } from './stores/journey'

import './styles/tokens.css'
import './styles/base.css'
import './styles/typography.css'
import './styles/animations.css'
import './styles/mobile.css'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)

// Hydrate store from localStorage on startup
const journey = useJourneyStore()
journey.hydrate()
journey.recordVisit()

app.mount('#app')
