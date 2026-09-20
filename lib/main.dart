import 'package:fighting_game/controllers/character_select_controller.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/controllers/settings_controller.dart';
import 'package:fighting_game/screens/home_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Khởi tạo các Global Controllers của GetX
  Get.put(SettingsController(), permanent: true);
  Get.put(GameMatchController(), permanent: true);
  Get.put(CharacterSelectController(), permanent: true);

  // Lock to landscape before game UI mounts
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const FightingGameApp());
}

class FightingGameApp extends StatelessWidget {
  const FightingGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Valor Awakening',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.cinzelTextTheme(ThemeData.dark().textTheme),
      ),
      home: const HomeLoadingScreen(),
    );
  }
}
