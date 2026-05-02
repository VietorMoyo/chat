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
- **Translation**: MyMemory API (Free)

## 📋 Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org/) (v16+)
- [Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/)

## ⚙️ Setup Instructions

### 1. Database (Docker)
Start the PostgreSQL container from the root directory:
```bash
docker-compose up -d
```
*Note: This automatically initializes the schema and seeds default users (User A & User B).*

### 2. Backend Server
1. Navigate to the server directory:
   ```bash
   cd server
   ```
2. Create a `.env` file in the `server/` folder:
   ```env
   PORT=3000
   DATABASE_URL=postgresql://chat_user:chat_password@localhost:5432/chat_db
   ```
3. Install dependencies and start the server:
   ```bash
   npm install
   npm run dev
   ```

### 3. Flutter Client
1. Navigate to the client directory:
   ```bash
   cd client
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```
   *Note: Ensure the backend URL in `lib/main.dart` matches your server address (default: `http://localhost:3000`).*

## 🧪 Testing Two-Way Communication

1. Open two instances of the app (or two browser tabs if running on web).
2. Login as **User A** in one and **User B** in the other.
3. Select your language (e.g., English) and the target language (e.g., Zulu).
4. Send a message and watch it translate in real-time on the other side!

## 📄 License
This project is for educational purposes.
