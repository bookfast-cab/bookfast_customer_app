import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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
                  titleText: AppStrings.strWallet,
                  isTitleCenter: false,
                  titleTextColor: AppColors.textColor100,
                  leadingWidget: IconButton(
                    icon: Image.asset(AppImages.icDrawer, height: 33, width: 33),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppContainer(
                          padding: const EdgeInsets.all(20),
                          borderColor: AppColors.textColor30,
                          allBorderRadius: 10,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.textColor80,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextWidget(
                                    'Rs0',
                                    style: AppTextStyles.body2RegularTextStyle(fontSize: 16, fontWeight: FontWeight.w700, textColor: AppColors.textColor60),
                                  ),
                                  const SizedBox(height: 3),
                                  AppTextWidget(
                                    AppStrings.strYourBalance,
                                    style: AppTextStyles.body2RegularTextStyle(fontSize: 12, textColor: AppColors.textColor40),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                width: 40,
                              ),
                              Expanded(
                                  child: AppContainer(
                                padding: const EdgeInsets.all(8),
                                borderColor: AppColors.textColor30,
                                allBorderRadius: 5,
                                child: AppTextWidget(
                                  AppStrings.strAddMoney,
                                  style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor40, fontSize: 14),
                                ),
                                onTap: () {
                                  _showAddWalletDialog();
                                },
                              ))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppTextWidget(
                          AppStrings.strWalletTransactions,
                          style: AppTextStyles.headingH5TextStyle(textColor: AppColors.textColor90, fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showAddWalletDialog() {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  AppTextWidget(AppStrings.strAddWallet,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor80,fontSize: 18),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget(AppStrings.strPleaseEnterYourAmountHere,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 14),),
              const SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(
                  hintText: AppStrings.strEnterAmount,
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.bfPrimaryColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.bfPrimaryColor),
                  ),
                ),
                cursorColor: AppColors.bfPrimaryColor,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: AppTextWidget(AppStrings.strCancel,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.dangerPrimaryColor,fontSize: 14),),
            ),
            TextButton(
              onPressed: () {
                String amount = amountController.text;
                print('Entered Amount: $amount');
                Navigator.of(context).pop();
              },

              child: AppTextWidget(AppStrings.strSubmit,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.bfPrimaryColor,fontSize: 14),),
            ),
          ],
        );
      },
    );
  }
}
