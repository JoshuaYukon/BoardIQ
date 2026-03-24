import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["result", "button"]
  static values  = { url: String, params: Object }

  async request(event) {
    const btn = event.currentTarget
    const originalText = btn.textContent
    btn.textContent = "Thinking..."
    btn.disabled = true

    const extraParams = btn.dataset.params ? JSON.parse(btn.dataset.params) : {}

    // For generate_description, auto-pull title from the issue form
    if (btn.dataset.url && btn.dataset.url.includes("generate_description")) {
      const titleField = document.querySelector("#issue_title")
      if (titleField) extraParams.title = titleField.value
    }

    try {
      const response = await fetch(btn.dataset.url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify(extraParams)
      })
      const data = await response.json()
      this.resultTarget.textContent = data.result
      this.resultTarget.closest(".ai-panel").style.display = "block"
    } catch (e) {
      this.resultTarget.textContent = "Request failed. Please try again."
    } finally {
      btn.textContent = originalText
      btn.disabled = false
    }
  }
}
