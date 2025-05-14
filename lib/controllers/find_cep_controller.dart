import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final/database/domain/models/address.dart';
import 'package:projeto_final/database/domain/repositorys/address_repository.dart';

class FindCepController {
  final AddressRepository addressRepository;

  FindCepController({required this.addressRepository});

  final TextEditingController cepController = TextEditingController();

  Address? address;

  Future<Address> fetchAddress(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return address = Address.fromMap(data);
    } else {
      throw Exception("Erro ao buscar dados, Tente novamente");
    }
  }

  Future<void> saveOnFindAddress() async {
    if (address == null) return;
    await addressRepository.insertAddress(address!);
  }

  Future<List<Address>> getAllAddress() async {
    return await addressRepository.getAllAddress();
  }
}
