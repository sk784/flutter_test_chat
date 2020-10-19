import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/app_controller.dart';
import 'package:chat_mobile/shared/globals.dart' as globals;
import 'package:get/get.dart';

class MobileApiClient extends ApiClient {
  static AppController appController = Get.find();
  MobileApiClient()
      : super(Uri.parse(globals.chatApiAddress),
            onBeforeRequest: (ApiRequest request) {
          if (appController.authToken != null)
            return request.change(
                headers: {}
                  ..addAll(request.headers)
                  ..addAll({'authorization': appController.authToken}));
          return request;
        }, onAfterResponse: (ApiResponse response) {
          if (response.headers.containsKey('authorization'))
            appController.setAuthToken(response.headers['authorization']);
            appController.setMobileToken(response.headers['authorization']);
          return response;
        });
}
