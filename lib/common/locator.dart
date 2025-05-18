import 'package:get_it/get_it.dart';
import 'package:clearpay/common/sharedPreferences.dart';

final getIt = GetIt.instance;
void setupDependencies() {
  getIt.registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
}
