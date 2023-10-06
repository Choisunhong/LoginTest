import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:intl/intl.dart';

import '../Member/ChatMessage.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage(
      {required this.user1,
      required this.user2,
      required this.roomId,
      super.key});
  final int user1;
  final int user2;
  final Object roomId;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class SocketHandler {
  late StompClient stompClient;

  Future<void> sendChatMessage(ChatMessage message) async {
    final Map<String, dynamic> messageData = {
      'id': message.id,
      'content': message.content,
      'roomId': message.roomId,
      'sender': message.sender,
      'receiver': message.receiver,
      'create_at': message.createdAt,
      'msgType': message.messageType.value,
    };

    final String jsonMessage = jsonEncode(messageData);

    stompClient.send(
      destination: '/pub/chat/message',
      body: jsonMessage,
    );
  }
}

//사용자가 그방에있을떄
class _IndividualPageState extends State<IndividualPage> {
  SocketHandler socketHandler = SocketHandler();
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> chatMessages = [];

  void initState() {
    super.initState();
    _initSocketConnection();
  }

  void _initSocketConnection() {
    socketHandler.stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/ws-stomp',
        onConnect: (StompFrame connectFrame) {
          print("Connected to WebSocket server!");
          socketHandler.stompClient.subscribe(
            destination: '/sub/chat/room/${widget.roomId}',
            headers: {},
            callback: (frame) {
              print('Received frame1: ${frame.body}');
              print('Received frame2: ${widget.roomId}');
              print('Received frame3: ${widget.user1}');
              print('Received frame4: ${widget.user2}');
              setState(() {
                    try { 
                    Map<String, dynamic> messageData = json.decode(frame.body!);
                    ChatMessage receivedMessage = ChatMessage.fromJson(messageData);
                    print('Received message: $receivedMessage');
                    chatMessages.add(receivedMessage);
                      } catch (e,stackTrace) {
                      print('error: $e');
                      print('stack trace: $stackTrace');
                    }
              });
            },
          );
        },
        webSocketConnectHeaders: {
          "transports": ["websocket"],
        },
      ),
    );
    socketHandler.stompClient.activate();
  }

  void _sendMessage(String content) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    ChatMessage message = ChatMessage(
      id: 0,
      content: content,
      roomId: widget.roomId.toString(),
      sender: widget.user1.toString(),
      receiver: widget.user2.toString(),
      createdAt: formattedDate.toString(),
      messageType: MessageType.TALK,
    );

    socketHandler.sendChatMessage(message);
  }

  Widget _buildMessageWidget(ChatMessage message) {
    bool isSentByUser = message.sender == widget.user1.toString();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.sender,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSentByUser ? Colors.lightGreen : Colors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '메시지를 입력하세요',
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final content = messageController.text;
              if (content.isNotEmpty) {
                _sendMessage(content);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 222, 226),
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        leadingWidth: 70,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                return _buildMessageWidget(message);
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }
}
