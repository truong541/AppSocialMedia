import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/components/comment.dart';
import 'package:socialnetwork/screens/keyboardscreen.dart';
import 'package:socialnetwork/widgets/widget_textstyle.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _isHeartVisible = false; // Trạng thái hiển thị trái tim

  void _onDoubleTap() {
    setState(() {
      _isHeartVisible = true; // Hiển thị trái tim
    });

    // Ẩn trái tim sau 1 giây
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isHeartVisible = false; // Ẩn trái tim
      });
    });
  }

  final PageController _controller =
      PageController(); // Controller cho PageView
  int _currentPage = 0; // Biến để lưu trang hiện tại

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.toInt() ?? 0;
      });
    });
  }

  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    List<Map<String, dynamic>> images =
        List<Map<String, dynamic>>.from(post['url']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Profile Picture, Username, Time)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  post['user']['profileImage'], // Link hình đại diện
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  post['user']['username'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.more_vert),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _isHeartVisible ? 1.0 : 0.0,
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ],
          ),
        ),
        // Actions (Like, Comment, Share)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: Image.asset(
                      isLiked == true
                          ? 'assets/icon/liked.png'
                          : 'assets/icon/like.png',
                      width: 28,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    (post['like_count'] ?? 0).toString(),
                    style: MyTextstyle.textSmall,
                  ),
                  SizedBox(width: 10),
                  InkWell(
                      onTap: () {
                        showFullScreenComments(context);
                      },
                      child: Image.asset('assets/icon/comment.png', width: 28)),
                  SizedBox(width: 5),
                  Text(
                    '3.071',
                    style: MyTextstyle.textSmall,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KeyboardScreen()),
                      );
                    },
                    child: Icon(Icons.keyboard, size: 28),
                  ),
                ],
              ),
              Icon(Icons.bookmark_border, size: 28),
            ],
          ),
        ),
        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: post['user']['username'],
                  style: MyTextstyle.textMedium_,
                ),
                TextSpan(
                  text: utf8.decode(post['content'].runes.toList()),
                  style: MyTextstyle.textMedium,
                ),
              ],
            ),
          ),
        ),
        // Time
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: Text(
            '4 hours ago',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void showFullScreenComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          child: FullScreenCommentSheet(),
        );
      },
    );
  }
}

class FullScreenCommentSheet extends StatelessWidget {
  const FullScreenCommentSheet({super.key});

  Future<List<Comment>> loadComments() async {
    final String response =
        await rootBundle.loadString('assets/json/comments.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Comment.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thanh kéo để đóng
        Container(
          height: 5,
          width: 50,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Tiêu đề và nút đóng
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Bình luận',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.close),
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Đóng tấm trượt
            //   },
            // ),
          ],
        ),
        // Nội dung bình luận (danh sách)
        Expanded(
          child: FutureBuilder<List<Comment>>(
            future: loadComments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No comments available.'));
              } else {
                final comments = snapshot.data!;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentItem(comment: comments[index]);
                  },
                );
              }
            },
          ),
        ),
        // Thanh nhập bình luận
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Thêm bình luận...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Xử lý gửi bình luận
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bình luận chính
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(comment.urlUser),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${comment.name} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: comment.comment,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('${comment.liked} likes',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 10),
                      Text('Reply',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Phản hồi (nếu có)
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Column(
              children: comment.replies
                  .map((reply) => CommentItem(comment: reply))
                  .toList(),
            ),
          ),
        const Divider(),
      ],
    );
  }
}
