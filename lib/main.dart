import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nova_messenger/Providers/chat_provider.dart';
import 'package:nova_messenger/Providers/login_provider.dart';
import 'package:nova_messenger/Providers/user_provider.dart';
import 'package:nova_messenger/Services/chat_service.dart';
import 'package:nova_messenger/Utils/jwt_validator.dart';
import 'package:nova_messenger/Utils/user_data_holder.dart';
import 'package:nova_messenger/Views/Private/chat_list_screen.dart';
import 'package:nova_messenger/Views/Public/login_view.dart';
import 'package:provider/provider.dart';

import 'Router/app_router.dart';

void main() async {
  UserDataHolder.userDataHolder.detectPlatform();

  WidgetsFlutterBinding.ensureInitialized();

  ChatService.chatService.connect();

  runApp(
    MultiProvider
    (
      providers:
      [
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),
      ],
      child:  const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child){ 
        return MaterialApp(
        navigatorKey: AppRouter.navKey,
        debugShowCheckedModeBanner: false,
        title: 'Nova Messenger',
        theme: ThemeData(
              fontFamily: 'Poppins',
              primarySwatch: Colors.grey
            ),
        home: FutureBuilder<bool>(
          future: JwtValidator.jwtValidator.validate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final isValid = snapshot.data;
              if (isValid == true) {
                // Token exists, navigate to the main chat screen
                return const ChatListScreen();
              } else {
                // No token, navigate to the login screen
                return const LoginScreen();
              }
            }
          },
        ),
      );
      }
    );
  }
}
