import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialnetwork/components/message_item.dart';
import 'package:socialnetwork/services/message_service.dart';
import 'package:socialnetwork/utils/gettoken.dart';

class MessageScreen extends StatefulWidget {
  final int idUser;
  const MessageScreen({super.key, required this.idUser});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;
  final TextEditingController controller = TextEditingController();
  final MessageWebSocketService chatSocket = MessageWebSocketService();
  final FocusNode focusNode = FocusNode();
  List<dynamic> listChat = [];
  File? image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    listMessage();
    chatSocket.connect();
  }

  //hiện danh sách tin nhắn
  void listMessage() async {
    final response = await MessageService().getMessages(widget.idUser);
    setState(() {
      listChat = response;
    });
  }

  //Gửi tin nhắn bằng hình ảnh
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      sendMessage();
    }
  }

  //Gửi tin nhắn
  Future<void> sendMessage() async {
    await MessageService().createMessage(
        widget.idUser, {'content': controller.text.trim()},
        image: image);
    controller.clear();
  }

  //Xử lý khi hiển thị input text
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (keyboardVisible != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = keyboardVisible;
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    chatSocket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        // backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: chatSocket.messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  listChat.add(snapshot.data!);
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: listChat.length,
                  itemBuilder: (context, index) {
                    final message = listChat.reversed.toList()[index];
                    return MessageItem(
                      message: message,
                      idUser: widget.idUser,
                    );
                  },
                );
              },
            ),
          ),

          // Row chứa các button (ghi âm, máy ảnh, hình ảnh) và TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Các button (ghi âm, máy ảnh, hình ảnh)
                Visibility(
                  visible: !isKeyboardVisible, // Ẩn nếu bàn phím hiển thị
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: () {
                          // Thực hiện hành động ghi âm
                        },
                        color: Colors.orange,
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          pickImage(ImageSource.camera);
                        },
                        color: Colors.orange,
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),

                // TextField để nhập tin nhắn
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onSubmitted: (_) =>
                        sendMessage(), // Gửi tin nhắn khi nhấn Enter
                  ),
                ),

                // IconButton để gửi tin nhắn
                Visibility(
                  visible: isKeyboardVisible, // Ẩn nếu bàn phím hiển thị
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
