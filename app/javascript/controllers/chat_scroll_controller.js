import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      const messagesContainer = this.messagesTarget
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
  }

  // 新しいメッセージが追加された時に自動スクロール
  messageAdded() {
    setTimeout(() => {
      this.scrollToBottom()
    }, 100)
  }
} 