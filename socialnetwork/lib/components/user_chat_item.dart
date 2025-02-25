import 'package:flutter/material.dart';
import 'package:socialnetwork/components/round_image.dart';
import 'package:socialnetwork/models/chat_user.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class UserChatItem extends StatefulWidget {
  final ChatUser user;
  final VoidCallback onTap;
  const UserChatItem({super.key, required this.user, required this.onTap});

  @override
  State<UserChatItem> createState() => _UserChatItemState();
}

class _UserChatItemState extends State<UserChatItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      leading: RoundImage(image: widget.user.avatar),
      title: Text(
        MyTextStyle().toChangeVN(widget.user.fullname),
        style: MyTextStyle.textMedium_(context),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              widget.user.lastMessage.image != null
                  ? 'Đã gửi 1 hình ảnh'
                  : widget.user.lastMessage.content,
              style: MyTextStyle.textSmall(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            MyTextStyle().getTimeAgo(widget.user.lastMessage.createdAt),
            style: MyTextStyle.textSmallGrey,
          ),
        ],
      ),
    );
  }
}
