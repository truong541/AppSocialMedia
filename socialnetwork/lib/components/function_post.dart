// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:socialnetwork/components/carousel_images.dart';
import 'package:socialnetwork/screens/commentscreen.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socialnetwork/widgets/mytext.dart';

class FunctionPost extends StatefulWidget {
  final int idPost;
  final int numberLike;
  final int numberComment;
  final bool isLiked;
  final List<Map<String, dynamic>> images;
  const FunctionPost(
      {super.key,
      required this.idPost,
      required this.numberLike,
      required this.numberComment,
      required this.isLiked,
      required this.images});

  @override
  State<FunctionPost> createState() => _FunctionPostState();
}

class _FunctionPostState extends State<FunctionPost>
    with SingleTickerProviderStateMixin {
  bool _isHeartVisible = false;
  late int numberLike;
  late bool isLiked;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    numberLike = widget.numberLike;
    isLiked = widget.isLiked;
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _showHeart() {
    setState(() {
      _isHeartVisible = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isHeartVisible = false;
      });
    });
  }

  Future<void> _doubleTapLike() async {
    final accessToken = await GetToken().getAccessToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/post/only-like/${widget.idPost}/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      numberLike++;
      isLiked = !isLiked;
      _showHeart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thích bài viết này!')),
      );
    } else if (response.statusCode == 204) {
      _showHeart();
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['error'] ?? 'Follow failed')),
      );
    }
  }

  Future<void> _likePost() async {
    final accessToken = await GetToken().getAccessToken();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/post/like/${widget.idPost}/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );
    //nếu chưa like thì thực hiện like
    if (response.statusCode == 201) {
      setState(() {
        numberLike++;
        isLiked = !isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thích!')),
      );
      //nếu đã like thì xóa like
    } else if (response.statusCode == 204) {
      setState(() {
        numberLike--;
        isLiked = !isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã hủy thích!')),
      );
      //nếu lỗi
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['error'] ?? 'Follow failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: () async {
            _doubleTapLike();
            await _controller.forward();
            _controller.reverse();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselImages(
                images: widget.images,
              ),
              AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _isHeartVisible ? 1.0 : 0.0,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  _likePost();

                  await _controller.forward();
                  _controller.reverse();
                },
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: child,
                    );
                  },
                  child: isLiked
                      ? Image.asset(
                          'assets/icon/liked.png',
                          width: 25,
                        )
                      : ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .colorScheme
                                .onSurface, // Màu phủ lên
                            BlendMode.srcATop, // Chế độ hòa trộn
                          ),
                          child: Image.asset(
                            'assets/icon/like.png',
                            width: 25,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 5),
              Text(
                numberLike.toString(),
                style: MyTextStyle.textSmall(context),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  showFullScreenComments(context);
                },
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface, // Màu phủ lên
                    BlendMode.srcATop, // Chế độ hòa trộn
                  ),
                  child: Image.asset(
                    'assets/icon/comment.png',
                    width: 25,
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text(
                widget.numberComment.toString(),
                style: MyTextStyle.textSmall(context),
              ),
            ],
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
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.95,
            minChildSize: 0.95 / 2,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return CommentScreen(idPost: widget.idPost);
            });
      },
    );
  }
}
