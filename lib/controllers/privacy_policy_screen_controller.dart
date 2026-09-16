import 'package:get/get.dart';

import '../models/privacy_policy_model.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class PrivacyPolicyController extends GetxController{
  var privacyPolicy = <PrivacyPolicyData>[].obs;


  hitPrivacyPolicyApi({required Function() callBack,}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    var response = await ApiHandler().get(endPoint: ApiConstants.apiCustomerPrivacyPolicy, addAuthorization: true);
    PrivacyPolicyModel model = PrivacyPolicyModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if (model.data != null) {
        privacyPolicy.value = model.data!;
      }
      callBack();
    } else {
      AppCommonWidgets.showAppToast("Failed to fetch data");
    }
  }
}