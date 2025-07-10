import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["avatar"]

  connect() {
    this.fixAvatarUrl()
  }

  fixAvatarUrl() {
    this.avatarTargets.forEach(avatar => {
      if (avatar.src && avatar.src.includes('example.org')) {
        avatar.src = avatar.src.replace('http://example.org', window.location.origin)
      }
    })
  }
} 