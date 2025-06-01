// ignore_for_file: avoid_print, unnecessary_string_interpolations
import 'package:arkan/screens/auth/sendcode_screen.dart';
import 'package:arkan/screens/auth/sign_upScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../bottomnav/homeScreen.dart';
import 'confirm_phone.dart';
import 'cubit/authcubit_cubit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool select = true;
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  bool isVisible = false;
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
    print([3, Navigator.canPop(context)]);
    return PreferredSize(
        preferredSize: Size(w, h),
        child: BlocConsumer<AuthcubitCubit, AuthcubitState>(
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
                                      Text(translateString('Welcome Again', 'أهــلا بـك مجـدداً'),
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color: mainColor,
                                            fontWeight:
                                            FontWeight.w700,
                                            fontSize: w * 0.05),),
                                      SizedBox(
                                        height: h * 0.1,
                                      ),
                                      Text(
                                        LocalKeys.LOG_IN.tr(),
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.w700,
                                            fontSize: w * 0.04),
                                      ),
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
                                                LocalKeys.PHONE.tr(),
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    fontSize: w * 0.035),
                                              ),
                                              SizedBox(
                                                height: h * 0.01,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: w * 0.03,
                                                    right: w * 0.03),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(25)),
                                                child: TextFormField(
                                                  controller:
                                                      editingController1,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          (lang == 'en')
                                                              ? 'Nunito'
                                                              : 'Almarai',
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  focusNode: focusNode1,
                                                  onEditingComplete: () {
                                                    focusNode1.unfocus();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode2);
                                                  },
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    focusedErrorBorder:
                                                        InputBorder.none,
                                                    errorStyle: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        color: Colors.white),
                                                    hintText:
                                                        LocalKeys.PHONE.tr(),
                                                    hintStyle: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',fontSize: w*0.03,
                                                        color:
                                                            Colors.black45),
                                                    labelStyle: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                              Text(
                                                LocalKeys.PASSWORD.tr(),
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontSize: w * 0.035),
                                              ),
                                              SizedBox(
                                                height: h * 0.01,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: w * 0.03,
                                                    right: w * 0.03),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(25)),
                                                child: TextFormField(
                                                  controller:
                                                      editingController2,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                  obscureText:
                                                      (isVisible == true)
                                                          ? false
                                                          : true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  focusNode: focusNode2,
                                                  onEditingComplete: () {
                                                    focusNode2.unfocus();
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "Field required")));
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      suffixIcon: InkWell(
                                                        child: (isVisible ==
                                                                true)
                                                            ? const Icon(
                                                                Icons
                                                                    .visibility_outlined,
                                                                color: Colors
                                                                    .black45,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .visibility_off_outlined,
                                                                color: Colors
                                                                    .black45,
                                                              ),
                                                        onTap: () {
                                                          setState(() {
                                                            isVisible = true;
                                                          });
                                                        },
                                                      ),
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                      errorStyle: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai',
                                                          color:
                                                              Colors.white),
                                                      hintText: LocalKeys
                                                          .PASSWORD
                                                          .tr(),
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              (lang == 'en')
                                                                  ? 'Nunito'
                                                                  : 'Almarai', fontSize: w * 0.03,
                                                          color:
                                                              Colors.black45),
                                                      fillColor:
                                                          Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.03,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      LocalKeys.FORGET_PASSWORD
                                                          .tr(),
                                                      style: TextStyle(
                                                        fontFamily: (lang == 'en')
                                                            ? 'Nunito'
                                                            : 'Almarai',
                                                        color: mainColor,
                                                        fontSize: w * 0.028,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      _forgetPassModalBottomSheet(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: h * 0.05,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: w * 0.6,
                                                  height: h * 0.06,
                                                  child:
                                                  RoundedLoadingButton(
                                                    controller:
                                                    _btnController,
                                                    successColor: mainColor,
                                                    color: mainColor,
                                                    borderRadius: 10,
                                                    height: h * 0.06,
                                                    width: w * 0.55,
                                                    disabledColor:
                                                    Colors.white,
                                                    errorColor:
                                                    Colors.white,
                                                    valueColor:
                                                    Colors.white,
                                                    onPressed: () async {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      if (_formKey
                                                          .currentState!
                                                          .validate()) {
                                                        AuthcubitCubit.get(context)
                                                            .login(
                                                            controller:
                                                            _btnController,
                                                            email:
                                                            editingController1
                                                                .text,
                                                            password:
                                                            editingController2
                                                                .text,
                                                            context: context);
                                                      } else {
                                                        _btnController
                                                            .error();
                                                        _btnController
                                                            .stop();
                                                      }
                                                    },
                                                    child: Center(
                                                        child: Text(
                                                          translateString(
                                                              'Login',
                                                              'دخـــول'),
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize:
                                                              w * 0.055,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.03,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    LocalKeys.NOT_HAVE_ACCOUNT
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          (lang == 'en')
                                                              ? 'Nunito'
                                                              : 'Almarai',
                                                      color: Colors.black,
                                                      fontSize: w * 0.035,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.01,
                                                  ),
                                                  InkWell(
                                                    child: Text(
                                                      translateString('Register Now', 'سجل الآن'),
                                                      style: TextStyle(
                                                        color: mainColor,
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        fontSize: w * 0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SignupScreen()));
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: h * 0.03,
                                              ),
                                              Center(
                                                child: InkWell(
                                                  child: Text(
                                                    translateString('Skip Login', 'تخطي التسجيل'),
                                                    style: TextStyle(
                                                      fontFamily:
                                                      (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      color: Colors.black,
                                                      fontSize: w * 0.035,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                HomeScreen(
                                                                  index: 0,
                                                                )),
                                                            (route) =>
                                                        false);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ))));
            },
            listener: (context, state) {}));
  }

  void _forgetPassModalBottomSheet(context){
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        builder: (BuildContext bc){
          return SizedBox(
            height: 0.47*h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.04*w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 0.02*h),
                  Center(child: Container(width: 0.15*w,height: 0.005*h,color: Colors.grey[300],)),
                  SizedBox(height: 0.02*h),
                  Center(
                    child: SizedBox(
                        width: 0.3*w,
                        child: Text('ادخل رقم الهاتف ليصلك كود التفعيل',style: TextStyle(
                            fontFamily: (lang == 'en')
                                ? 'Nunito'
                                : 'Almarai',
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w700,
                            fontSize: w * 0.035),textAlign: TextAlign.center)),
                  ),
                  SizedBox(height: 0.05*h),
                  Text('رقم الهاتف',style: TextStyle(
                      fontFamily: (lang == 'en')
                          ? 'Nunito'
                          : 'Almarai',
                      color: Colors.black,
                      fontWeight:
                      FontWeight.w700,
                      fontSize: w * 0.035),),
                  SizedBox(height: 0.02*h),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      suffixIcon: SizedBox(
                        width: 0.22*w,
                        child: Row(
                          children: [
                            Text('+965',style:TextStyle(
                        fontFamily: (lang == 'en')
                            ? 'Nunito'
                            : 'Almarai',
                          color: Colors.black,
                          fontWeight:
                          FontWeight.w700,
                          fontSize: w * 0.035),),
                            SizedBox(width: 0.01*w),
                            SvgPicture.asset(
                                'assets/icons/flag.svg'),
                            const Icon(
                              Icons.arrow_drop_down,
                            )
                          ],
                        ),
                      ),
                      hintText: 'ادخل رقم الهاتف',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: w*0.03,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: mainColor
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:  mainColor,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: mainColor
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(18),
                    ),
                    //textDirection: appLanguage.isEn ? TextDirection.ltr : TextDirection.rtl,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: w*0.03,
                    ),
                  ),
                  SizedBox(height: 0.04*h),
                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>const SendCodeScreen(forget: true))),
                    child: Container(
                      height: 0.06*h,
                      width: w*0.95,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                            'ارسال',
                            style: TextStyle(
                                fontFamily: (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                color: Colors.white,
                                fontWeight:
                                FontWeight.w700,
                                fontSize: w * 0.035),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
