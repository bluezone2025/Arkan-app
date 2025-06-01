// ignore_for_file: avoid_print

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../screens/product_detail/product_detail.dart';
import '../screens/tabone_screen/cubit/home_cubit.dart';
import 'locator.dart';
import 'navigator_service.dart';

class DynamicLinkService {
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleDynamicLinks(context) async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(context, data!);

    FirebaseDynamicLinks.instance.onLink.listen(
        (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(context, dynamicLink);
    }, onError: (e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(context, PendingDynamicLinkData data) async {
    final Uri? deepLink = data.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      // Check if we want to make a Code
      var isProduct = deepLink.pathSegments.contains('');

      if (isProduct) {
        // get the code of the Code
        var productId = deepLink.queryParameters[''];

        if (productId != null) {
          HomeCubit.get(context).getProductdata(productId: productId);
          _navigationService.navigateTo(ProductDetail());
        }
      }
    }
  }
}
