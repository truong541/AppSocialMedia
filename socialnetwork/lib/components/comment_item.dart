import 'package:flutter/material.dart';
import 'package:socialnetwork/components/custom_icon.dart';
import 'package:socialnetwork/services/comment_like_service.dart';
import 'package:socialnetwork/widgets/mytext.dart';
import 'package:translator/translator.dart';

class CommentItem extends StatefulWidget {
  final Map<String, dynamic> comment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReply;
  const CommentItem(
      {super.key,
      required this.comment,
      required this.onEdit,
      required this.onDelete,
      required this.onReply});
  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isTranslate = false;
  bool isAuthor = false;
  String comment = '';
  String translateComment = '';
  int likeCount = 0;
  String status = '';
  late LikeWebSocketService likeWebSocketService;

  @override
  void initState() {
    super.initState();
    initWebSocket();
    statusLikeByUser();
    loadLikeCount();
    isAuthor = widget.comment['isAuthor'];
    comment = widget.comment['content'];
  }

  Future<void> loadLikeCount() async {
    final count =
        await CommentLikeService().getLikeCount(widget.comment['idComment']);
    setState(() {
      likeCount = count;
    });
  }

  void initWebSocket() {
    likeWebSocketService = LikeWebSocketService(widget.comment['idComment']);
    likeWebSocketService.listenForUpdates((likeCount) {
      setState(() {
        likeCount = likeCount;
      });
    });
  }

  Future<void> statusLikeByUser() async {
    final response = await CommentLikeService()
        .statusLikeByUser(widget.comment['idComment']);
    setState(() {
      status = response;
    });
  }

  @override
  void dispose() {
    likeWebSocketService.close();
    super.dispose();
  }

  void translateText() async {
    var translator = GoogleTranslator();
    var translation = await translator.translate(comment, to: 'vi');
    setState(() {
      if (isTranslate) {
        translateComment = translation.toString();
      }
      isTranslate = !isTranslate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showBottomSheet(context, widget.comment['idComment']),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.network(
              'https://i.otakul.com/7738/Mo-hinh-Smoker-One-Piece-2%281%29.jpg',
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.comment['user']['username'],
                      style: MyTextStyle.textSmall_(context),
                    ),
                    SizedBox(width: 5),
                    Text(
                      MyTextStyle().getTimeAgo(widget.comment['createdAt']),
                      style: MyTextStyle.textSmallGrey,
                    ),
                    isAuthor
                        ? Container(
                            margin: EdgeInsets.all(5),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Color(0xff888888),
                            ),
                          )
                        : null,
                    // widget.comment['isAuthor'] ??
                    isAuthor
                        ? Text(
                            'Author',
                            style: MyTextStyle.textSmallGrey,
                          )
                        : null,
                  ].whereType<Widget>().toList(),
                ),
                SizedBox(height: 8),
                //Nội dung bình luận
                Text(
                  MyTextStyle()
                      .toChangeVN(isTranslate ? translateComment : comment),
                  style: MyTextStyle.textSmall(context),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      // onTap: () {
                      //   CommentScreen.commentScreenKey.currentState
                      //       ?.focusOnTextField();
                      // },
                      onTap: widget.onReply,
                      child: Text(
                        'Reply',
                        style: MyTextStyle.textSmallGrey,
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: translateText,
                      child: Text(
                        isTranslate ? 'View original' : 'View translation',
                        style: MyTextStyle.textSmallGrey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 50),
          Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    await CommentLikeService()
                        .likeComment(widget.comment['idComment']);
                  },
                  child: status == 'true'
                      ? Image.asset(
                          'assets/icon/liked.png',
                          width: 18,
                        )
                      : CustomIcon(
                          icon: 'like.png',
                          width: 18,
                          isDefaultColor: true,
                        )),
              SizedBox(height: 5),
              Text(
                likeCount.toString(),
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, int idComment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép kéo xuống để tắt
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4, // Chiều cao ban đầu (30% màn hình)
          minChildSize: 0.2, // Chiều cao tối thiểu
          maxChildSize: 0.6, // Chiều cao tối đa khi mở rộng
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Image.asset(
                      'assets/icon/like.png',
                      width: 30,
                      height: 30,
                    ),
                    title: Text(
                      'Thích bài viết này',
                      style: MyTextStyle.textLarge(context),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/icon/follow-user.png',
                      width: 30,
                      height: 30,
                    ),
                    title: Text(
                      'Follow user',
                      style: MyTextStyle.textLarge(context),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/icon/edit-comment.png',
                      width: 30,
                      height: 30,
                    ),
                    title: Text(
                      'Edit Comment',
                      style: MyTextStyle.textLarge(context),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onEdit();
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/icon/delete-comment.png',
                      width: 30,
                      height: 30,
                    ),
                    title: Text(
                      'Delete Comment',
                      style: MyTextStyle.textLarge(context),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onDelete();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
