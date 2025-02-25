import 'package:flutter/material.dart';
import 'package:socialnetwork/services/api_service.dart';
import 'package:socialnetwork/services/comment_service.dart';

class CreateComment extends StatefulWidget {
  final int idPost;
  // final TextEditingController textEditingController;
  // final FocusNode focusNode;
  // final VoidCallback onPress;
  // final bool isLoading;

  const CreateComment({
    super.key,
    required this.idPost,
    // required this.textEditingController,
    // required this.focusNode,
    // required this.onPress,
    // required this.isLoading
  });
  @override
  State<CreateComment> createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  void createComment() async {
    setState(() {
      isLoading = true;
    });
    await CommentService()
        .createComment(widget.idPost, {'content': controller.text.trim()});
    setState(() {
      isLoading = false;
      print('Thanh cong');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              'https://i.otakul.com/7738/Mo-hinh-Smoker-One-Piece-2%281%29.jpg',
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              // focusNode: widget.focusNode,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Thêm bình luận...',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 10),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : IconButton(
                  icon: Icon(Icons.send),
                  onPressed: createComment,
                ),
        ],
      ),
    );
  }
}
