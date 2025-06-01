// ignore_for_file: use_key_in_widget_constructors, file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import 'cubit/authcubit_cubit.dart';
import 'login.dart';

final _formKey = GlobalKey<FormState>();
final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();

late Timer timer;
int counter = 60;
bool dialogSms = false, makeError = false, finishSms = true, checkRe = false;
// ignore: unused_field
bool visibility1 = true, visibility2 = true, check = true;
FocusNode focusNode1 = FocusNode();
FocusNode focusNode2 = FocusNode();
FocusNode focusNode3 = FocusNode();
FocusNode focusNode4 = FocusNode();
FocusNode focusNode5 = FocusNode();
TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();

String? verificationId;
String? countryCode;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String lang = '';
  bool agree = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthcubitCubit, AuthcubitState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                    backgroundColor: const Color(0xffF8F8F8),
                    body: SafeArea(
                      child: SizedBox(
                        width: w,
                        height: h,
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Center(
                                    child: Image.asset(
                                      "assets/icons/logo.png",
                                      width: w * 0.3,
                                      height: h * 0.15,
                                      fit: BoxFit.contain,
                                    )),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Text(translateString('Signup', 'تسجيل حساب'),
                                  style: TextStyle(
                                      fontFamily: (lang == 'en')
                                          ? 'Nunito'
                                          : 'Almarai',
                                      color: mainColor,
                                      fontWeight:
                                      FontWeight.w700,
                                      fontSize: w * 0.05),),
                                SizedBox(
                                  width: w,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.07),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          LocalKeys.NAME.tr(),
                                          style: TextStyle(
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontSize: w * 0.035,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        nametextFormField(),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          LocalKeys.PHONE.tr(),
                                          style: TextStyle(
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontSize: w * 0.035,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        phoneFormField(),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          LocalKeys.EMAIL.tr(),
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        emailtextFormField(),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          LocalKeys.PASSWORD.tr(),
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        passwordTextFormField(),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          LocalKeys.CONFIRM_PASS.tr(),
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        confirmpasswordTextFormField(),
                                        SizedBox(
                                          height: h * 0.02,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  agree = !agree;
                                                });
                                              },
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: mainColor,width: 2),
                                                ),
                                                child: agree == true
                                                    ? Container(
                                                  height: 5,
                                                  width: 5,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: mainColor,
                                                  ),
                                                )
                                                    : const SizedBox(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 0.01*w,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  translateString('Agree for', 'أوافق على . '),
                                                  style: TextStyle(
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      color: Colors.black,
                                                      fontSize: w * 0.027,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  translateString('Terms & Conditions', 'الشروط والأحكام'),
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontSize: w * 0.027,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Center(
                                          child: SizedBox(
                                            width: w*0.6,
                                            child: RoundedLoadingButton(
                                              controller: _btnController,
                                              successColor: mainColor,
                                              color: mainColor,
                                              borderRadius: 10,
                                              width: w*0.3,
                                              height: h * 0.06,
                                              disabledColor: Colors.black,
                                              errorColor: Colors.red,
                                              valueColor: Colors.white,
                                              onPressed: () async {
                                                FocusScope.of(context).unfocus();
                                                if (_formKey.currentState!.validate()) {
                                                  FocusScope.of(context).unfocus();
                                                  AuthcubitCubit.get(context).register(
                                                      controller: _btnController,
                                                      email: email.text,
                                                      password: password.text,
                                                      name: name.text,
                                                      phone: phoneController.text,
                                                      confirmpassword:
                                                      confirmPassword.text,
                                                      context: context);
                                                } else {
                                                  _btnController.error();
                                                  _btnController.stop();
                                                }

                                              },
                                              child: Center(
                                                  child: Text(
                                                    translateString('Signup', 'تسجيـــل'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w * 0.05,
                                                        fontWeight: FontWeight.bold),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                             translateString( LocalKeys.HAVE_ACCOUNT.tr(), 'لديك حساب ؟'),
                                              style: TextStyle(
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  color: Colors.black,
                                                  fontSize: w * 0.035,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: w * 0.01,
                                            ),
                                            InkWell(
                                              child: Text(
                                                translateString(LocalKeys.LOG_IN.tr(), 'سجل دخول'),
                                                style: TextStyle(
                                                  color: mainColor,
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  fontSize: w * 0.035,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        const Login()));
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                    )))
          );
        },
        listener: (context, state) {});
  }

  Widget nametextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        controller: name,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.start,
        cursorColor: Colors.black,
        obscureText: false,
        textInputAction: TextInputAction.next,
        focusNode: focusNode1,
        onEditingComplete: () {
          focusNode1.unfocus();

          FocusScope.of(context).requestFocus(focusNode2);
        },
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            color: Colors.red,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          hintText: translateString('name', 'الاسم'),
          hintStyle: TextStyle(
            color: Colors.black45,fontSize: w*0.03,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
        ),
      ),
    );
  }

  Widget emailtextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.start,
        cursorColor: Colors.black,
        obscureText: false,
        textInputAction: TextInputAction.next,
        focusNode: focusNode2,
        onEditingComplete: () {
          focusNode2.unfocus();
          FocusScope.of(context).requestFocus(focusNode3);
        },
        validator: (value) {
          if (value!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    translateString("Enter this field", "هذا الحقل مطلوب"))));
          }
          if (!value.contains("@")) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(translateString(
                    "Email is invalid", "البريد الالكتروني غير صحيح"))));
          }
          return null;
        },
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            color: Colors.red,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          hintText: LocalKeys.EMAIL.tr(),
          hintStyle: TextStyle(
            color: Colors.black45,fontSize: w*0.03,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
        ),
      ),
    );
  }

  Widget phoneFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: Colors.black,
          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
        ),
        textAlign: TextAlign.start,
        cursorColor: Colors.black,
        obscureText: false,
        textInputAction: TextInputAction.next,
        focusNode: focusNode3,
        onEditingComplete: () {
          focusNode3.unfocus();

          FocusScope.of(context).requestFocus(focusNode4);
        },
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            color: Colors.red,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          hintText: LocalKeys.PHONE.tr(),
          hintStyle: TextStyle(
            color: Colors.black45,fontSize: w*0.03,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
        ),
      ),
    );
  }

  passwordTextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        controller: password,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.start,
        cursorColor: Colors.black,
        obscureText: visibility1,
        textInputAction: TextInputAction.next,
        focusNode: focusNode4,
        onEditingComplete: () {
          focusNode4.unfocus();

          FocusScope.of(context).requestFocus(focusNode5);
        },
        decoration: InputDecoration(
          prefixIcon: SvgPicture.asset('assets/icons/lock.svg'),
          prefixIconConstraints: BoxConstraints(maxHeight: 0.05*h,minWidth: 0.1*w),
          contentPadding: EdgeInsets.only(top:0.02*h),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                visibility1 = false;
              });
            },
            child: (visibility1 == true)
                ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.black45,
                  )
                : const Icon(
                    Icons.visibility_outlined,
                    color: Colors.black45,
                  ),
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            color: Colors.red,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          hintText: LocalKeys.PASSWORD.tr(),
          hintStyle: TextStyle(
            color: Colors.black45,fontSize: w*0.03,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
        ),
      ),
    );
  }

  Widget confirmpasswordTextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        controller: confirmPassword,
        style: TextStyle(
          color: Colors.black,
          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
        ),
        textAlign: TextAlign.start,
        cursorColor: Colors.black,
        obscureText: visibility2,
        textInputAction: TextInputAction.done,
        focusNode: focusNode5,
        onEditingComplete: () {
          focusNode5.unfocus();
        },
        decoration: InputDecoration(
          prefixIcon: SvgPicture.asset('assets/icons/lock.svg'),
          prefixIconConstraints: BoxConstraints(maxHeight: 0.05*h,minWidth: 0.1*w),
          contentPadding: EdgeInsets.only(top:0.02*h),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                visibility2 = false;
              });
            },
            child: (visibility2 == true)
                ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.black45,
                  )
                : const Icon(
                    Icons.visibility_outlined,
                    color: Colors.black45,
                  ),
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            color: Colors.red,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          hintText: LocalKeys.PASSWORD.tr(),
          hintStyle: TextStyle(
            color: Colors.black45,fontSize: w*0.03,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    double w = MediaQuery.of(context).size.width;

    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black38, width: 1),
      borderRadius: BorderRadius.circular(w * 0.8),
    );
  }
}
