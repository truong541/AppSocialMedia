import 'package:flutter/material.dart';
import 'package:socialnetwork/components/user_chat_item.dart';
import 'package:socialnetwork/utils/usercurrent.dart';
import 'package:socialnetwork/widgets/widget_textstyle.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserCurrent userCurrent = UserCurrent();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                userCurrent.imageUrl, // Link hình đại diện
              ),
            ),
            SizedBox(width: 10),
            Text(
              userCurrent.displayName,
              style: MyTextstyle.textMedium,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Xử lý khi người dùng nhấn nút thông báo
            },
          ),
        ],
      ),
      body: Column(
        children: [
          UserChatItem(),
          UserChatItem(),
          UserChatItem(),
          UserChatItem(),
          UserChatItem(),
          UserChatItem(),
        ],
      ),
    );
  }
}
