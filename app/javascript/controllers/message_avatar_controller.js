import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["avatar"]

  connect() {
    this.fixAvatarUrl()
  }

  fixAvatarUrl() {
    if (this.hasAvatarTarget && this.avatarTarget.src && this.avatarTarget.src.includes('example.org')) {
      // example.orgの部分だけを現在のホストに置換
      this.avatarTarget.src = this.avatarTarget.src.replace('example.org', window.location.host)
    }
  }
} 