import 'package:flutter/material.dart';
import 'package:socialnetwork/screens/listchatscreen.dart';
import 'package:socialnetwork/utils/usercurrent.dart';
import 'package:socialnetwork/widgets/widget_textstyle.dart';

class UserChatItem extends StatefulWidget {
  const UserChatItem({super.key});

  @override
  State<UserChatItem> createState() => _UserChatItemState();
}

class _UserChatItemState extends State<UserChatItem> {
  UserCurrent userCurrent = UserCurrent();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Thực hiện hành động khi nhấn vào item (chuyển sang màn hình chat)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListChatScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                userCurrent.imageUrl, // Link hình đại diện
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: ,
                children: [
                  Text(
                    'Alina Versein',
                    style: MyTextstyle.textMedium_,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ' Mai mấy giờ họp vậy sếp? Mai mấy giờ họp vậy sếp?',
                    style: MyTextstyle.textSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '10:30 AM', // Hoặc trạng thái "Đang gõ..."
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
