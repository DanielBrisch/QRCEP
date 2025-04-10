import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final/ui/widgets/custom_button.dart';

class FindCepPage extends StatefulWidget {
  const FindCepPage({super.key});

  @override
  State<FindCepPage> createState() => _FindCepPageState();
}

class _FindCepPageState extends State<FindCepPage> {
  final TextEditingController _cepController = TextEditingController();
  Map<String, dynamic>? _cepData;
  bool _isLoading = false;
  String? _error;

  Future<void> _fetchCep(String cep) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _cepData = null;
    });

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('erro') && data['erro'] == true) {
          setState(() => _error = 'CEP não encontrado.');
        } else {
          setState(() => _cepData = data);
        }
      } else {
        setState(() => _error = 'Erro na busca. Tente novamente.');
      }
    } catch (e) {
      setState(() => _error = 'Erro de conexão.');
    } finally {
      setState(() => _isLoading = false);
    }
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
          controller: _cepController,
          decoration: const InputDecoration(
            labelText: 'Digite o CEP',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        CustomButton(
          onPressed: () {
            _fetchCep(_cepController.text);
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
    if (_cepData == null) {
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
            _buildDetailRow('CEP:', _cepData!['cep']),
            _buildDetailRow('Logradouro:', _cepData!['logradouro']),
            _buildDetailRow('Complemento:', _cepData!['complemento']),
            _buildDetailRow('Bairro:', _cepData!['bairro']),
            _buildDetailRow('Cidade:', _cepData!['localidade']),
            _buildDetailRow('Estado:', _cepData!['uf']),
            _buildDetailRow('DDD:', _cepData!['ddd']),
            _buildDetailRow('IBGE:', _cepData!['ibge']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
  void dispose() {
    _cepController.dispose();
    super.dispose();
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
