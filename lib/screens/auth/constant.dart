// ignore_for_file: avoid_print

// import 'dart:async';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rayan_store/componnent/constants.dart';
// import 'package:rayan_store/generated/local_keys.dart';
// import 'package:rayan_store/screens/auth/cubit/authcubit_cubit.dart';
// import 'package:rayan_store/screens/auth/sign_upScreen.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../bottomnav/homeScreen.dart';

// Future fireSms(
//     {context,
//     required String phone,
//     required RoundedLoadingButtonController btnController}) async {
//   final TextEditingController sms = TextEditingController();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   double w = MediaQuery.of(context).size.width;
//   double h = MediaQuery.of(context).size.height;
//   final String countryCode = prefs.getString('country_code').toString();
//   try {
//     String ph = "+" + countryCode + phone;
//     Future<PhoneVerificationFailed?> verificationFailed(
//         FirebaseAuthException authException) async {
//       checkRe = false;
//       await Future.delayed(const Duration(milliseconds: 1000));
//       btnController.stop();
//       final snackBar = SnackBar(
//         content: Text(LocalKeys.FIREBASE_ERROR.tr()),
//         action: SnackBarAction(
//           label: LocalKeys.UNDO.tr(),
//           disabledTextColor: Colors.yellow,
//           textColor: Colors.yellow,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       return null;
//     }

//     Future<PhoneCodeAutoRetrievalTimeout?> autoTimeout(String varId) async {
//       finishSms = true;
//       checkRe = false;
//       verificationId = varId;
//       btnController.stop();
//       return null;
//     }

//     print("phone: $ph");
//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: ph,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (AuthCredential credential) async {
//           print("enterrred");
//           try {
//             var result =
//                 await FirebaseAuth.instance.signInWithCredential(credential);
//             var ha = result.user;
//             if (ha != null) {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               await prefs.setBool('login', true);

