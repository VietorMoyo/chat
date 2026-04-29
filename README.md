# Real-Time Translation Chat App

A "WeChat-style" real-time messaging application with on-the-fly server-side translation. Users can chat in different languages, and the app automatically translates messages based on the recipient's preferred language.

## 🚀 Features

- **Real-Time Messaging**: Powered by Socket.io for instantaneous communication.
- **Server-Side Translation**: Uses the MyMemory API to translate messages before they are delivered to the recipient.
- **"WeChat Style" UI**:
  - Receiver sees the translated text by default.
  - Sender sees the original text by default.
  - **Double-tap** a message bubble to toggle between the original and translated versions.
- **Optimistic UI**: Messages appear instantly in the sender's view while being processed by the server.
- **Multi-Language Support**: Choose your language and the target language via dynamic dropdowns.
- **Robust Backend**: Built with Node.js and PostgreSQL (3NF schema).

## 🛠️ Tech Stack

- **Frontend**: Flutter (Provider for State Management)
- **Backend**: Node.js, Express, Socket.io
- **Database**: PostgreSQL (Dockerized)
- **Translation**: MyMemory API

## 📋 Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org/)
- [Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/)

## ⚙️ Setup Instructions

### 1. Database (Docker)
Start the PostgreSQL container:
```bash
docker-compose up -d
```

### 2. Backend Server
Navigate to the server directory and start the Node.js server:
```bash
cd server
npm install
npm start
```

### 3. Flutter Client
Navigate to the client directory and run the app:
```bash
cd client
flutter pub get
flutter run
```

## 🧪 Testing Two-Way Communication

1. Open two instances of the app (or two browser tabs if running on web).
2. Login as **User A** in one and **User B** in the other.
3. Select your language (e.g., English) and the target language (e.g., Zulu).
4. Send a message and watch it translate in real-time on the other side!

## 📄 License
This project is for educational purposes.
