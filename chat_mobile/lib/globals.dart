library chat_mobile.globals;
import 'package:chat_models/chat_models.dart';

const String host = '192.168.0.121';
const String webSocketAddress = 'ws://$host:3333/ws';
const String chatApiAddress = 'http://$host:3333';

String authToken;
User currentUser;