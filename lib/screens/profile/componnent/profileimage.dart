import 'package:arkan/componnent/constants.dart';
import 'package:arkan/screens/auth/sign_upScreen.dart';
import 'package:arkan/screens/orders/orders.dart';
import 'package:arkan/screens/profile/componnent/profile_header.dart';
import 'package:arkan/screens/profile/componnent/profile_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_cubit/app_cubit.dart';
import '../../../app_cubit/appstate.dart';
import '../../../generated/local_keys.dart';
import '../../auth/login.dart';
import '../../bottomnav/homeScreen.dart';

class ProfileImage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final bool isLogin;
  const ProfileImage(
      {Key? key,
      required this.userName,
      required this.isLogin,
      required this.userEmail})
      : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
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
    return Center(
      child: BlocConsumer<AppCubit, AppCubitStates>(
        builder: (context, state) => Column(
          children: [
            Center(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileHeaderComponnent(
                          press: () => (widget.isLogin)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Orders()),
                                )
                              :  Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const Login()),
                                  (route) => false),
                          title: (widget.isLogin) ? LocalKeys.MY_ORDERS.tr() : LocalKeys.LOG_IN.tr(),
                          image: (widget.isLogin) ? "assets/icon rayan/Group 928.png" : null, color: mainColor,),
                      ProfileHeaderComponnent(
                          press: () => (widget.isLogin)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileSettingScreen(
                                      userEmail:
                                          (widget.userEmail != 'null')
                                              ? widget.userEmail
                                              : '',
                                      userName: widget.userName,
                                    ),
                                  ),
                                )
                              : Navigator
                              .pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder:
                                      (context) =>
                                      SignupScreen()),
                                  (route) =>
                              false),
                          title: (widget.isLogin) ? LocalKeys.UPDATE_PROFILE.tr() : translateString('Create Account', 'أنشاء حساب'),
                          color: Colors.white,),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
            // Center(
            //   child: (AppCubit.get(context).image == null)
            //       ? const CircleAvatar(
            //           backgroundColor: Colors.black,
            //           radius: 55,
            //           child: CircleAvatar(
            //               backgroundColor: Colors.white,
            //               radius: 47,
            //               child: Center(
            //                 child: Icon(
            //                   Icons.insert_photo_outlined,
            //                   size: 50,
            //                   color: Colors.black87,
            //                 ),
            //               )),
            //         )
            //       : CircleAvatar(
            //           backgroundColor: const Color(0xffFB68AA),
            //           radius: 55,
            //           backgroundImage: FileImage(
            //             AppCubit.get(context).image!,
            //           ),
            //           child: const CircleAvatar(
            //               backgroundColor: Colors.white,
            //               radius: 47,
            //               child: Center(
            //                 child: Icon(
            //                   Icons.insert_photo_outlined,
            //                   size: 48,
            //                   color: Colors.black87,
            //                 ),
            //               )),
            //         ),
            // ),

            // Padding(
            //   padding: EdgeInsets.only(
            //       top: h * 0.1,
            //       left: w * 0.35,
            //       right: w * 0.12),
            //   child: Align(
            //     alignment:
            //         AlignmentDirectional
            //             .bottomCenter,
            //     child: InkWell(
            //       onTap: () async {
            //         AppCubit.get(context)
            //             .getImage();
            //       },
            //       child: CircleAvatar(
            //         radius: w * 0.04,
            //         backgroundColor:
            //             Colors.white,
            //         child: Image.asset(
            //             "assets/icons/Path-20.png"),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        listener: (context, state) {},
      ),
    );
  }
}
