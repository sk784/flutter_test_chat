import 'package:chat_mobile/data/socket_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../app_controller.dart';
import 'package:chat_mobile/shared/globals.dart' as globals;

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SocketRepository(globals.webSocketAddress));
    Get.lazyPut(() => AppController(socketRepository: Get.find()));
  }
}