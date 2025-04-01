import 'package:get_it/get_it.dart';
import 'package:fintech_app/common/sharedPreferences.dart';

final getIt = GetIt.instance;
void setupDependencies() {
  getIt.registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
}
