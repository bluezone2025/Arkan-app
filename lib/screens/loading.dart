import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../componnent/constants.dart';


class LoadingWidget extends StatelessWidget {
  final Indicator indicator;
  final double size;

  const LoadingWidget({
    Key? key,
    this.size = 150,
    this.indicator = Indicator.ballScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: LoadingIndicator(
          indicatorType: indicator,
          colors: [mainColor],
        ),
      ),
    );
  }
}

class LoadingScreen {
  LoadingScreen._();

  static BuildContext? _buildContext;

  static Future<void> show(BuildContext context) {
    _buildContext = context;
    return showDialog(
      context: context,
      barrierDismissible: kDebugMode,
      builder: (context) {
        return const Center(
          child: LoadingWidget(
            indicator: Indicator.ballScale,
          ),
        );
      },
    );
  }

  static void pop(BuildContext context) async {
    Navigator.pop(_buildContext!);
  }
}

Widget showLoadingIndicator() {
  return  Center(
    child: CircularProgressIndicator(
      color: mainColor,
    ),
  );
}