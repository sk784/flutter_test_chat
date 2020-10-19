import 'package:chat_models/chat_models.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/socket_repository.dart';


class AppController extends GetxController{
  AppController({this.socketRepository});

  final SocketRepository socketRepository;

  static const String TOKEN = 'TOKEN';
  final RxString _authToken = "".obs;

  Rx<User> _currentUser = Rx<User>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  setUser(User value) => _currentUser.value = value;
    User get currentUser {
    return _currentUser.value;
  }

  setAuthToken(String value) => _authToken.value = value;
    String get authToken {
    return _authToken.value;
  }

  Future<String> getMobileToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(TOKEN) ?? '';
  }

  Future<bool> setMobileToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(TOKEN, token);
  }


  @override
  void onInit() => wsConnect();

  Future<void> wsConnect() async {
    return socketRepository.connect();
  }

  @override
  void onClose() {
    socketRepository.dispose();
    super.onClose();
  }
}



