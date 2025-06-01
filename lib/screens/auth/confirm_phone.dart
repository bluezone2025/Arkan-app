import 'package:arkan/screens/auth/pin_code.dart';
import 'package:arkan/screens/auth/sign_upScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import 'cubit/authcubit_cubit.dart';

class ConfirmPhone extends StatefulWidget {
  const ConfirmPhone({Key? key}) : super(key: key);

  @override
  _ConfirmPhoneState createState() => _ConfirmPhoneState();
}

class _ConfirmPhoneState extends State<ConfirmPhone> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _controller = TextEditingController();
  String lang = '';

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

    return PreferredSize(
      preferredSize: Size(w, h),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icons/splash.png"),
                    fit: BoxFit.fill)),
          ),
          BlocConsumer<AuthcubitCubit, AuthcubitState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Container(
                          width: w,
                          height: h,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/icons/Rectangle.png"),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: ListView(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(
                                      Icons.keyboard_arrow_left,
                                      color: Colors.white,
                                      size: w * 0.13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: w * 0.05,
                                      right: w * 0.05,
                                      top: h * 0.06),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          "assets/icons/logo.png",
                                          width: w * 0.5,
                                        ),
                                      ),
                                      Container(
                                        height: h * 0.07,
                                        width: w * 0.8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(w * 0.07),
                                          border:
                                              Border.all(color: Colors.black38),
                                          color: Colors.black,
                                        ),
                                        child: Center(
                                          child: Text(
                                            LocalKeys.RESETPASS.tr(),
                                            style: TextStyle(
                                                fontSize: w * 0.05,
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.04,
                                      ),
                                      Text(
                                        LocalKeys.ENTER_PHONE.tr(),
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color: Colors.black,
                                            height: 2,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        LocalKeys.ENTER_PHONE2.tr(),
                                        style: TextStyle(
                                            fontSize: w * 0.035,
                                            height: 2,
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: h * 0.05,
                                      ),
                                      TextFormField(
                                        controller: _controller,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.done,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            _btnController.error();
                                            Future.delayed(
                                                const Duration(seconds: 1));
                                            _btnController.stop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(translateString(
                                                        "Enter this field",
                                                        "هذا الحقل مطلوب"))));
                                          }
                                          if (!value.contains("@")) {
                                            _btnController.error();
                                            Future.delayed(
                                                const Duration(seconds: 1));
                                            _btnController.stop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(translateString(
                                                        "Email is invalid",
                                                        "البريد الالكتروني غير صحيح"))));
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            focusedBorder: form(),
                                            enabledBorder: form(),
                                            errorBorder: form(),
                                            focusedErrorBorder: form(),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: LocalKeys.EMAIL.tr(),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            errorMaxLines: 1,
                                            errorStyle:
                                                TextStyle(fontSize: w * 0.03)),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(
                                        height: h * 0.06,
                                      ),
                                      BlocConsumer<AuthcubitCubit,
                                          AuthcubitState>(
                                        listener: (context, state) {
                                          if (state is CheckPhoneSuccessState) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const VerificationCodeScreen()));
                                            Fluttertoast.showToast(
                                                msg: translateString(
                                                    "verification code have been sent to your email address",
                                                    "تم ارسال كود التفعيل الي بريدك الالكتروني "),
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                gravity: ToastGravity.CENTER,
                                                toastLength: Toast.LENGTH_LONG);
                                          }
                                        },
                                        builder: (context, state) {
                                          return RoundedLoadingButton(
                                            controller: _btnController,
                                            successColor: mainColor,
                                            color: mainColor,
                                            disabledColor: mainColor,
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                AuthcubitCubit.get(context)
                                                    .checkPhone(
                                                        context: context,
                                                        controller:
                                                            _btnController,
                                                        email:
                                                            _controller.text);
                                              } else {
                                                _btnController.error();
                                                await Future.delayed(
                                                    const Duration(seconds: 1));
                                                _btnController.stop();
                                              }
                                            },
                                            child: Container(
                                              height: h * 0.08,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.08),
                                                color: mainColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  LocalKeys.SEND.tr(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      fontSize: w * 0.045,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: h * 0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            LocalKeys.NOT_HAVE_ACCOUNT.tr(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontSize: w * 0.035,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: w * 0.01,
                                          ),
                                          InkWell(
                                            child: Text(
                                              LocalKeys.REGISTER.tr(),
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
                                                          SignupScreen()));
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                );
              },
              listener: (context, state) {}),
        ],
      ),
    );
  }

  InputBorder form() {
    double w = MediaQuery.of(context).size.width;
    return OutlineInputBorder(
      borderSide: const BorderSide(color: (Colors.black54), width: 1),
      borderRadius: BorderRadius.circular(w * 0.08),
    );
  }
}
