import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socialnetwork/components/custom_future_builder.dart';
import 'package:socialnetwork/components/round_image.dart';
import 'package:socialnetwork/components/user_chat_item.dart';
import 'package:socialnetwork/models/chat_user.dart';
import 'package:socialnetwork/screens/messagescreen.dart';
import 'package:socialnetwork/services/message_service.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Map<String, dynamic>? infoUser = {};
  late Future<List<ChatUser>> chatUsersFuture;

  @override
  void initState() {
    super.initState();
    getInfoUserCurrent();
    chatUsersFuture = MessageService().listChatUser();
  }

  void getInfoUserCurrent() async {
    final response = await GetToken().getUserCurrent();
    setState(() {
      infoUser = response;
    });
  }

  void refreshChatList() {
    setState(() {
      chatUsersFuture = MessageService().listChatUser();
    });
  }

  void navigateToChat(BuildContext context, int idUser) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageScreen(idUser: idUser)),
    );
    refreshChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              RoundImage(
                image: infoUser!['avatar'],
                size: 40,
              ),
              SizedBox(width: 10),
              Text(
                infoUser!['username'] ?? '',
                style: MyTextStyle.textMedium(context),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomFutureBuilder(
            future: chatUsersFuture,
            itemBuilder: (list) => UserChatItem(
                user: list,
                onTap: () {
                  navigateToChat(context, list.idUser);
                })));
  }
}
