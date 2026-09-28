import 'package:bookfast_customer/controllers/phone_number_screen_controler.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/app_images.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final PhoneNumberScreenController _controller = Get.put(PhoneNumberScreenController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // कीबोर्ड ओपन होने पर बॉटम कार्ड ऊपर की तरफ स्लाइड हो जाएगा
      resizeToAvoidBottomInset: true, 
      body: Stack(
        children: [
          // 1. Full-Screen Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.imgSplash,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter, // इमेज को ऊपर से अलाइन करेगा
            ),
          ),

          // 2. Subtle Bottom Gradient (नीचे की तरफ हल्का डार्क इफ़ेक्ट ताकि वाइट कार्ड के साथ अच्छे से ब्लेंड हो)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.6, 1.0], // ग्रेडिएंट सिर्फ नीचे के हिस्से में रहेगा
                ),
              ),
            ),
          ),

          // 3. Bottom Anchored Login Form (नीचे से जुड़ा हुआ)
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, -5), // ऊपर की तरफ हल्की शैडो
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header texts (चूँकि लोगो ऊपर है, हम यहाँ सिर्फ नंबर डालने के लिए कहेंगे)
                      Text(
                        AppStrings.strWelComeToBookFast,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Text(
                      //   AppStrings.strEnterYourNumberToContinue, // "Enter your number to continue"
                      //   style: TextStyle(
                      //     color: Colors.grey.shade600,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // const SizedBox(height: 32),
                      
                      // Modern Text Field (आपने जो डिज़ाइन किया था वो बहुत अच्छा है)
                      TextFormField(
                        controller: _controller.phoneNumberController.value,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                        ],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                          prefixIcon: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.phone_android,
                                  color: AppColors.bfprimarythemeColor2,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '+91',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 1.5,
                                  height: 20,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.bfprimarythemeColor2, width: 1.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.red.shade300, width: 1.2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                          ),
                        ),
                        cursorColor: AppColors.bfprimarythemeColor2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      // Modern Submit Button
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            // Hide keyboard
                            FocusScope.of(context).unfocus();
                            _controller.onRegisterClick();
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.bfprimarythemeColor2,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.bfprimarythemeColor2.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            AppStrings.strSendOtp,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}