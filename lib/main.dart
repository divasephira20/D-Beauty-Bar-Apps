import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/pastel_theme.dart';
import 'screens/main_shell.dart';
import 'database/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style: transparent status bar with dark icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize SQLite database (supports Web via sqflite_common_ffi_web, Desktop via FFI, Mobile native)
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint("SQLite initialization: $e");
  }

  runApp(const BeautyBarApp());
}

class BeautyBarApp extends StatelessWidget {
  const BeautyBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "D'Beauty Bar Bandung",
      debugShowCheckedModeBanner: false,
      theme: PastelTheme.theme,
      home: const MainShell(),
    );
  }
}
