import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      const messagesContainer = this.messagesTarget
      // 背景画像の拡大を防ぐため、スクロール位置を固定
      const currentScrollTop = messagesContainer.scrollTop
      const scrollHeight = messagesContainer.scrollHeight
      const clientHeight = messagesContainer.clientHeight
      
      // スクロールが必要な場合のみ実行
      if (scrollHeight > clientHeight) {
        requestAnimationFrame(() => {
          messagesContainer.scrollTop = scrollHeight - clientHeight
        })
      }
    }
  }

  // 新しいメッセージが追加された時に自動スクロール
  messageAdded() {
    // 背景画像の拡大を防ぐため、より安定したスクロール処理
    setTimeout(() => {
      this.scrollToBottom()
    }, 50)
  }
} 