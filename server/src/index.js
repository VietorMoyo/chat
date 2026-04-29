const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const db = require('./db');
const { translateText } = require('./translate');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

const PORT = process.env.PORT || 3000;

// Map to track userId -> socketId
const userSockets = new Map();

io.on('connection', (socket) => {
  console.log('A user connected:', socket.id);

  // When a user identifies themselves
  socket.on('identify', (userId) => {
    userSockets.set(userId, socket.id);
    console.log(`User ${userId} identified with socket ${socket.id}`);
  });

  socket.on('send_message', async (payload) => {
    console.log('Received message payload:', payload);
    const { senderId, receiverId, originalText, sourceLang, targetLang } = payload;

    try {
      // 1. Translation Check
      let translatedText;
      if (sourceLang === targetLang) {
        translatedText = originalText;
      } else {
        translatedText = await translateText(originalText, targetLang, sourceLang);
      }

      // 2. Database Persistence
      const query = `
        INSERT INTO messages (sender_id, receiver_id, original_text, translated_text, source_lang, target_lang)
        VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING *
      `;
      const values = [senderId, receiverId, originalText, translatedText, sourceLang, targetLang];
      const res = await db.query(query, values);
      const savedMessage = res.rows[0];

      // 3. Event: receive_message
      const receiverSocketId = userSockets.get(receiverId);
      if (receiverSocketId) {
        io.to(receiverSocketId).emit('receive_message', savedMessage);
      }

      // Also echo back to sender to confirm receipt/send
      socket.emit('message_sent', savedMessage);

    } catch (error) {
      console.error('Error handling send_message:', error);
      socket.emit('error', { message: 'Failed to send message' });
    }
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
    // Remove from map
    for (const [userId, socketId] of userSockets.entries()) {
      if (socketId === socket.id) {
        userSockets.delete(userId);
        break;
      }
    }
  });
});

server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
