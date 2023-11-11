import 'package:advance_player_academy_trainer/controllers/auth_controller.dart';
import 'package:advance_player_academy_trainer/controllers/change_button_style_controller.dart';
import 'package:advance_player_academy_trainer/controllers/get_trainer_details.dart';
import 'package:advance_player_academy_trainer/controllers/image_controller.dart';
import 'package:advance_player_academy_trainer/controllers/loading_controller.dart';
import 'package:advance_player_academy_trainer/controllers/visibility_controller.dart';
import 'package:advance_player_academy_trainer/screens/splash/splash_screen.dart';
import 'package:advance_player_academy_trainer/services/chat_db_services.dart';
import 'package:advance_player_academy_trainer/services/training_services.dart';
import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => VisibilityController()),
        ChangeNotifierProvider(create: (_) => ImageController()),
        ChangeNotifierProvider(create: (_) => TrainingServices()),
        ChangeNotifierProvider(create: (_) => GetUserDetails()),
        ChangeNotifierProvider(create: (_) => ChatDbServices()),
        ChangeNotifierProvider(create: (_) => LoadingController()),
        ChangeNotifierProvider(create: (_) => ChangeButtonStyleController()),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xff3374B4),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: AppColors.primaryWhite,
            ),
            titleTextStyle: AppTextStyle.H1.copyWith(fontSize: 18, color: AppColors.primaryWhite),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
