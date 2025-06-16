import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 4000 } }

  connect() {
    this.element.style.opacity = "0"
    
    // Animate in
    requestAnimationFrame(() => {
      this.element.style.transition = "opacity 0.4s ease-out"
      this.element.style.opacity = "1"
      
      // Add a subtle pulse animation for success messages
      const innerDiv = this.element.querySelector('.bg-\\[\\#a6e3a1\\]\\/10')
      if (innerDiv) {
        innerDiv.style.animation = "pulse 1s ease-in-out"
      }
    })

    // Auto dismiss
    this.timeoutId = setTimeout(() => {
      this.dismiss()
    }, this.timeoutValue)
  }

  dismiss() {
    this.element.style.transition = "opacity 0.3s ease-in"
    this.element.style.opacity = "0"
    
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 300)
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }
}