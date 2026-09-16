import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAlertDialog extends StatelessWidget {
  CommonAlertDialog(
      {Key? key,
      this.title,
      required this.description,
      required this.okCallback,
      this.okCancelCallback,
      this.titleStyle,
      this.okButtonTextStyle,
      this.okButtonText = "Ok",
      this.cancelButtonText = "Cancel",
      this.showCancelButton = false,
      this.barrierDismissible = true,
      this.descStyle})
      : super(key: key);
  String? title;
  final String description;
  final String okButtonText;
  final String cancelButtonText;
  final Function? okCallback;
  final Function? okCancelCallback;
  TextStyle? titleStyle;
  TextStyle? descStyle;
  TextStyle? okButtonTextStyle;
  bool showCancelButton;
  bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => barrierDismissible, // Prevent closing on back press
      child:  Dialog(
        shadowColor: Colors.transparent,
       // insetPadding: EdgeInsets.symmetric(horizontal: 50) ,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 12, right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      title != null ? title!.tr : 'Alert'.tr,
                      style: titleStyle ?? const TextStyle(fontSize: 16, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ).paddingSymmetric(horizontal: 20),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        description.tr,
                        // 'Please allow location access to use the app.Your location is used to determine Travel and Meet Now mode connections'
                        //     .tr,
                        style: descStyle ?? const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (okCallback != null) {
                        okCallback!();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        okButtonText,
                        style: okButtonTextStyle ?? const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                if (showCancelButton)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (okCancelCallback != null) {
                          okCancelCallback!();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          cancelButtonText,
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
