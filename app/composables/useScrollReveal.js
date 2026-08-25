import { onMounted, onUnmounted } from 'vue'

export function useScrollReveal() {
  let observer = null

  onMounted(() => {
    observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible')
        }
      })
    }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' })

    document.querySelectorAll('.reveal, .reveal-stagger').forEach(el => {
      observer.observe(el)
    })
  })

  onUnmounted(() => {
    if (observer) observer.disconnect()
  })
}
