import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialnetwork/components/edit_text.dart';
import 'package:socialnetwork/components/button.dart';
import 'package:socialnetwork/components/support_widget.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class EditUserTextScreen extends StatefulWidget {
  final String content;
  final bool isUsername;
  final bool isBio;
  const EditUserTextScreen(
      {super.key,
      required this.content,
      this.isUsername = false,
      this.isBio = false});

  @override
  State<EditUserTextScreen> createState() => _EditUserTextScreenState();
}

class _EditUserTextScreenState extends State<EditUserTextScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final int maxLength = 30;
  bool _isChanged = false;
  bool isLoading = false;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    controller.text = MyTextStyle().toChangeVN(widget.content);
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(focusNode);
    });
    controller.addListener(() {
      if (widget.isUsername) validateUsername(controller.text);
      setState(() {
        _isChanged = controller.text != widget.content;
      });
    });
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Xác nhận"),
            content: const Text("Bạn có muốn quay trở lại không?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Không"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Có"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void setBackPop() async {
    if (_isChanged) {
      bool shouldPop = await _showExitConfirmationDialog();
      if (shouldPop) {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> validateUsername(String username) async {
    if (username.isEmpty) {
      setState(() {
        validationMessage = null;
      });
      return;
    }
    final accessToken = await GetToken().getAccessToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/account/username-validation/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'username': username}),
    );

    if (response.statusCode == 200) {
      setState(() {
        validationMessage = null;
      });
    } else if (response.statusCode == 201) {
      setState(() {
        validationMessage = 'Username already exists.';
      });
    } else {
      setState(() {
        validationMessage = 'Invalid username.';
      });
    }
  }

  Future<void> updateUserInfo() async {
    setState(() {
      isLoading = true;
    });

    final accessToken = await GetToken().getAccessToken();
    var url = Uri.parse('http://10.0.2.2:8000/account/edit-user/');
    var request = http.MultipartRequest("PATCH", url);
    request.headers["Authorization"] = "Bearer $accessToken";

    widget.isUsername
        ? request.fields["username"] = controller.text
        : widget.isBio
            ? request.fields["bio"] = controller.text
            : request.fields["fullname"] = controller.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());
      final updatedUser = responseData["data"];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("OK!"),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, updatedUser);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error!"),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isChanged ? false : true,
      onPopInvoked: (result) {
        setBackPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isUsername
              ? 'Username'
              : widget.isBio
                  ? 'Bio'
                  : 'Fullname'),
          leadingWidth: 30,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ButtonIcon(
              onTapped: setBackPop,
              imageIcon: 'x_close.png',
              colorIcon: Colors.black,
              widthIcon: 30,
            ),
          ),
          actions: [
            isLoading
                ? CircularProgressIndicator()
                : ButtonIcon(
                    onTapped: () {
                      if (widget.isBio || controller.text.isNotEmpty) {
                        updateUserInfo();
                      }
                    },
                    imageIcon: 'tick_save.png',
                    colorIcon: widget.isBio
                        ? Colors.blue
                        : validationMessage != null && controller.text.isEmpty
                            ? Colors.grey
                            : Colors.blue,
                    widthIcon: 25,
                  ),
            SizedBox(width: 20),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: ContainerEditUserText(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleEditUserText(
                  controller: controller,
                  maxLength: widget.isUsername
                      ? 15
                      : widget.isBio
                          ? 120
                          : 30,
                  title: (widget.isUsername
                      ? 'Username'
                      : widget.isBio
                          ? 'Bio'
                          : 'Fullname'),
                ),
                EditUserText(
                  controller: controller,
                  focusNode: focusNode,
                  maxLength: widget.isUsername
                      ? 15
                      : widget.isBio
                          ? 120
                          : 30,
                ),
                if (validationMessage != null)
                  Text(
                    validationMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
