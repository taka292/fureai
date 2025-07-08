import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initializeRatings()
  }

  initializeRatings() {
    this.setupRating("mental_state_icons", "mental_state_input", "mental")
    this.setupRating("physical_state_icons", "physical_state_input", "physical")
  }

  setupRating(containerId, inputId, type) {
    const container = document.getElementById(containerId)
    const input = document.getElementById(inputId)
    
    if (container && input) {
      container.addEventListener('click', (e) => {
        if (e.target.dataset.index !== undefined) {
          const index = parseInt(e.target.dataset.index)
          this.updateRating(container, input, index, type)
        }
      })
    }
  }

  updateRating(container, input, selectedIndex, type) {
    const icons = container.querySelectorAll('span')
    const states = ['very_bad', 'bad', 'normal', 'good', 'very_good']
    
    icons.forEach((icon, index) => {
      if (index <= selectedIndex) {
        icon.classList.remove('text-gray-300')
        icon.classList.add(type === 'mental' ? 'text-red-500' : 'text-yellow-500')
      } else {
        icon.classList.remove(type === 'mental' ? 'text-red-500' : 'text-yellow-500')
        icon.classList.add('text-gray-300')
      }
    })
    
    input.value = states[selectedIndex]
  }
} 