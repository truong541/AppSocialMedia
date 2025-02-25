import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socialnetwork/components/function_post.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  // bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    List<Map<String, dynamic>> images =
        List<Map<String, dynamic>>.from(post['url']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  post['user']['avatar'],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  MyTextStyle().toChangeVN(post['user']['fullname']),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.more_vert),
            ],
          ),
        ),
        FunctionPost(
          idPost: post['idPost'],
          numberLike: post['like_count'],
          numberComment: post['comment_count'],
          isLiked: post['isLiked'],
          images: images,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: utf8.decode(post['content'].runes.toList()),
                  style: MyTextStyle.textMedium(context),
                ),
              ],
            ),
          ),
        ),
        // Time
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: Text(
            MyTextStyle().getTimeAgo(post['createdAt']),
            style: MyTextStyle.textSmallGrey,
          ),
        ),
      ],
    );
  }
}
