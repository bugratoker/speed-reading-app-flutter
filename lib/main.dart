import 'dart:io';
import 'package:flutter_application_2/models/settings_model.dart';
import 'package:flutter_application_2/pages/login/views/login_page.dart';
import 'package:flutter_application_2/pages/register/views/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
        create: (_) => SettingsModel(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(centerTitle: true),
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 71, 149, 222),
              brightness: Brightness.light,
              background: const Color.fromARGB(255, 192, 210, 236)
            ),
            textTheme: TextTheme(
              displayLarge: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
              displayMedium: GoogleFonts.fjallaOne(
                fontSize: 26,
                fontStyle: FontStyle.normal,
              ),
              titleLarge: GoogleFonts.oswald(
                fontSize: 30,
                fontStyle: FontStyle.normal,
              ),
              bodyMedium: GoogleFonts.merriweather(),
              displaySmall: GoogleFonts.fjallaOne(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                color: Colors.white60
              ),
            ),
          ),
          home: const RegisterPage(),
        ));
  }
}
