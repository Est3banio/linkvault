import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "readButton", "unreadButton"]
  
  connect() {
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }
  
  disconnect() {
    this.element.removeEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }
  
  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.animateSuccess()
    }
  }
  
  markAsRead(event) {
    event.preventDefault()
    this.animateReadStatus(true)
    
    const form = event.currentTarget.closest('form')
    if (form) {
      form.requestSubmit()
    }
  }
  
  markAsUnread(event) {
    event.preventDefault()
    this.animateReadStatus(false)
    
    const form = event.currentTarget.closest('form')
    if (form) {
      form.requestSubmit()
    }
  }
  
  animateReadStatus(isRead) {
    if (this.hasCardTarget) {
      if (isRead) {
        this.cardTarget.classList.add('transition-all', 'duration-300', 'ease-in-out')
        this.cardTarget.style.transform = 'scale(0.98)'
        this.cardTarget.style.opacity = '0.75'
        
        setTimeout(() => {
          this.cardTarget.style.transform = ''
          this.cardTarget.style.opacity = ''
          this.cardTarget.classList.add('bg-[#313244]/60')
        }, 300)
      } else {
        this.cardTarget.classList.add('transition-all', 'duration-300', 'ease-in-out')
        this.cardTarget.style.transform = 'scale(1.02)'
        
        setTimeout(() => {
          this.cardTarget.style.transform = ''
          this.cardTarget.classList.remove('bg-[#313244]/60')
        }, 300)
      }
    }
  }
  
  animateSuccess() {
    if (this.hasCardTarget) {
      this.cardTarget.classList.add('transition-all', 'duration-500', 'ease-out')
      this.cardTarget.classList.add('ring-2', 'ring-[#a6e3a1]', 'ring-opacity-50')
      
      setTimeout(() => {
        this.cardTarget.classList.remove('ring-2', 'ring-[#a6e3a1]', 'ring-opacity-50')
      }, 1000)
    }
  }
  
  animateDelete(event) {
    event.preventDefault()
    
    if (this.hasCardTarget) {
      this.cardTarget.classList.add('transition-all', 'duration-300', 'ease-in-out')
      this.cardTarget.style.opacity = '0'
      this.cardTarget.style.transform = 'scale(0.95) translateX(100%)'
      
      setTimeout(() => {
        const form = event.currentTarget.closest('form')
        if (form) {
          form.requestSubmit()
        }
      }, 300)
    }
  }
}