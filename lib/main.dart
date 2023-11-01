import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/config/config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:renalizapp/features/settings/providers/theme_notifier.dart';
import 'features/shared/infrastructure/provider/auth_provider.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<bool> getDarkModePreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode') ?? false;
}


void setDarkModePreference(bool isDarkMode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', isDarkMode);
}


void main() async {
  await Environment.initEnvironment();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: ChangeNotifierProvider.value(
        value: themeNotifier,
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {


  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    final themeNotifier = context.watch<ThemeNotifier>();
    

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.isDarkMode
          ? AppTheme().getDarkTheme()
          : AppTheme().getLightTheme(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español
      ],
    );
  }
}
