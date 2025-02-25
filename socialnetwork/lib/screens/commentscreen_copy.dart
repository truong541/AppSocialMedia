import 'package:flutter/material.dart';
import 'package:socialnetwork/components/comment_item.dart';
import 'package:socialnetwork/components/create_comment.dart';
import 'package:socialnetwork/services/comment_service.dart';
import 'package:socialnetwork/services/respond_comment_service.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class CommentScreen extends StatefulWidget {
  final int idPost;
  static final GlobalKey<_CommentScreenState> commentScreenKey = GlobalKey();

  CommentScreen({Key? key, required this.idPost})
      : super(key: commentScreenKey);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool _isLoading = false;
  bool _isLoadingCreate = false;
  late CommentService commentService;
  late CommentWebSocket commentWebSocket;
  List<dynamic> comments = [];
  final FocusNode _commentFocusNode = FocusNode();
  final TextEditingController _contentController = TextEditingController();

  // void focusOnTextField() {
  //   if (_commentFocusNode.hasFocus) {
  //     _commentFocusNode.unfocus();
  //     Future.delayed(Duration(milliseconds: 100), () {
  //       _commentFocusNode.requestFocus();
  //     });
  //   } else {
  //     _commentFocusNode.requestFocus();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // commentService = CommentService();
    // commentWebSocket = CommentWebSocket(widget.idPost);
    _fetchComments();

    // Lắng nghe dữ liệu mới từ WebSocket
    // commentWebSocket.commentsStream.listen((event) {
    //   String type = event['type'];

    //   if (type == 'new_comment') {
    //     setState(() {
    //       comments.add(event['comment']);
    //     });
    //   } else if (type == 'update_comment') {
    //     int index = comments
    //         .indexWhere((c) => c['idComment'] == event['comment']['idComment']);

    //     if (index != -1) {
    //       setState(() {
    //         comments[index] = event['comment'];
    //       });
    //     }
    //   } else if (type == 'delete_comment') {
    //     setState(() {
    //       comments.removeWhere((c) => c['idComment'] == event['comment_id']);
    //     });
    //   }
    // });
  }

  _fetchComments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // List<dynamic> fetchedComments =
      //     await commentService.showListComment(widget.idPost);
      // setState(() {
      //   comments = fetchedComments;
      //   print(comments);
      //   _isLoading = false;
      // });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _createComment() async {
    setState(() {
      _isLoadingCreate = true;
    });
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a comment.')),
      );
      return;
    }
    String content = _contentController.text;
    if (content.isNotEmpty) {
      // try {
      //   bool success =
      //       await commentService.createComment(widget.idPost, content);
      //   if (success) {
      //     setState(() {
      //       // comments.add({"content": content});
      //       _contentController.clear();
      //       _isLoadingCreate = false;
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //           content: Text('You have successfully commented!'),
      //         ),
      //       );
      //     });
      //   }
      // } catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(e.toString())),
      //   );
      // } finally {
      //   setState(() {
      //     _isLoadingCreate = false;
      //   });
      // }
    }
  }

  void editComment(int idComment, String content) {
    // Hiển thị hộp thoại nhập nội dung mới
    TextEditingController controller = TextEditingController();
    controller.text = content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa bình luận'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Nhập nội dung mới'),
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Lưu'),
            onPressed: () async {
              String newContent = controller.text.trim();
              if (newContent.isNotEmpty) {
                // Gửi yêu cầu chỉnh sửa bình luận lên server
                // await commentService.editComment(idComment, newContent);
                // Navigator.pop(context);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Edit comment successfully!')),
                // );
              }
            },
          ),
        ],
      ),
    );
  }

  void deleteComment(int idComment) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa bình luận?'),
        content: Text('Bạn có chắc muốn xóa bình luận này?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              // bool success = await commentService.deleteComment(idComment);
              // if (success) {
              //   setState(() {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text('You have delete commented!'),
              //       ),
              //     );
              //   });
              // }
              Navigator.pop(context, false);
            },
          ),
        ],
      ),
    );

    if (confirm) {
      await commentService.deleteComment(idComment);
    }
  }

  void createRespondComment(int idPost, int idComment) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Phản hồi bình luận'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Nhập bình luận'),
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Lưu'),
            onPressed: () async {
              String newContent = controller.text.trim();
              if (newContent.isNotEmpty) {
                Navigator.pop(context); // Đóng Dialog trước
                Future.delayed(Duration(milliseconds: 100), () async {
                  await RespondCommentService().createRespondComment(
                    idPost,
                    idComment,
                    {'content': newContent},
                  );
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Create comment successfully!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentWebSocket.dispose();
    super.dispose();
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : comments.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Chưa có bình luận',
                                style: MyTextStyle.textLarge_(context)),
                            Text('Bắt đầu trò chuyện',
                                style: MyTextStyle.textSmall(context)),
                          ],
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CommentItem(
                                  comment: comments[index],
                                  onEdit: () => editComment(
                                      comments[index]['idComment'],
                                      comments[index]['content']),
                                  onDelete: () => deleteComment(
                                      comments[index]['idComment']),
                                  onReply: () => createRespondComment(
                                      comments[index]['idPost'],
                                      comments[index]['idComment']),
                                ),
                                SizedBox(height: 8),
                                // Padding(
                                //   padding: EdgeInsets.only(left: 50),
                                //   child: Column(
                                //     children: [
                                //       Row(
                                //         children: [
                                //           SizedBox(width: 30),
                                //           GestureDetector(
                                //             onTap: () {},
                                //             child: Text(
                                //               'Xem 1 câu trả lời khác',
                                //               style: TextStyle(
                                //                   color: Colors.grey,
                                //                   fontSize: 13),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       SizedBox(height: 20),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(height: 8),
                              ],
                            );
                          },
                        ),
            ),
          ),
          // CreateComment(
          //   idPost: widget.idPost,
          //   textEditingController: _contentController,
          //   focusNode: _commentFocusNode,
          //   onPress: _createComment,
          //   isLoading: _isLoadingCreate,
          // ),
        ],
      ),
    );
  }
}
