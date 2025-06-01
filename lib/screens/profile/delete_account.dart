// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../../splash.dart';
import '../auth/cubit/authcubit_cubit.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _oldPass = FocusNode();
  String? _oldPassword;
  bool _visibility1 = true;

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
              backgroundColor: Colors.white,
              title: Text(
                translateString("Delete Account", "تاكيد حذف الحساب"),
                style: TextStyle(
                    fontSize: w * 0.05,
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              leading: BackButton(
                color: mainColor,
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
                            hintText: LocalKeys.PASSWORD.tr(),
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
                              _oldPassword = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),
                        BlocConsumer<AuthcubitCubit, AuthcubitState>(
                          builder: (context, state) => RoundedLoadingButton(
                            controller: _btnController,
                            successColor: mainColor,
                            color: mainColor,
                            disabledColor: mainColor,
                            onPressed: () async {
                              print(_oldPassword.toString());
                              if (_formKey.currentState!.validate()) {
                                AuthcubitCubit.get(context).deleteUserAccount(
                                    controller: _btnController,
                                    password: _oldPassword.toString());
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
                                borderRadius: BorderRadius.circular(25),
                                color: mainColor,
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
                          listener: (context, state) {
                            if (state is DeleteAccountSuccessState) {
                              prefs.clear();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SplashScreen()),
                                  (route) => false);
                            }
                          },
                        ),
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