//               Navigator.pop(context, 'ok');
//               timer.cancel();
//               AuthcubitCubit.get(context).register(
//                   confirmpassword: confirmPassword.text,
//                   password: password.text,
//                   name: name.text,
//                   email: email.text,
//                   phone: phoneController.text,
//                   context: context,
//                   controller: btnController);
//               Navigator.pop(context);
//               print("successsssssssssssssssssssssssssssssssssssssssss");
//             }
//           } catch (e) {
//             print("errrrrrrrror");
//             print(e.toString);
//             btnController.error();
//             await Future.delayed(const Duration(milliseconds: 1000));
//             btnController.stop();
//           }
//         },
//         verificationFailed: verificationFailed,
//         codeSent: (String verificationId, [int? forceResendingToken]) {
//           checkRe = false;
//           finishSms = false;
//           if (dialogSms) {
//             dialogSms = false;
//             Navigator.pop(context);
//           }
//           showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (ctx) {
//                 final _formKey2 = GlobalKey<FormState>();
//                 btnController.stop();
//                 return Form(
//                   key: _formKey2,
//                   child: AlertDialog(
//                     title: Align(
//                       alignment: Alignment.topLeft,
//                       child: IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: () {
//                           timer.cancel();
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                     titlePadding:
//                         const EdgeInsets.only(left: 0, bottom: 0, right: 0),
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                     ),
//                     content: SizedBox(
//                       height: h * 30 / 100,
//                       child: Column(
//                         children: <Widget>[
//                           Align(
//                             child: Text(
//                               LocalKeys.ACTIVE_CODE.tr(),
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: mainColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: w * 5 / 100),
//                             ),
//                             alignment: Alignment.center,
//                           ),
//                           SizedBox(
//                             height: h * 2 / 100,
//                           ),
//                           TextFormField(
//                             controller: sms,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderSide:
//                                       const BorderSide(color: Colors.black),
//                                   borderRadius: BorderRadius.circular(10)),
//                               hintText: LocalKeys.HINT_CODE.tr(),
//                               contentPadding: EdgeInsets.only(
//                                   left: w * 0.02, right: w * 0.02),
//                             ),
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return LocalKeys.VALID_ERROR.tr();
//                               }
//                               if (makeError) {
//                                 return LocalKeys.ERROR_CODE.tr();
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(
//                             height: h * 1.5 / 100,
//                           ),
//                           StatefulBuilder(
//                             builder: (context2, setState3) {
//                               if (counter == 60) {
//                                 timer = Timer.periodic(
//                                     const Duration(seconds: 1), (e) {
//                                   if (e.isActive) {
//                                     setState3(() {
//                                       counter--;
//                                     });
//                                   }
//                                   if (counter == 0) {
//                                     e.cancel();
//                                   }
//                                 });
//                               }
//                               return SizedBox(
//                                 width: double.infinity,
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     InkWell(
//                                       child: RichText(
//                                         text: TextSpan(children: [
//                                           TextSpan(
//                                               text: "Resend",
//                                               style: TextStyle(
//                                                   color: mainColor,
//                                                   fontSize: w * 0.035)),
//                                         ]),
//                                       ),
//                                       onTap: () {
//                                         if (counter == 0) {
//                                           if (!checkRe) {
//                                             checkRe = true;
//                                             timer.cancel();
//                                             dialogSms = true;
//                                             fireSms(
//                                                 phone: phone,
//                                                 context: context,
//                                                 btnController: btnController);
//                                           }
//                                         }
//                                       },
//                                     ),
//                                     SizedBox(
//                                       width: w * 0.02,
//                                     ),
//                                     Text(counter.toString(),
//                                         style: const TextStyle(
//                                             color: Colors.black)),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                           SizedBox(
//                             height: h * 1.5 / 100,
//                           ),
//                           BlocConsumer<AuthcubitCubit, AuthcubitState>(
//                             listener: (context, state) {
//                               if (state is RegisterSuccessState) {
//                                 Navigator.pushAndRemoveUntil(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => HomeScreen(
//                                               index: 0,
//                                             )),
//                                     (route) => false);
//                               }
//                             },
//                             builder: (context, state) {
//                               return InkWell(
//                                 child: Container(
//                                   width: w * 30 / 100,
//                                   height: h * 6 / 100,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(7),
//                                       border: Border.all(color: Colors.black)),
//                                   child: Center(
//                                     child: Text(
//                                       LocalKeys.SEND.tr(),
//                                       style: TextStyle(
//                                           color: mainColor,
//                                           fontSize: w * 4.5 / 100,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                                 onTap: () async {
//                                   if (_formKey2.currentState!.validate()) {
//                                     try {
//                                       FocusScope.of(context).unfocus();
//                                       AuthCredential credential =
//                                           PhoneAuthProvider.credential(
//                                               verificationId: verificationId,
//                                               smsCode: sms.text);
//                                       final User? user = (await FirebaseAuth
//                                               .instance
//                                               .signInWithCredential(credential))
//                                           .user;
//                                       if (user != null || user?.uid != '') {
//                                         SharedPreferences prefs =
//                                             await SharedPreferences
//                                                 .getInstance();
//                                         prefs.setBool('login', true);
//                                         Navigator.pop(context);
//                                         timer.cancel();
//                                         AuthcubitCubit.get(context).register(
//                                             name: name.text,
//                                             email: email.text,
//                                             password: password.text,
//                                             confirmpassword:
//                                                 confirmPassword.text,
//                                             context: context,
//                                             phone: phone,
//                                             controller: btnController);
//                                         Navigator.pop(context);
//                                         print(
//                                             "user access code successsssssss");
//                                       }
//                                     } catch (e) {
//                                       final snackBar = SnackBar(
//                                         content:
//                                             Text(LocalKeys.FIREBASE_ERROR.tr()),
//                                         action: SnackBarAction(
//                                           label: LocalKeys.UNDO.tr(),
//                                           disabledTextColor: Colors.yellow,
//                                           textColor: Colors.yellow,
//                                           onPressed: () {
//                                             ScaffoldMessenger.of(context)
//                                                 .hideCurrentSnackBar();
//                                           },
//                                         ),
//                                       );
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(snackBar);
//                                       print("firebase errrrrroooor : " +
//                                           e.toString());
//                                       makeError = true;
//                                       if (_formKey2.currentState!.validate()) {
//                                         print('hamza2');
//                                       }
//                                       makeError = false;
//                                       print('hamza3');
//                                     }
//                                   } else {
//                                     print('hamza4');
//                                   }
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     contentPadding: EdgeInsets.only(
//                         top: 0,
//                         right: w * 2 / 100,
//                         left: w * 2 / 100,
//                         bottom: 0),
//                   ),
//                 );
//               }).then((value) {
//             if (value == null) {
//               btnController.reset();
//             }
//           });
//         },
//         codeAutoRetrievalTimeout: autoTimeout);
//   } catch (e) {
//     btnController.error();
//     await Future.delayed(const Duration(milliseconds: 1000));
//     btnController.stop();
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(60)),
//               ),
//               content: SizedBox(
//                   height: h * 0.5,
//                   width: h / 3.5,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [Text(e.toString())],
//                     ),
//                   )),
//             ));
//   }
// }
