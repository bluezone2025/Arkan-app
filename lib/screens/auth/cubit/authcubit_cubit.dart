// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../../splash.dart';
import '../../bottomnav/homeScreen.dart';
import '../../profile/cubit/userprofile_cubit.dart';
import '../../tabone_screen/cubit/home_cubit.dart';
import '../login.dart';
import '../model/checkphone_model.dart';
import '../reset_pass.dart';
part 'authcubit_state.dart';

class AuthcubitCubit extends Cubit<AuthcubitState> {
  AuthcubitCubit() : super(AuthcubitInitialState());
  static AuthcubitCubit get(context) => BlocProvider.of(context);

  void login(
      {required RoundedLoadingButtonController controller,
      required String email,
      required String password,
      required BuildContext context}) async {
    emit(LoginLoadingState());
    String datamess = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String deviceToken = prefs.get('davice_token').toString();
    final String lang = prefs.get('language').toString();
    try {
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'device_token': deviceToken
      };
      var response = await http.post(Uri.parse(EndPoints.LOGIN),
          body: body, headers: {'Content-Language': lang});
      var data = jsonDecode(response.body);
      if (email == '') {
        data['email'].forEach((e) {
          datamess += e + '\n';
        });
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(datamess),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (response.statusCode == 200 && data['user'] != null) {
        print(data['access_token']);
        UserprofileCubit().getUserProfile();
        prefs.setString('token', data['access_token']);
        prefs.setBool('login', true);
        controller.success();
        HomeCubit.get(context).getHomeitems();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      index: 0,
                    )),
            (route) => false);
        emit(LoginSuccessState());
      } else if (data['status'] == 0) {
        final snackBar = SnackBar(
          content: Text(data['message']),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      emit(LoginErrorState(err.toString()));
      print("login errrrrrrrrrrrr" + err.toString());
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////

  void register(
      {required RoundedLoadingButtonController controller,
      required String email,
      required String password,
      required String name,
      required String phone,
      required String confirmpassword,
      required BuildContext context}) async {
    emit(RegisterLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lang = prefs.get('language').toString();
    String errorMess = '';
    try {
      Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmpassword,
        'phone': phone
      };
      var response = await http.post(Uri.parse(EndPoints.REGISTER),
          body: body, headers: {'Content-Language': lang});
      var data = jsonDecode(response.body);
      if (data['status'] == 0 && response.statusCode == 200) {
        data['message'].forEach((e) {
          errorMess += e + '\n';
        });
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(errorMess),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response.statusCode == 200 && data['data']['user'] != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      index: 0,
                    )),
            (route) => false);
        prefs.setBool('login', true);
        print(data['data']['token']);
        prefs.setString('token', data['data']['token']);
        UserprofileCubit().getUserProfile();
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        emit(RegisterSuccessState());
      }
    } catch (error) {
      emit(RegisterErrorState(error.toString()));
      print("register error ---------------------------------------" +
          error.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////
  CheckPhoneModel? checkPhoneModel;
  void checkPhone(
      {required BuildContext context,
      required RoundedLoadingButtonController controller,
      required String email}) async {
    try {
      Map<String, dynamic> body = {
        'email': email,
      };
      print(email);
      var response =
          await http.post(Uri.parse(EndPoints.CHECK_PHONE), body: body);
      var data = jsonDecode(response.body);
      if (data['message'] == "Done") {
        checkPhoneModel = CheckPhoneModel.fromJson(data);
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();

        emit(CheckPhoneSuccessState());
      } else if (data['status'] == 0) {
        final snackBar = SnackBar(
          content: Text(translateString("Email not connected with account",
              "البريد الإلكتروني الذي ادخلته غير متصل بحساب")),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
      }
    } catch (error) {
      emit(CheckPhoneErrorState(error.toString()));
      print("phone check errrrrrrrrrrrrrrrrrrrr " + error.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////

  void logout({required BuildContext context}) async {
    emit(LogoutLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    try {
      var response = await http
          .post(Uri.parse(EndPoints.LOG_OUT), headers: {'auth-token': token});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == false) {
        print(data['msg']);
      } else if (response.statusCode == 200 &&
          data['message'] == "user logout") {
        prefs.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (route) => false);
        emit(LogoutSuccessState());
      }
    } catch (error) {
      emit(LogoutErrorState(error.toString()));
      print("log out errrrrrrrrrrrrrrr" + error.toString());
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////

  void forgetPass(
      {required String password,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    emit(ForgetpasswordLoadingState());
    String errorMess = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    final String lang = prefs.get('language').toString();
    try {
      Map<String, dynamic> body = {
        'user_id': checkPhoneModel!.data!.userId.toString(),
        'password': password
      };
      var response = await http.post(Uri.parse(EndPoints.FORGET_PASS),
          body: body, headers: {'auth-token': token, 'Content-Language': lang});
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        data['message'].forEach((e) {
          errorMess += e + '\n';
        });
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(errorMess),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      }
      emit(ForgetpasswordSuccessState());
    } catch (err) {
      emit(ForgetpasswordErrorState(err.toString()));
      print("forget password error --------------------- " + err.toString());
    }
  }

  ////////////////////////////////////////////////////////////////////////
  Future<void> phoeneEmailCheck(
      {required String email,
      required context,
      required RoundedLoadingButtonController controller}) async {
    final String lang = prefs.get('language').toString();
    String errorData = '';
    emit(CheckPhoneEmailLoadingState());
    try {
      Map<String, String> headers = {"Content-Language": lang};
      Map<String, dynamic> body = {"email": email};
      var response = await http.post(Uri.parse(EndPoints.CHECK_PHONE_EMAIL),
          body: body, headers: headers);
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        data['message'].forEach((e) {
          errorData += e + '\n';
        });
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(errorData),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (data['message'] == 'Done') {
        emit(CheckPhoneEmailSuccessState());
      }
    } catch (error) {
      emit(CheckPhoneEmailErrorState(error.toString()));
      print("-----------------------------" + error.toString());
    }
  }

  /////////////////////////////////////////////////////////////////
  void activationCode(
      {required String code,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    emit(VerificationCodeLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    final String lang = prefs.get('language').toString();
    try {
      Map<String, dynamic> body = {
        'user_id': checkPhoneModel!.data!.userId.toString(),
        'code': code
      };
      var response = await http.post(Uri.parse(EndPoints.ACTIVATION_CODE),
          body: body, headers: {'auth-token': token, 'Content-Language': lang});
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(translateString(
              "code is invalid", "هذا الكود غير صحيح يرجي التاكد مرة اخري ")),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ResetPass()),
            (route) => false);
      }
      emit(VerificationCodeSuccessState());
    } catch (err) {
      emit(VerificationCodeErrorState(err.toString()));
      print("forget password error --------------------- " + err.toString());
    }
  }

  ////////////////////////////////////////////////////////////////////

  String? messageSuccess;
  Future deleteUserAccount(
      {required String password,
      required RoundedLoadingButtonController controller}) async {
    final String token = prefs.getString('token').toString();
    emit(DeleteAccountLoadingState());
    try {
      Map<String, dynamic> body = {"password": password};
      var response = await http.post(
        Uri.parse(EndPoints.CUSTOME_DELETE_ACCOUNT),
        body: body,
        headers: {
          "auth-token": token,
        },
      );
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        controller.success();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
        print(data);
        emit(DeleteAccountSuccessState());
        return messageSuccess;
      } else {
        controller.error();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
      }
    } catch (e) {
      print(e.toString());
      controller.error();
      await Future.delayed(const Duration(milliseconds: 1000));
      controller.stop();
      emit(DeleteAccountErrorState(e.toString()));
    }
    return messageSuccess;
  }
}

/////////////////////////////////////////////////////////////

bool isDeleted = false;
Future<bool> deleteUserAccount({String? appversion}) async {
  try {
    var response = await http.post(
      Uri.parse(EndPoints.DELETE_ACCOUNT),
      body: {"app_version": appversion},
      headers: {
        "auth-token": prefs.getString('auth') ?? "",
      },
    );
    var data = jsonDecode(response.body);
    if (data['status'] == 1) {
      isDeleted = data['message'];
      print(data);
      return isDeleted;
    }
  } catch (e) {
    print(e.toString());
  }
  return isDeleted;
}
