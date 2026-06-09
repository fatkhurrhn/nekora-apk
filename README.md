# 🐱 Nekora - Social Media for Cats

Nekora is a social media platform designed specifically for cat lovers. Share photos, videos, and moments of your furry friends, discover other cats, and build a community of cat enthusiasts.

## ✨ Features

### 🔐 Authentication
- Email/Password registration and login
- Username or email login support
- Auto-login with SharedPreferences
- Secure Firebase Authentication

### 👤 User Profile
- Custom profile with photo upload (Cloudinary integration)
- Edit profile: full name, username, bio, and profile picture
- Followers and following system
- Post count tracking

### 🔍 Explore & Search
- Advanced search by username or full name
- Real-time search with debounce
- Partial matching and relevance sorting
- Highlighted search results
- User recommendations

### 🔔 Notifications
- Real-time notifications for new followers
- Unread notification badge
- Mark notifications as read

### 🎨 Design System
- Premium dark mode UI
- Glassmorphism effects
- JetBrains Mono typography
- Smooth animations and transitions
- Responsive layout

### 📱 Navigation
- Bottom navigation bar with 5 tabs:
  - **Home** – Feed posts (coming soon)
  - **Explore** – Discover users
  - **Create** – Upload posts (coming soon)
  - **Reels** – Short videos (coming soon)
  - **Profile** – User profile

## 🛠 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Frontend framework |
| **Firebase Auth** | User authentication |
| **Firestore** | Real-time database |
| **Cloudinary** | Image upload & storage |
| **SharedPreferences** | Local storage for session |
| **HTTP** | API calls |
| **Image Picker** | Gallery access |

## 📱 Requirements

- Flutter SDK ^3.6.2
- Dart SDK ^3.6.2
- Android Studio / VS Code
- Android device with minimum SDK 23 (Android 6.0)

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/fatkhurrhn/nekora-apk.git
cd nekora