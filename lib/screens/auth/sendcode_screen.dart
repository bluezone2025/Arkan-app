import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../../componnent/constants.dart';
import 'change_pass_screen.dart';

class SendCodeScreen extends StatefulWidget {
  const SendCodeScreen({super.key, required this.forget});

  final bool forget;

  @override
  State<SendCodeScreen> createState() => _SendCodeScreenState();
}

class _SendCodeScreenState extends State<SendCodeScreen> {

  int secondsRemaining = 60;
  bool enableResend = false;
  late Timer timer;
  late String otpCode;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  void _resendCode() {
    //other code here
    setState((){
      secondsRemaining = 60;
      enableResend = false;
    });
  }

  @override
  dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02*w),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 0.08*h),
                  Image.asset('assets/icons/code_send.png',height: 0.27*h,),
                  SizedBox(height: 0.02*h),
                  Text('كود التفعيل',style:TextStyle(
                  fontFamily: 'Almarai',
                fontSize: w * 0.035,
                fontWeight: FontWeight.w600,
                color: Colors.black),textAlign: TextAlign.center,),
                  SizedBox(height: 0.01*h),
                  Text('أدخل رقمًا مكونًا من 4 أرقام ',style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),textAlign: TextAlign.center),
                  SizedBox(height: 0.01*h),
                  Text('تم الإرسال إلى ',style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w600,
                      color: mainColor),textAlign: TextAlign.center),
                  SizedBox(height: 0.01*h),
                  Text('+965 12312345',style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: w * 0.025,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),textAlign: TextAlign.center,),
                  Text('Bluezone.Adv@Gmail.Com',style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: w * 0.025,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),textAlign: TextAlign.center,),
                  SizedBox(height: 0.01*h),
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w*0.04,vertical: 0.04*h),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 0.6*w,
                              child: PinCodeTextField(
                                appContext: context,
                                autoFocus: true,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                length: 4,
                                obscureText: false,
                                animationType: AnimationType.scale,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  fieldHeight: 0.07*h,
                                  fieldWidth: 0.1*w,
                                  borderWidth: 1,
                                  activeColor: Colors.grey,
                                  inactiveColor: Colors.grey,
                                  inactiveFillColor: Colors.white,
                                  activeFillColor: Colors.white,
                                  selectedColor: mainColor,
                                  selectedFillColor: Colors.white,
                                ),
                                animationDuration: const Duration(milliseconds: 300),
                                backgroundColor: Colors.white,
                                enableActiveFill: true,
                                onCompleted: (submitedCode) {
                                  otpCode = submitedCode;
                                },
                                onChanged: (value) {
                                },
                              ),
                            ),
                            SizedBox(height: 0.01*h),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePassScreen(forget: widget.forget)));
                                // if(widget.forget){
                                //   Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePassScreen(forget: widget.forget)));
                                // }else{
                                //   _settingModalBottomSheet(context);
                                //   Timer(const Duration(seconds: 1), () {
                                //     Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
                                //   });
                                // }
                              },
                              child: Container(
                                height: 0.06*h,
                                width: 0.8*w,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                      'تفعيل',
                                      style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.01*h),
                  enableResend ?InkWell(
                    onTap: (){
                      _resendCode();
                    },
                    child: Text(
                      'أعد إرسال الرمز',
                      style: TextStyle(
                    fontFamily: 'Almarai',
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w600,
                      color: mainColor),
                    ),
                  ):Text(
                      "${'أعد إرسال الرمز في'} $secondsRemaining",
                    style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: w * 0.03,
                        fontWeight: FontWeight.w600,
                        color: mainColor),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
