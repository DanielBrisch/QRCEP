import 'package:flutter/material.dart';
import 'package:projeto_final/ui/pages/find_cep_page.dart';
import 'package:projeto_final/ui/pages/home_page.dart';
import 'package:projeto_final/ui/pages/scan_qr_code_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR CEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/qrCodeScan': (context) => const ScanQrCodePage(),
        '/findCep': (context) => const FindCepPage(),
      },
    );
  }
}
