import 'package:flutter/material.dart';
import 'package:projeto_final/config/di/locator.dart';
import 'package:projeto_final/controllers/find_cep_controller.dart';
import 'package:projeto_final/ui/widgets/custom_button.dart';

class FindCepPage extends StatefulWidget {
  const FindCepPage({super.key});

  @override
  State<FindCepPage> createState() => _FindCepPageState();
}

class _FindCepPageState extends State<FindCepPage> {
  late final FindCepController controller;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    controller = locator<FindCepController>();
  }

  @override
  void dispose() {
    controller.cepController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Buscar CEP', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurpleAccent,
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.cepController,
          decoration: const InputDecoration(
            labelText: 'Digite o CEP',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        CustomButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
              _error = null;
              controller.address = null;
            });
            try {
              await controller.fetchAddress(controller.cepController.text);
              await controller.saveOnFindAddress();
            } catch (e) {
              print(e);
              setState(() => _error = 'Erro de conexão. Tente novamente.');
            }

            setState(() => _isLoading = false);

            final teste = await controller.getAllAddress();
            for (var item in teste) {
              print(item.cep);
              print(item.bairro);
            }
          },
          label: "Buscar",
          iconInit: Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    if (controller.address == null) {
      return const SizedBox.shrink();
    }
    return _buildCepDetailCard();
  }

  Widget _buildCepDetailCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('CEP:', controller.address?.cep),
            _buildDetailRow('Logradouro:', controller.address?.logradouro),
            _buildDetailRow('Complemento:', controller.address?.complemento),
            _buildDetailRow('Bairro:', controller.address?.bairro),
            _buildDetailRow('Cidade:', controller.address?.localidade),
            _buildDetailRow('Estado:', controller.address?.uf),
            _buildDetailRow('DDD:', controller.address?.ddd),
            _buildDetailRow('IBGE:', controller.address?.ibge),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String? label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : 'N/A',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildInputSection(),
              const SizedBox(height: 24),
              _buildResultSection(),
            ],
          ),
        ),
      ),
    );
  }
}
