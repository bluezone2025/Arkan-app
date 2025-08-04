import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../profile/cubit/userprofile_cubit.dart';

class UpdateProfile extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;
  const UpdateProfile(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.userPhone})
      : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  List<FocusNode> listFocus = List<FocusNode>.generate(3, (_) => FocusNode());
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
    listEd = List<TextEditingController>.generate(
      3,
      (_) => TextEditingController(
        text: _ == 0
            ? widget.userName
            : (_ == 2)
                ? widget.userPhone
                : (widget.userEmail != 'null')
                    ? widget.userEmail
                    : LocalKeys.EMAIL.tr(),
      ),
    );
    super.initState();
  }

  List<TextEditingController> listEd = [];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(
            LocalKeys.UPDATE_PROFILE.tr(),
            style: TextStyle(
                fontSize: w * 0.05,
                color: Colors.white,
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
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
              child: Column(
                children: [
                  Column(
                    children: List.generate(listFocus.length, (index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: h * 0.03,
                          ),
                          TextFormField(
                            cursorColor: Colors.black,
                            readOnly: (index == 2) ? true : false,
                            inputFormatters: index != 1
                                ? null
                                : [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9 a-z  @ .]")),
                                  ],
                            controller: listEd[index],
                            focusNode: listFocus[index],
                            textInputAction: index == 0
                                ? TextInputAction.next
                                : TextInputAction.done,
                            keyboardType: index == 1
                                ? TextInputType.emailAddress
                                : TextInputType.text,
                            onEditingComplete: () {
                              listFocus[index].unfocus();
                              if (index < 1) {
                                FocusScope.of(context)
                                    .requestFocus(listFocus[index + 1]);
                              }
                            },
                            decoration: InputDecoration(
                              focusedBorder: form(),
                              enabledBorder: form(),
                              errorBorder: form(),
                              focusedErrorBorder: form(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  BlocConsumer<UserprofileCubit, UserprofileState>(
                      builder: (context, state) {
                        return RoundedLoadingButton(
                          controller: _btnController,
                          successColor: mainColor,
                          color: Colors.black,
                          borderRadius: 5,
                          disabledColor: mainColor,
                          onPressed: () {
                            UserprofileCubit.get(context).updateUserdata(
                                name: listEd[0].text,
                                email: listEd[1].text,
                                context: context,
                                controller: _btnController);
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
                                    fontFamily:
                                        (lang == 'en') ? 'Nunito' : 'Almarai',
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                      listener: (context, state) {}),
                  SizedBox(
                    height: h * 0.08,
                  ),
                  SizedBox(
                    height: h * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(25));
  }
}
