// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import 'cubit/authcubit_cubit.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: mainColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                translateString("Please enter code sent to your email ",
                    "من فضلك قم بإدخال الكود الذي تم ارساله الي بريدك الالكتروني"),
                maxLines: 4,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: (prefs.getString("lang") == 'en')
                        ? 'Nunito'
                        : 'Almarai',
                    fontSize: w * 0.04,
                    height: 1.5,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: h * 0.06,
            ),
            PinCodeTextField(
              length: 4,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                activeColor: mainColor,
                disabledColor: Colors.white,
                inactiveColor: mainColor,
                selectedColor: mainColor,
                errorBorderColor: Colors.red,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.white,
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: textEditingController,
              onCompleted: (v) {
                print(textEditingController.text);
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return true;
              },
              appContext: context,
            ),
            SizedBox(
              height: h * 0.06,
            ),
            BlocConsumer<AuthcubitCubit, AuthcubitState>(
              listener: (context, state) {},
              builder: (context, state) {
                return RoundedLoadingButton(
                  controller: _btnController,
                  successColor: mainColor,
                  color: mainColor,
                  disabledColor: mainColor,
                  onPressed: () async {
                    AuthcubitCubit.get(context).activationCode(
                        code: textEditingController.text,
                        context: context,
                        controller: _btnController);
                  },
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w * 0.08),
                      color: mainColor,
                    ),
                    child: Center(
                      child: Text(
                        LocalKeys.SEND.tr(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: (prefs.getString("lang") == 'en')
                                ? 'Nunito'
                                : 'Almarai',
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
