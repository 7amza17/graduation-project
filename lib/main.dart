import 'package:SMADI/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate VR',
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xFFF3F7FA),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'العقارات الافتراضية'),
    );
    
  }
  
}
