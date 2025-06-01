// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../profile/cubit/userprofile_cubit.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _oldPass = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();
  String? oldPass, newPass, confirmPass;
  bool _visibility1 = true;
  bool _visibility2 = true;
  bool _visibility3 = true;

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                LocalKeys.CHANGE_PASS_TITLE.tr(),
                style: TextStyle(
                    fontSize: w * 0.05,
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              leading: const BackButton(
                color: Colors.white,
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
                child: SizedBox(
                  width: w * 0.9,
                  height: h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: h * 0.03,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: _visibility1,
                          textInputAction: TextInputAction.next,
                          focusNode: _oldPass,
                          onEditingComplete: () {
                            _oldPass.unfocus();
                            FocusScope.of(context).requestFocus(_passFocus);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter old password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form(),
                            errorBorder: form(),
                            fillColor: Colors.grey[200],
                            filled: true,
                            focusedErrorBorder: form(),
                            hintText: LocalKeys.OLD_PASS.tr(),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: w * 0.03),
                            suffixIcon: IconButton(
                              icon: !_visibility1
                                  ? Icon(
                                      Icons.visibility,
                                      color: mainColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: mainColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _visibility1 = !_visibility1;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            setState(() {
                              oldPass = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: _visibility2,
                          textInputAction: TextInputAction.next,
                          focusNode: _passFocus,
                          onEditingComplete: () {
                            _passFocus.unfocus();
                            FocusScope.of(context).requestFocus(_confirmFocus);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter new password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form(),
                            errorBorder: form(),
                            fillColor: Colors.grey[200],
                            filled: true,
                            focusedErrorBorder: form(),
                            hintText: LocalKeys.NEW_PASS.tr(),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: w * 0.03),
                            suffixIcon: IconButton(
                              icon: !_visibility2
                                  ? Icon(
                                      Icons.visibility,
                                      color: mainColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: mainColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _visibility2 = !_visibility2;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            setState(() {
                              newPass = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: _visibility3,
                          textInputAction: TextInputAction.done,
                          focusNode: _confirmFocus,
                          onEditingComplete: () {
                            _confirmFocus.unfocus();
                          },
                          validator: (value) {
                            if (value != newPass) {
                              return "passord not match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form(),
                            errorBorder: form(),
                            focusedErrorBorder: form(),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: LocalKeys.CONFIRM_PASS.tr(),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: w * 0.03),
                            suffixIcon: IconButton(
                              icon: !_visibility3
                                  ? Icon(
                                      Icons.visibility,
                                      color: mainColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: mainColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _visibility3 = !_visibility3;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            if (val == newPass) {
                              setState(() {
                                confirmPass = val;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: h * 0.1,
                        ),
                        BlocConsumer<UserprofileCubit, UserprofileState>(
                            builder: (context, state) => RoundedLoadingButton(
                                  controller: _btnController,
                                  successColor: mainColor,
                                  color: mainColor,
                                  disabledColor: mainColor,
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (_formKey.currentState!.validate()) {
                                      UserprofileCubit.get(context)
                                          .changePassword(
                                              oldPassword: oldPass.toString(),
                                              newPassword: newPass.toString(),
                                              context: context,
                                              controller: _btnController);
                                    } else {
                                      _btnController.error();
                                      await Future.delayed(
                                          const Duration(milliseconds: 1000));
                                      _btnController.stop();
                                    }
                                  },
                                  child: Container(
                                    height: h * 0.08,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black,
                                    ),
                                    child: Center(
                                      child: Text(
                                        LocalKeys.SEND.tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.045,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                            listener: (context, state) {}),
                        SizedBox(
                          height: h * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(25));
  }
}
