import 'package:projeto_final/database/domain/models/address.dart';

abstract class AddressRepository {
  Future<void> insertAddress(Address address) async {}

  Future<List<Address>> getAllAddress();
}
