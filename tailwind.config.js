/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        base: '#F8FBF9',
        primary: '#A6DED3',
        primaryDark: '#76CBBF',
        card: '#F0F2F1',
        text: '#333333',
        textSub: '#666666',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('daisyui')
  ],
  daisyui: {
    themes: [
      {
        fureai: {
          "primary": "#A6DED3",
          "primary-focus": "#76CBBF",
          "primary-content": "#333333",
          "secondary": "#F0F2F1",
          "secondary-focus": "#E0E2E1",
          "secondary-content": "#333333",
          "accent": "#76CBBF",
          "accent-focus": "#5BB8A8",
          "accent-content": "#FFFFFF",
          "neutral": "#333333",
          "neutral-focus": "#1A1A1A",
          "neutral-content": "#FFFFFF",
          "base-100": "#F8FBF9",
          "base-200": "#F0F2F1",
          "base-300": "#E0E2E1",
          "base-content": "#333333",
          "info": "#3ABFF8",
          "success": "#36D399",
          "warning": "#FBBD23",
          "error": "#F87272",
        },
      },
    ],
  },
} 