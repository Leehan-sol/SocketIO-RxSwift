 const express = require('express'); 
 const socket = require('socket.io');
 const ChatList = require('./ChatList');
// Express 애플리케이션 생성
const app = express();
// 포트설정 (환경 변수에 PORT가 설정되어 있으면 그 값을 사용하고, 아니면 3000번 포트 사용)
var PORT = process.env.PORT || 3001;
const server = app.listen(PORT); 
// Socket.IO 서버를 생성하고 Express 서버에 연결
const socketIO = socket(server);

// chatList
const chatLists = [];

function sendChatList() {
  const response = chatLists.map(list => ({
    roomName: list.roomName,
    headCount: Number(list.headCount) 
  }));
  const jsonResponse = JSON.stringify(response);
  socketIO.emit('addChatList', jsonResponse);
}

function increaseHeadCount(roomName) {
  for (let chat of chatLists) {
    if (chat.roomName === roomName) {
      chat.headCount = Number(chat.headCount) + 1;
      console.log('인원수 증가', chatLists);
      sendChatList(); 
      break;
    }
  }
}

function decreaseHeadCount(roomName) {
  for (let i = 0; i < chatLists.length; i++) {
    if (chatLists[i].roomName === roomName) {
      chatLists[i].headCount = Math.max(Number(chatLists[i].headCount) - 1, 0);
      console.log('인원수 감소', chatLists);
      
      if (chatLists[i].headCount === 0) {
        chatLists.splice(i, 1); // 인원수가 0이면 해당 룸을 삭제
      }
      
      sendChatList(); 
      break;
    }
  }
}


// 소켓 수신 관련 
socketIO.on('connection', (socket) => {
  console.log("New socket connection: " + socket.id);
  
  sendChatList();

  // 'addChatList' 수신
  socket.on('addChatList', (data) => {
    const { roomName, headCount } = data;
    chatLists.push(new ChatList(roomName, Number(headCount)));
    console.log(chatLists);
    sendChatList();
  });

  // 'connectRoom' 수신
  socket.on('connectRoom', (data) => {
    const { roomName, userNickname } = data;
    socket.join(roomName);
    increaseHeadCount(roomName);
    socketIO.to(roomName).emit('connectRoom', { sender: userNickname });           
  });

   // 'disconnectRoom' 수신
   socket.on('disconnectRoom', (data) => {
    const { roomName, userNickname } = data;
    socket.leave(roomName);
    decreaseHeadCount(roomName);
    socketIO.to(roomName).emit('disconnectRoom', { sender: userNickname });    
  });


  // 'sendMessage' 수신
  socket.on('sendMessage', (data) => {
    const { roomName, text, userNickname } = data; 
    console.log(roomName, text);
    socketIO.to(roomName).emit('sendMessage', { text: text, sender: userNickname });
  });


    
});