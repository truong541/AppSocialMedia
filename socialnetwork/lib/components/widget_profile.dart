import 'package:flutter/material.dart';
import 'package:socialnetwork/models/info_user.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class ListProfileCount extends StatelessWidget {
  final InfoUserModel? user;
  const ListProfileCount({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextProfileCount(
          count: user?.postsCount.toString() ?? " ",
          title: "Posts",
        ),
        TextProfileCount(
          count: user?.followingCount.toString() ?? " ",
          title: "Follower",
        ),
        TextProfileCount(
          count: user?.followersCount.toString() ?? " ",
          title: "Follwing",
        ),
      ],
    );
  }
}

class TextProfileCount extends StatelessWidget {
  final String count;
  final String title;
  const TextProfileCount({super.key, required this.count, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            MyTextStyle().formatNumber(count),
            style: MyTextStyle.textMedium_(context),
          ),
          Text(
            title,
            style: MyTextStyle.textSmall(context),
          ),
        ],
      ),
    );
  }
}
