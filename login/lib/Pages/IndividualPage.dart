import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import '../Member/ChatMessage.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({
    required this.user1,
    required this.user2,
    required this.roomId,
    super.key,
  });
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
      'msgType': message.msgType.toString().split('.').last,
    };

    final String jsonMessage = jsonEncode(messageData);

    stompClient.send(
      destination: '/pub/chat/message',
      body: jsonMessage,
    );
  }
}

class _IndividualPageState extends State<IndividualPage> {
  SocketHandler socketHandler = SocketHandler();
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> chatMessages = [];
  List<ChatMessage> lastchatMessages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initSocketConnection();
    fetchChatMessages();
  }

  void _showHateDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('경고'),
            content: Text('혐오발언이 감지되었습니다.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

  //stomp socket 연결하기
  void _initSocketConnection() {
    socketHandler.stompClient = StompClient(
      config: StompConfig(
        url: 'wss://46d1-175-118-225-161.ngrok-free.app/ws-stomp',
        onConnect: (StompFrame connectFrame) {
          print("Connected to WebSocket server!");
          socketHandler.stompClient.subscribe(
            destination: '/sub/chat/room/${widget.roomId}',
            headers: {},
            callback: (frame) {
              if (mounted) {
                setState(() {
                  try {
                    Map<String, dynamic> messageData = json.decode(frame.body!);
                    ChatMessage receivedMessage =
                        ChatMessage.fromJson(messageData);
                    if (receivedMessage.msgType == MessageType.HATE&&receivedMessage.receiver != widget.user1.toString()) {
                      _showHateDialog();
                    }
                    chatMessages.add(receivedMessage);
                  } catch (e, stackTrace) {
                    print('error: $e');
                    print('stack trace: $stackTrace');
                  }
                });
              }
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

  //과거 채팅내역 fetch
  void fetchChatMessages() async {
    final response = await http.get(
      Uri.parse('https://46d1-175-118-225-161.ngrok-free.app/message/find/${widget.roomId}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      List<ChatMessage> messages =
          responseData.map((data) => ChatMessage.fromJson(data)).toList();

      setState(() {
        lastchatMessages = messages;
      });

      print(
          'Index 0: ${lastchatMessages.length > 0 ? lastchatMessages[0].content : 'No message'}');
      print(
          'Index 1: ${lastchatMessages.length > 1 ? lastchatMessages[1].content : 'No message'}');
      print(
          'Index 2: ${lastchatMessages.length > 2 ? lastchatMessages[2].content : 'No message'}');
      print(
          'Index 3: ${lastchatMessages.length > 3 ? lastchatMessages[3].content : 'No message'}');
    } else {
      print('오류 발생: ${response.statusCode}');
    }
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
      msgType: MessageType.TALK,
    );
    socketHandler.sendChatMessage(message);
    print('Sent MessageType: ${message.msgType}');
  }

 

//채팅메세지UI 위젯
  Widget _buildMessageWidget(ChatMessage message) {
    bool isSentByUser = message.sender == widget.user1.toString();
    final String formattedDate = message.createdAt;
    return FutureBuilder<String>(
      
      builder: (context, snapshot) {
        String senderName = snapshot.data ?? '';
        Color backgroundColor = message.msgType == MessageType.HATE
            ? Colors.red
            : const Color(0xFF51C878);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          alignment:
              isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSentByUser)
                Text(
                  senderName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundColor,
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
      },
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
                border: OutlineInputBorder(
                   borderRadius : const BorderRadius.all(Radius.circular(30))
                ),
                hintText: '메시지를 입력하세요',
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send,color:const Color(0xFF51C878)),
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

  @override
  Widget build(BuildContext context) {
    double calculateScrollThreshold(BuildContext context) {
      return MediaQuery.of(context).size.height * 0.9;
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (lastchatMessages.length + chatMessages.length >
          calculateScrollThreshold(context)) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 222, 226),
      appBar: AppBar(
        backgroundColor: const Color(0xFF51C878),
        leadingWidth: 70,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              SizedBox(width: 10),
              Icon(
                Icons.arrow_back_ios_new,
                size: 24,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: lastchatMessages.length + chatMessages.length,
              itemBuilder: (context, index) {
                if (index < lastchatMessages.length) {
                  final message = lastchatMessages[index];
                  return _buildMessageWidget(message);
                } else {
                  final message = chatMessages[index - lastchatMessages.length];
                  return _buildMessageWidget(message);
                }
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }
}
