import 'package:flutter/material.dart';

class MessageItem extends StatefulWidget {
  final Map<String, dynamic> message;
  final int idUser;
  const MessageItem({super.key, required this.message, required this.idUser});

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    bool isMe = widget.message['receiver'] == widget.idUser;
    bool isImage =
        widget.message['image'] != null && widget.message['image']!.isNotEmpty;
    return ListTile(
      title: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: isImage
            ? Image.network(
                widget.message['image']!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMe ? Color(0xffffffff) : Color(0xffcccccc),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.message['content'],
                  style: TextStyle(fontSize: 16, color: Color(0xff000000)),
                ),
              ),
      ),
    );
  }
}
