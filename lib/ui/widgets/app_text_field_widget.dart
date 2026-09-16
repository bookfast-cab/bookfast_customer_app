import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookfast_customer/utils/app_constants.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';

import '../../../utils/app_colors.dart';

class AppTextFieldWidget extends StatefulWidget {
  const AppTextFieldWidget(
      {Key? key,
      this.hintText = "",
      this.controller,
      this.showBorder = true,
      this.keyboardType = TextInputType.text,
      this.isMandatory = false,
      this.lableName,
      this.fillColor = Colors.white24,
      this.borderColor = AppColors.textColor30,
      this.maxLength = 200,
      this.minLength,
      this.focusNodeValue,
      this.onTextChange,
      this.isTextCenter = false,
      this.isEnabled = true,
      this.removeUnderlineBorder = false,
      this.prefixIcon,
      this.lengthErrorMsg,
      this.minLengthErrorMsg,
      this.onTap,
      this.onReturnKey,
      this.contentPadding,
      this.suffixIcon,
      this.isPhoneValidation = false,
      this.isNameValidation = false,
      this.isPasswordValidation = false,
      this.isConfirmPasswordValidation = false,
      this.confirmPasswordController,
      this.textInputFormatter,
      this.textCapitalization = TextCapitalization.sentences,
      this.borderRadius = 10,
      this.maxLine,
      this.minLine,
      this.textColor = Colors.black,
      this.hintColor = AppColors.textColor30,
      this.obscure = false,
      this.customErrorMessage,
      this.validationErrorMessage,
      this.readOnly = false,
      this.isNextLineEnabled = false,
      this.autofocus = false,
      this.showCounterText = false,
      this.textInputAction,
      this.initialValue,
      this.textAlignVertical = TextAlignVertical.center,
       this.validation = true,
  this. obscureText = true})
      : super(key: key);

  final bool readOnly;
  final bool validation;
  final bool obscureText;
  final bool isNextLineEnabled;
  final String? lengthErrorMsg;
  final String? minLengthErrorMsg;
  final List<TextInputFormatter>? textInputFormatter;
  final String? hintText;
  final bool? showBorder;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool isMandatory;
  final bool removeUnderlineBorder;
  final String? lableName;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final double borderRadius;
  final int? maxLength;
  final int? minLength;
  final FocusNode? focusNodeValue;
  final Function(String)? onTextChange;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isEnabled;
  final bool showCounterText;
  final bool? isPhoneValidation;
  final bool? isNameValidation;
  final bool? isPasswordValidation;
  final bool? isConfirmPasswordValidation;
  final TextEditingController? confirmPasswordController;
  final bool isTextCenter;
  final TextAlignVertical textAlignVertical;
  final Function()? onTap;
  final TextCapitalization? textCapitalization;
  final int? maxLine;
  final int? minLine;
  final bool obscure;
  final String? customErrorMessage;
  final String? validationErrorMessage;
  final EdgeInsets? contentPadding;
  final TextInputAction? textInputAction;
  final String? initialValue;
  final bool autofocus;
  final Function()? onReturnKey;

  @override
  State<AppTextFieldWidget> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<AppTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    // widget.controller!.text = widget.text!;
    return TextFormField(
      maxLines: widget.maxLine ?? 1,
      minLines: widget.minLine ?? 1,

      initialValue: widget.initialValue,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,

      // onFieldSubmitted: (value) {
      //   if (widget.isNextLineEnabled == true){
      //
      //
      //   }
      //    //FocusScope.of(context).unfocus();
      // },

      onFieldSubmitted: (value) {
        if (widget.onReturnKey != null) {
          widget.onReturnKey!();
        }
      },

      onTap: widget.onTap ?? () {},
      enabled: widget.isEnabled ?? true,
      inputFormatters: widget.isPhoneValidation! ? [FilteringTextInputFormatter.allow(RegExp("[0-9]"))] : widget.textInputFormatter,
      focusNode: widget.focusNodeValue,
      controller: widget.controller,
      cursorColor: AppColors.bfPrimaryColor,
      obscureText: widget.obscure,

      autofocus: widget.autofocus,
      textCapitalization:  widget.textCapitalization!,

      maxLength: widget.maxLength ?? 1000,

      keyboardType: widget.keyboardType ?? TextInputType.text,
      onChanged: widget.onTextChange ?? (v) {},
      textAlignVertical: TextAlignVertical.top, //widget.textAlignVertical,
      textAlign: widget.isTextCenter ? TextAlign.center : TextAlign.start,
      validator: !widget.isMandatory
          ? null
          : (v) {
              if (v!.isEmpty) {
                return widget.validationErrorMessage ?? '${widget.lableName} is required';
              } else if (widget.lengthErrorMsg != null && v.length < widget.maxLength!) {
                return widget.lengthErrorMsg ?? "Enter valid ${widget.lableName}";
              } else if (widget.minLengthErrorMsg != null && widget.minLength != null) {
                if (v.length < widget.minLength!) {
                  return widget.lengthErrorMsg ?? widget.minLengthErrorMsg;
                }
              }
              print("v--> ${v.length}");
              if (widget.isPhoneValidation!) {
                if (v.length < 10) {
                  return 'Please enter valid mobile number';
                }
              }
              if (widget.keyboardType == TextInputType.emailAddress) {
                String patttern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                RegExp regExp = RegExp(patttern);
                if (!regExp.hasMatch(v)) {
                  return 'Please enter valid email ';
                }
              }
              if (widget.isNameValidation!) {
                String patttern = r'(^[a-zA-Z]*$)';
                //RegExp regExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
                RegExp regExp = RegExp(r"^[a-zA-Z '.-]*$");
                //RegExp regExp = RegExp(patttern);
                if (!regExp.hasMatch(v)) {
                  return 'Please enter valid name';
                }
              }
              if (widget.isPasswordValidation!) {
                if (v.trim().isEmpty) {
                  return 'The Password is required';
                } else if (v.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
              }
              if (widget.isConfirmPasswordValidation!) {
                if (v != widget.confirmPasswordController?.text) {
                  return 'Passwords do not match';
                }
              }
              return null;
            },
      style: TextStyle(
        color: widget.textColor,
        fontSize: 14.0,
        fontFamily: AppConstants.fontLexendRegular,
      ),

      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorText: widget.customErrorMessage,
        errorStyle: const TextStyle(color: Colors.red),
        labelText: widget.lableName,
        labelStyle: const TextStyle(color: AppColors.textColor40, fontFamily: AppConstants.fontLexendRegular),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.grey, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.bfPrimaryColor, width: 1.0),
        ),


        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(vertical: AppDimensions.dmSixteen, horizontal: AppDimensions.dmFifteen),
        counterText: widget.showCounterText
            ? widget.maxLength == 200
                ? ""
                : null
            : "",
        filled: true,
        border: widget.removeUnderlineBorder ? InputBorder.none : null,
        isDense: true,
        prefixIconConstraints: const BoxConstraints(minWidth: 10, minHeight: 10),

        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        // suffix: Icon(Icons.remove_red_eye),
        // prefix: widget.prefixIcon,
        hintText: widget.hintText ?? "",
        fillColor: widget.fillColor,
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: widget.hintColor ?? AppColors.textColor40,
          fontFamily: AppConstants.fontLexendRegular,
          textBaseline: TextBaseline.alphabetic,
        ),
      ),
    );
  }
}

myFunc(Function myVal) {
  return TextFormField(
    validator: (v) => myVal(v),
  );
}
