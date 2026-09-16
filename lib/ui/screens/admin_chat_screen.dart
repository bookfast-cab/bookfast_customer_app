import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_text_field_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:flutter/material.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({super.key});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfPrimaryColor,
      child: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          body: AppBaseScreen(
            child: Column(
              children: [
                CommonAppBar(
                  titleText: AppStrings.strAdminChat,
                  isTitleCenter: false,
                  titleTextColor: AppColors.textColor100,
                  leadingWidget: IconButton(
                    icon: Image.asset(AppImages.icDrawer,height: 33,width: 33),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                  Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    ],
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15,bottom: 15),
                  child: AppTextFieldWidget(
                    borderRadius: 10,
                    suffixIcon: InkWell(
                      child:  const Icon(
                        Icons.send,
                        color: AppColors.bfPrimaryColor,
                      ),
                      onTap: (){},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
