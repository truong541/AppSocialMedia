import 'package:flutter/material.dart';
import 'package:socialnetwork/components/button.dart';
import 'package:socialnetwork/components/round_image.dart';
import 'package:socialnetwork/models/user.dart';
import 'package:socialnetwork/services/follow_service.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class UserFollowItem extends StatefulWidget {
  final UserModel? users;
  const UserFollowItem({super.key, required this.users});

  @override
  State<UserFollowItem> createState() => _UserFollowItemState();
}

class _UserFollowItemState extends State<UserFollowItem> {
  bool isFollowStatus = false;

  @override
  void initState() {
    super.initState();
    handleFollowStatus();
  }

  void handleFollowStatus() async {
    bool isResponse =
        await FollowService().followStatus(widget.users?.idUser ?? 0);
    setState(() {
      isFollowStatus = isResponse;
    });
  }

  void handleFollow() async {
    setState(() {
      isFollowStatus = !isFollowStatus; // Đổi ngay UI để có hiệu ứng
    });
    bool success = await FollowService().followUser(widget.users?.idUser ?? 0);
    if (success) {
      // Sau khi follow/unfollow thành công, lấy lại trạng thái từ API
      bool newStatus =
          await FollowService().followStatus(widget.users?.idUser ?? 0);
      setState(() {
        isFollowStatus = newStatus;
      });
    } else {
      print("Lỗi khi follow/unfollow");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('hello');
      },
      child: Container(
        width: 160,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xff222222),
        ),
        child: Column(
          children: [
            RoundImage(
              image: widget.users?.avatar,
              size: 90,
            ),
            SizedBox(height: 8),
            Text(
              MyTextStyle().toChangeVN(widget.users?.fullname ?? ''),
              style: MyTextStyle.textMedium(context),
            ),
            SizedBox(height: 15),
            ButtonNormal(
              onTapped: handleFollow,
              text: isFollowStatus ? "Followed" : "Follow",
              textColor: Color(0xffffffff),
              bgColor: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}
