import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrCodePage extends StatefulWidget {
  const ScanQrCodePage({super.key});

  @override
  State<ScanQrCodePage> createState() => _ScanQrCodePageState();
}

class _ScanQrCodePageState extends State<ScanQrCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.deepPurpleAccent,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(child: Text('Aponte a câmera para um QR Code')),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Escanear QR Code',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurpleAccent,
    );
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    controller!.scannedDataStream.listen((scanData) async {
      if (hasScanned) return;
      setState(() => hasScanned = true);

      final url = scanData.code ?? '';
      await _openLink(url);

      controller?.pauseCamera();
    });
  }

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (_isSocialLink(url)) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        _showError('Não foi possível abrir o link.');
      }
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  bool _isSocialLink(String url) {
    return url.contains('instagram.com') ||
        url.contains('whatsapp.com') ||
        url.contains('facebook.com') ||
        url.contains('tiktok.com') ||
        url.contains('twitter.com') ||
        url.contains('linkedin.com');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
