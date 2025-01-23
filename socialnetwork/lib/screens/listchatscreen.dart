import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListChatScreen extends StatefulWidget {
  const ListChatScreen({super.key});

  @override
  State<ListChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen>
    with WidgetsBindingObserver {
  // Danh sách tin nhắn
  final List<Map<String, String>> _messages = [];

  // Controller và FocusNode để điều khiển TextField
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Biến để theo dõi trạng thái bàn phím
  bool _isKeyboardVisible = false;

// Biến để lưu đường dẫn ảnh đã chọn
  String? _imagePath;

  // Khởi tạo ImagePicker
  final ImagePicker _picker = ImagePicker();
  // Hàm gửi tin nhắn
  void _sendMessage({String? imagePath}) {
    if (_controller.text.isNotEmpty || _imagePath != null) {
      setState(() {
        _messages.insert(0, {
          'text':
              _controller.text.isNotEmpty ? _controller.text : 'Image message',
          'sender': 'Me',
          'image': imagePath ?? '',
        });
        _controller.clear(); // Xóa nội dung trong TextField sau khi gửi
        _imagePath = null; // Xóa ảnh đã chọn sau khi gửi
      });
    }
  }

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Chọn ảnh từ thư viện

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // Lưu đường dẫn ảnh vào biến _imagePath
      });
      // Gửi tin nhắn ngay sau khi chọn ảnh
      _sendMessage(
          imagePath: _imagePath); // Truyền _imagePath thay vì pickedFile.path
    } else {
      print('Không có ảnh được chọn');
    }
  }

  // Theo dõi sự thay đổi của bàn phím (bàn phím hiện lên/ẩn đi)
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardVisible =
        WidgetsBinding.instance.window.viewInsets.bottom > 0;
    if (keyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = keyboardVisible;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Đảm bảo FocusNode được giải phóng
    WidgetsBinding.instance.removeObserver(this); // Hủy đăng ký Observer
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Đăng ký Observer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              reverse: true, // Đảo ngược danh sách tin nhắn
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['sender'] == 'Me'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'Me'
                            ? Colors.orange[200]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: message['image'] != ''
                          ? Image.file(
                              File(message['image']!), // Hiển thị ảnh nếu có
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Text(
                              message['text']!,
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Row chứa các button (ghi âm, máy ảnh, hình ảnh) và TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Các button (ghi âm, máy ảnh, hình ảnh)
                Visibility(
                  visible: !_isKeyboardVisible, // Ẩn nếu bàn phím hiển thị
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: () {
                          // Thực hiện hành động ghi âm
                        },
                        color: Colors.orange,
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          // Thực hiện hành động mở máy ảnh
                        },
                        color: Colors.orange,
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: _pickImage,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),

                // TextField để nhập tin nhắn
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onSubmitted: (_) =>
                        _sendMessage(), // Gửi tin nhắn khi nhấn Enter
                  ),
                ),

                // IconButton để gửi tin nhắn
                Visibility(
                  visible: _isKeyboardVisible, // Ẩn nếu bàn phím hiển thị
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
