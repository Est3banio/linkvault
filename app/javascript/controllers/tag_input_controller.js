import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    this.updatePreview()
  }

  updatePreview() {
    const inputValue = this.inputTarget.value.trim()
    if (!inputValue) {
      this.previewTarget.innerHTML = ""
      return
    }

    const tags = inputValue.split(",").map(tag => tag.trim()).filter(tag => tag.length > 0)
    
    const tagPills = tags.map(tag => {
      return `<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-[#89b4fa]/20 text-[#89b4fa] border border-[#89b4fa]/30 mr-2 mb-2">
        <span class="text-sm mr-1">🏷️</span>
        ${this.escapeHtml(tag)}
      </span>`
    }).join("")

    this.previewTarget.innerHTML = tagPills
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}