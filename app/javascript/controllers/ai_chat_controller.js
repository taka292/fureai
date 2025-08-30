import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "messages", "input", "submitButton"]
  static values = { 
    chatId: Number,
    aiCharacterName: String,
    aiCharacterAvatarUrl: String
  }

  connect() {
    this.isProcessing = false
  }

  async sendMessage(event) {
    event.preventDefault()
    
    if (this.isProcessing) return
    
    const content = this.inputTarget.value.trim()
    if (!content) return

    this.isProcessing = true
    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.textContent = "送信中..."

    try {
      // 1. ユーザーメッセージを作成・表示
      await this.createUserMessage(content)
      
      // 2. AIレスポンスを取得・表示
      await this.getAiResponse(content)
      
    } catch (error) {
      this.showError("メッセージの送信に失敗しました")
    } finally {
      this.isProcessing = false
      this.submitButtonTarget.disabled = false
      this.submitButtonTarget.textContent = "送信"
      this.inputTarget.value = ""
    }
  }

  async createUserMessage(content) {
    const requestBody = { message: { content } }
    
    const response = await fetch(`/chats/${this.chatIdValue}/messages`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify(requestBody)
    })

    if (!response.ok) {
      const errorText = await response.text()
      throw new Error(`Failed to create user message: ${response.status} ${errorText}`)
    }

    const data = await response.json()
    this.appendMessage(data.html, 'user')
  }

  async getAiResponse(userContent) {
    // AIメッセージのプレースホルダーを作成
    const aiMessageId = `ai-message-${Date.now()}`
    
    // AIキャラクターのアバター画像を使用
    let avatarHtml = ''
    if (this.aiCharacterAvatarUrlValue) {
      avatarHtml = `<img src="${this.aiCharacterAvatarUrlValue}" class="w-10 h-10 rounded-full object-cover" alt="${this.aiCharacterNameValue}">`
    } else {
      avatarHtml = `
        <div class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center">
          <span class="material-symbols-outlined text-gray-400 text-sm">person</span>
        </div>
      `
    }
    
    this.appendMessage(`
      <div id="${aiMessageId}" class="flex items-start space-x-3 mb-4">
        <div class="flex-shrink-0">
          ${avatarHtml}
        </div>
        <div class="bg-gray-200 text-gray-800 rounded-2xl px-4 py-2 max-w-xs md:max-w-lg break-words shadow relative">
          <div class="typing-indicator">
            <span></span><span></span><span></span>
          </div>
        </div>
      </div>
    `, 'ai')

    try {
      // サーバーサイドのAPIを呼び出し
      const response = await fetch('/api/ai_response', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          chat_id: this.chatIdValue,
          content: userContent
        })
      })

      if (!response.ok) {
        throw new Error('Failed to get AI response')
      }

      const data = await response.json()
      
      // AIメッセージを更新
      this.updateAiMessage(aiMessageId, data.content)
      
      // データベースに保存
      await this.saveAiMessage(data.content)
      
    } catch (error) {
      this.updateAiMessage(aiMessageId, "申し訳ございません。エラーが発生しました。")
    }
  }

  async saveAiMessage(content) {
    await fetch(`/chats/${this.chatIdValue}/ai_messages`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ message: { content } })
    })
  }

  appendMessage(html, type) {
    this.messagesTarget.insertAdjacentHTML('beforeend', html)
    this.scrollToBottom()
  }

  updateAiMessage(messageId, content) {
    const messageElement = document.getElementById(messageId)
    if (messageElement) {
      const contentElement = messageElement.querySelector('.bg-gray-200')
      if (contentElement) {
        contentElement.innerHTML = content.replace(/\n/g, '<br>')
      }
    }
    this.scrollToBottom()
  }

  scrollToBottom() {
    setTimeout(() => {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }, 100)
  }

  showError(message) {
    console.error(message)
  }
}
