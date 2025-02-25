import 'package:flutter/material.dart';
import 'package:socialnetwork/components/comment_item.dart';
import 'package:socialnetwork/components/create_comment.dart';
import 'package:socialnetwork/services/comment_service.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class CommentScreen extends StatefulWidget {
  final int idPost;
  const CommentScreen({super.key, required this.idPost});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late CommentWebSocket commentWebSocket;
  List<dynamic> comments = [];
  //
  ValueNotifier<List<dynamic>> commentsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    commentWebSocket = CommentWebSocket(widget.idPost);
    commentWebSocket.commentsStream.listen((data) {
      updateComments(data);
    });

    loadComments();
  }

  @override
  void dispose() {
    commentWebSocket.dispose();
    commentsNotifier.dispose();
    super.dispose();
  }

  Future<void> loadComments() async {
    List<dynamic> fetchedComments =
        await CommentService().listComment(widget.idPost);
    commentsNotifier.value = fetchedComments;
  }

  void updateComments(dynamic data) {
    if (data['type'] == 'update_like') {
      final updatedComment = data['comment'];
      final index = comments
          .indexWhere((c) => c['idComment'] == updatedComment['idComment']);
      if (index != -1) {
        comments[index]['is_liked'] = updatedComment['is_liked'];
        comments[index]['likes'] = updatedComment['likes'];
        setState(() {}); // Chỉ cập nhật phần comment cần thiết
      }
    }
  }

  Future<void> toggleLike(int idComment) async {
    final updatedComment = await CommentService().likeUnlikeComment(idComment);
    if (updatedComment != null) {
      commentsNotifier.value = commentsNotifier.value.map((comment) {
        if (comment['idComment'] == updatedComment['idComment']) {
          return {
            ...comment, // Giữ nguyên các dữ liệu cũ
            'is_liked': updatedComment['is_liked'],
            'likes': updatedComment['likes'],
          };
        }
        return comment;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 5,
            width: 50,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Center(
            child: Text(
              'Comment',
              style: MyTextStyle.textMedium_(context),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: CommentService().listComment(widget.idPost),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi khi tải bình luận"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Chưa có bình luận nào"));
                }

                commentsNotifier.value = snapshot.data!;

                return ValueListenableBuilder<List<dynamic>>(
                  valueListenable: commentsNotifier,
                  builder: (context, comments, _) {
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var comment = comments[index];
                        return CommentItem(
                          comment: comment,
                          onEdit: () {},
                          onDelete: () {},
                          onReply: () {},
                        );
                        // return ListTile(
                        //   leading: CircleAvatar(
                        //     backgroundImage:
                        //         NetworkImage(comment['user']['avatar']),
                        //   ),
                        //   title: Text(comment['user']['username']),
                        //   subtitle: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(comment['content']),
                        //       Row(
                        //         children: [
                        //           IconButton(
                        //             icon: Icon(
                        //               comment['is_liked']
                        //                   ? Icons.favorite
                        //                   : Icons.favorite_border,
                        //               color: comment['is_liked']
                        //                   ? Colors.red
                        //                   : null,
                        //             ),
                        //             onPressed: () =>
                        //                 toggleLike(comment['idComment']),
                        //           ),
                        //           Text('${comment['likes']} lượt thích'),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // );
                      },
                    );
                  },
                );
              },
            ),
          ),
          CreateComment(idPost: widget.idPost),
        ],
      ),
    );
  }
}
