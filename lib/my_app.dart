import 'package:flutter/material.dart';
import 'package:risknotifier/features/riskNotifier/presentation/widgets/splash_screen.dart';
import 'config/themes/app_themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiskNotifier',
      theme: AppTheme.lightTheme(context),
      debugShowCheckedModeBanner: false,
      home:
          const SplashScreen(), // Burada başlangıç sayfasını SplashScreen olarak ayarlayın
    );
  }
}
