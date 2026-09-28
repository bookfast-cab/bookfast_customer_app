import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import 'app_drawer.dart';

class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello, mujhe booking issue aa raha hai",
      isCustomer: true,
      time: "10:02 AM",
      senderName: "You",
    ),
    ChatMessage(
      text: "Hi, aap detail bataiye please 🙂",
      isCustomer: false,
      time: "10:03 AM",
      senderName: "Support Agent",
    ),
    ChatMessage(
      text: "Payment cut ho gaya par ride confirm nahi hui",
      isCustomer: true,
      time: "10:04 AM",
      senderName: "You",
    ),
    ChatMessage(
      text: "No worries, main check kar leta hoon 👍",
      isCustomer: false,
      time: "10:05 AM",
      senderName: "Support Agent",
    ),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _textController.text,
          isCustomer: true,
          time: DateFormat('hh:mm a').format(DateTime.now()),
          senderName: "You",
        ),
      );
    });

    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfprimarythemeColor2,
      child: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          body: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildChatList(),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  CommonAppBar _buildAppBar() {
    return CommonAppBar(
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.strCustomerSupport,style: AppTextStyles.body2RegularTextStyle(fontSize: 16,fontWeight: FontWeight.w600,textColor: Colors.black),),
          Text("typing..",style: AppTextStyles.body2RegularTextStyle(fontSize: 10,textColor: AppColors.textColor80)),
        ],
      ),
    //  titleText: AppStrings.strCustomerSupport,
      isTitleCenter: false,
      titleTextColor: AppColors.textColor100,
      leadingWidget: IconButton(
        icon: Image.asset(AppImages.icDrawer, height: 33, width: 33),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
    // return AppBar(
    //   backgroundColor: Colors.white,
    //   elevation: 2,
    //   shadowColor: Colors.black12,
    //   leading: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Icon(Icons.arrow_back_ios,color: AppColors.textColor80,)
    //   ),
    //   title: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text(
    //         "Customer Support",
    //         style: TextStyle(
    //           fontSize: 16,
    //           fontWeight: FontWeight.w600,
    //           color: Colors.black87,
    //         ),
    //       ),
    //       Text(
    //         "Typing..",
    //         style: TextStyle(
    //           fontSize: 12,
    //           color: Colors.grey[600],
    //         ),
    //       ),
    //     ],
    //   ),
    //   // actions: [
    //   //   IconButton(
    //   //     icon: Icon(Icons.more_vert, color: Colors.grey[700]),
    //   //     onPressed: () {},
    //   //   ),
    //   // ],
    //   bottom: PreferredSize(
    //     preferredSize: const Size.fromHeight(1.0),
    //     child: Container(
    //       color: Colors.grey[200],
    //       height: 1.0,
    //     ),
    //   ),
    // );
  }

  Widget _buildChatList() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F2FD), Color(0xFFF5F5F5)],
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(_messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isCustomer
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Sender name and time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: message.isCustomer
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Message bubble
          Row(
            mainAxisAlignment: message.isCustomer
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Admin's avatar (left side)
              if (!message.isCustomer) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Text(
                    message.senderName[0],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Message content
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isCustomer
                        ? const Color(0xFF2196F3)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: message.isCustomer
                          ? const Radius.circular(20)
                          : const Radius.circular(4),
                      bottomRight: message.isCustomer
                          ? const Radius.circular(4)
                          : const Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: message.isCustomer ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              // // Customer's avatar (right side)
              // if (message.isCustomer) ...[
              //   const SizedBox(width: 8),
              //   CircleAvatar(
              //     radius: 16,
              //     backgroundColor: Colors.green,
              //     child: Text(
              //       message.senderName[0],
              //       style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w500,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    // Emoji button
                    // IconButton(
                    //   icon: Icon(Icons.emoji_emotions_outlined,
                    //       color: Colors.grey[600]),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send button
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ChatMessage {
  final String text;
  final bool isCustomer;
  final String time;
  final String senderName;

  ChatMessage({
    required this.text,
    required this.isCustomer,
    required this.time,
    required this.senderName,
  });
}