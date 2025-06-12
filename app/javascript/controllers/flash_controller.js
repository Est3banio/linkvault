import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 4000 } }

  connect() {
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(-20px) translateX(-50%)"
    
    // Animate in
    requestAnimationFrame(() => {
      this.element.style.transition = "all 0.4s ease-out"
      this.element.style.opacity = "1"
      this.element.style.transform = "translateY(0) translateX(-50%)"
    })

    // Auto dismiss
    this.timeoutId = setTimeout(() => {
      this.dismiss()
    }, this.timeoutValue)
  }

  dismiss() {
    this.element.style.transition = "all 0.3s ease-in"
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(-20px) translateX(-50%)"
    
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