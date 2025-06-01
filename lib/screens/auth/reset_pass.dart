// ignore_for_file: use_key_in_widget_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import 'cubit/authcubit_cubit.dart';

class ResetPass extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
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

    return Form(
      key: _formKey,
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                LocalKeys.RESETPASS.tr(),
                style: TextStyle(
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    fontSize: w * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              leading: BackButton(
                color: mainColor,
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Padding(
              padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h * 0.04,
                    ),
                    Text(
                      LocalKeys.NEW_PASS.tr(),
                      style: TextStyle(
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontSize: w * 0.035,
                          color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: h * 0.05,
                    ),
                    TextFormField(
                        controller: _controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form(),
                            errorBorder: form(),
                            focusedErrorBorder: form(),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: LocalKeys.PASSWORD.tr(),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: w * 0.03)),
                        keyboardType: TextInputType.text),
                    SizedBox(
                      height: h * 0.06,
                    ),
                    BlocConsumer<AuthcubitCubit, AuthcubitState>(
                      listener: (context, state) {},
                      builder: (context, state) => RoundedLoadingButton(
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
                                  fontFamily:
                                      (lang == 'en') ? 'Nunito' : 'Almarai',
                                  color: Colors.white,
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        controller: _btnController,
                        successColor: mainColor,
                        color: mainColor,
                        disabledColor: mainColor,
                        onPressed: () async {
                          AuthcubitCubit.get(context).forgetPass(
                              password: _controller.text,
                              context: context,
                              controller: _btnController);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  InputBorder form() {
    double w = MediaQuery.of(context).size.width;
    return OutlineInputBorder(
      borderSide: const BorderSide(color: (Colors.white), width: 1),
      borderRadius: BorderRadius.circular(w * 0.06),
    );
  }
}
