import 'package:get_it/get_it.dart';

import 'dynamic_link_services.dart';
import 'navigator_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => NavigationService());
}
