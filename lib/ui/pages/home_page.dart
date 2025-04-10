import 'package:flutter/material.dart';
import 'package:projeto_final/ui/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _avatarImageUrl =
      'https://media.discordapp.net/attachments/1185026323194859522/1359734873274847353/Untitled.jpg?ex=67f88f48&is=67f73dc8&hm=7d78a7c6a52b883e7a60be10e8cc87d0cca858df55a169536b34ec7d500f207b&=&format=webp&width=530&height=960';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildHeader(), _buildActionButtons(context)],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const Icon(Icons.home, color: Colors.white),
      title: const Text('Home', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurpleAccent,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        const Text(
          "Bem Vindo(a)!",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepPurpleAccent, width: 3),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(_avatarImageUrl),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          iconInit: const Icon(Icons.qr_code_2_rounded, color: Colors.white),
          label: "QR Code Scan",
          iconFinish: const Icon(
            Icons.arrow_right_alt_sharp,
            color: Colors.white,
          ),

          onPressed: () => Navigator.pushNamed(context, '/qrCodeScan'),
        ),
        const SizedBox(height: 16),
        CustomButton(
          iconInit: const Icon(Icons.pin_drop_outlined, color: Colors.white),
          label: "Find Cep",
          onPressed: () => Navigator.pushNamed(context, '/findCep'),
          iconFinish: const Icon(
            Icons.arrow_right_alt_sharp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
