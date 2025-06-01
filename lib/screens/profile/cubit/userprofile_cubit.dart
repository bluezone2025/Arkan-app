// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/http_services.dart';
import '../model/info.dart';
import '../model/single_item.dart';
import '../model/user_model.dart';
part 'userprofile_state.dart';

class UserprofileCubit extends Cubit<UserprofileState> {
  UserprofileCubit() : super(UserprofileInitial());
  static UserprofileCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  Future getUserProfile() async {
    emit(GetProfileLoadingState());
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token') ?? '';
    try {
      var response = await http.get(Uri.parse(EndPoints.USER_PROFILE),
          headers: {'auth-token': token});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == false) {
        print(data['msg']);
      } else if (response.statusCode == 200) {
        userModel = UserModel.fromJson(data);
        pref.setString('user_id', userModel!.id!.toString());
        pref.setString('created_at', data['created_at']);
        emit(GetProfileSuccessState());
        return userModel;
      }
    } catch (error) {
      emit(GetProfileErrorState(error.toString()));
      print("get profile data error ==========================" +
          error.toString());
    }
  }

  void updateUserdata(
      {required String name,
      required String email,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    emit(EditProfileLoadingState());
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token').toString();

    try {
      Map<String, dynamic> body = {'name': name, 'email': email};
      var response = await http.post(Uri.parse(EndPoints.EDIT_PROFILE),
          headers: {'auth-token': token}, body: body);

      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pop(context);
        getUserProfile();
        emit(EditProfileSuccessState());
      }
    } catch (error) {
      emit(EditProfileErrorState(error.toString()));
      print("update profile error------------------------ " + error.toString());
    }
  }

  void changePassword(
      {required String oldPassword,
      required String newPassword,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    emit(ChangePasswordProfileLoadingState());
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token').toString();
    final String lang = pref.get('language').toString();

    try {
      Map<String, dynamic> body = {
        'old_password': oldPassword,
        'new_password': newPassword
      };
      var response = await http.post(Uri.parse(EndPoints.CHANGE_PASSWORD),
          headers: {'auth-token': token, 'Content-Language': lang}, body: body);

      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pop(context);
        getUserProfile();
        emit(ChangePasswordProfileSuccessState());
      } else {
        String errordata = data['message'];
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(errordata),
          action: SnackBarAction(
            label: 'undo',
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      emit(ChangePasswordProfileErrorState(error.toString()));
      print("update profile error------------------------ " + error.toString());
    }
  }

  ///////////////////////////////////////////////////////////////////////////////
  AllinfoModel? allinfoModel;

  Future<AllinfoModel?> getAllinfo() async {
    emit(GetAllInfoLoadinState());
    try {
      var response = await http.get(Uri.parse(EndPoints.INFO));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        allinfoModel = AllinfoModel.fromJson(data);
        emit(GetAllInfoSuccessState());
        return allinfoModel;
      }
    } catch (error) {
      emit(GetAllInfoErrorState(error.toString()));
      print("information error : " + error.toString());
    }
  }

  SingleItemModel? singleItemModel;
  getSingleInfo({required String infoItemId}) async {
    emit(GetSingleInfoLoadinState());

    try {
      var response = await http
          .get(Uri.parse(EndPoints.INFO_SINGLE + "?type=$infoItemId"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        singleItemModel = SingleItemModel.fromJson(data);
        emit(GetSingleInfoSuccessState());
        return singleItemModel;
      }
    } catch (error) {
      emit(GetSingleInfoErrorState(error.toString()));
      print("error for single info : " + error.toString());
    }
  }

  void contactUs(
      {required String name,
      required String email,
      required String phone,
      required String title,
      required String message,
      required RoundedLoadingButtonController controller,
      required context}) async {
    emit(ContactUsLoadinState());
    try {
      var response = await http.post(Uri.parse("${EndPoints.CONTACT_US}?name=$name&email=$email&phone=$phone&title=$title&body=$message"));
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 1) {
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pop(context);
        emit(ContactUsSuccessState());
      } else {
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
      }
    } catch (error) {
      emit(ContactUsErrorState(error.toString()));
      print("error while sending message ----------------------------------$error");
    }
  }
}
