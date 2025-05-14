import 'package:projeto_final/config/constants/table_names.dart';
import 'package:projeto_final/database/db.dart';
import 'package:projeto_final/database/domain/models/address.dart';
import 'package:projeto_final/database/domain/repositorys/address_repository.dart';
import 'package:sqflite/sqflite.dart';

class AddressRepositoryImpl implements AddressRepository {
  final DatabaseHelper _dbHelper;

  AddressRepositoryImpl(this._dbHelper);

  Future<Database> get _db async => await _dbHelper.db;

  @override
  Future<void> insertAddress(Address address) async {
    final db = await _db;
    await db.insert(
      address_table,
      address.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Address>> getAllAddress() async {
    final db = await _db;
    final queryResult = await db.query(address_table);

    final addresses =
        queryResult.map((row) {
          return Address.fromMap(row);
        }).toList();
    return addresses;
  }
}
