import 'package:get_it/get_it.dart';
import 'package:projeto_final/controllers/find_cep_controller.dart';
import 'package:projeto_final/database/db.dart';
import 'package:projeto_final/database/domain/repositorys/address_repository.dart';
import 'package:projeto_final/database/domain/repositorys/address_repository_impl.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(locator<DatabaseHelper>()),
  );

  locator.registerFactory(
    () => FindCepController(addressRepository: locator<AddressRepository>()),
  );
}
