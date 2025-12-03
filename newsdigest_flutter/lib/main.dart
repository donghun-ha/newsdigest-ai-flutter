import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'package:newsdigest_flutter/core/constants/colors.dart';
import 'package:newsdigest_flutter/presentation/screens/splash_screen.dart';

void main() {
  runApp(DevicePreview(
      enabled: true,
      builder: (BuildContext context) =>
          const ProviderScope(child: NewsDigestApp())));
}

class NewsDigestApp extends StatelessWidget {
  const NewsDigestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsDigest AI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
