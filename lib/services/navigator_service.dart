import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  Future<dynamic> navigateTo(Widget routeName) {
    return _navigationKey.currentState!
        .push(MaterialPageRoute(builder: (_) => routeName));
  }
}
