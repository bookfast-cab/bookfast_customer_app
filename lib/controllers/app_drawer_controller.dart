import 'package:bookfast_customer/models/login_model.dart';
import 'package:get/get.dart';

import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class AppDrawerController extends GetxController {
  var selectedIndex = 0.obs;
  var loginModel = LoginModel().obs;

  void selectItem(int index) {
    selectedIndex.value = index;
  }

  hitLogOutApi({required Function() callBack}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }

    Map<String, dynamic> map = {};

    var response = await ApiHandler().post(data: map, endPoint: ApiConstants.apiCustomerLogOut);

    loginModel.value = LoginModel.fromJson(response);

    if (loginModel.value.success == true) {
      if (loginModel.value.message != null) {
        AppCommonWidgets.showAppToast(loginModel.value.message!);
      }
      callBack();
    } else {
      if (loginModel.value.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(description: loginModel.value.message!, okCallback: () {}));
      }
    }
  }

}
