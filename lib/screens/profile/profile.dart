// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../about_us/about_us.dart';
import '../auth/cubit/authcubit_cubit.dart';
import '../auth/login.dart';
import '../bottomnav/homeScreen.dart';
import '../contact us/contact_us.dart';
import '../country/country.dart';
import '../favourite_screen/favourite_screen.dart';
import 'componnent/profileimage.dart';
import 'componnent/profileitem.dart';
import 'componnent/user_lang.dart';
import 'cubit/userprofile_cubit.dart';
import 'delete_account.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? selected;
  String lang = '';
  bool isLogin = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      isLogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    deleteUserAccount(appversion: version);
    super.initState();
  }

  List<String> icons = [
    "assets/icons/privacy.svg",
    "assets/icons/us.svg",
    "assets/icons/terms.svg",
    "assets/icons/pay.svg",
    "assets/icons/contact.svg",
    "assets/icons/Group 934.png",
    "assets/icon rayan/Group 925.png",
  ];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: const Color(0xffF6F6F6),
          appBar: AppBar(backgroundColor: const Color(0xffF6F6F6),
            toolbarHeight: h*0.1,
            elevation: 0,
            centerTitle: true,title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  translateString('Welcome', 'مرحبا بكم'),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily:
                      (lang == 'en') ? 'Nunito' : 'Almarai',
                      fontSize: 18,
                      color: mainColor,
                      fontWeight: FontWeight.w100),
                ),
                SizedBox(height: h*0.01,),
                Text(
                (isLogin)
                    ? UserprofileCubit.get(context)
                    .userModel!
                    .name!
                    : translateString('In Arkan App', 'في تطبيق أركان'),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily:
                    (lang == 'en') ? 'Nunito' : 'Almarai',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                          ),
                SizedBox(height: h*0.02,)
              ],
            )
          ),
          body: BlocConsumer<UserprofileCubit, UserprofileState>(
              builder: (context, state) {
                return ConditionalBuilder(
                    condition: state is! GetAllInfoLoadinState,
                    builder: (context) => SizedBox(
                      height: h,
                      width: w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfileImage(
                              isLogin: isLogin,
                              userEmail: (isLogin)
                                  ? UserprofileCubit.get(context)
                                      .userModel!
                                      .email
                                      .toString()
                                  : '',
                              userName: (isLogin)
                                  ? UserprofileCubit.get(context)
                                      .userModel!
                                      .name!
                                  : '',
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ProfileItem(
                                        press: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserLanguageSelection())),
                                        title: LocalKeys.LANG.tr(),
                                        image:
                                            "assets/icons/lang.svg"),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Divider(
                                        color: Colors.grey[350],
                                        height: 3,
                                      ),
                                    ),
                                    ProfileItem(
                                        press: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Country(2))),
                                        title: LocalKeys.COUNTRY.tr(),
                                        image: "assets/icons/country.svg"),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Divider(
                                        color: Colors.grey[350],
                                        height: 3,
                                      ),
                                    ),
                                    ProfileItem(
                                        press: () => (isLogin)
                                            ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FavouriteScreen()))
                                            : Fluttertoast.showToast(
                                            msg: LocalKeys.MUST_LOGIN.tr(),
                                            textColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP),
                                        title: LocalKeys.MY_FAV.tr(),
                                        image: "assets/icons/fav.svg"),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Divider(
                                        color: Colors.grey[350],
                                        height: 3,
                                      ),
                                    ),
                                    ProfileItem(
                                        press: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const ContactUsScreen())),
                                        title: LocalKeys.CONTACT_US.tr(),
                                        image: "assets/icons/contact.svg"),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Divider(
                                        color: Colors.grey[350],
                                        height: 3,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        UserprofileCubit.get(context)
                                            .allinfoModel!
                                            .data!
                                            .length,
                                        (index) => Column(
                                          children: [
                                            ProfileItem(
                                                press: () {
                                                  UserprofileCubit.get(
                                                          context)
                                                      .getSingleInfo(
                                                          infoItemId:
                                                              UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .allinfoModel!
                                                                  .data![
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AboutUs((lang ==
                                                                  'en')
                                                              ? UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .allinfoModel!
                                                                  .data![
                                                                      index]
                                                                  .pageTitleEn!
                                                              : UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .allinfoModel!
                                                                  .data![
                                                                      index]
                                                                  .pageTitleAr!)));
                                                },
                                                title: (lang == 'en')
                                                    ? UserprofileCubit.get(
                                                            context)
                                                        .allinfoModel!
                                                        .data![index]
                                                        .pageTitleEn!
                                                    : UserprofileCubit.get(
                                                            context)
                                                        .allinfoModel!
                                                        .data![index]
                                                        .pageTitleAr!,
                                                image: icons[index]),
                                            Padding(
                                              padding:
                                              const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Divider(
                                                color: Colors.grey[350],
                                                height: 3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if(isLogin)
                                    SizedBox(height: h*0.02,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        (isLogin)
                                            ? BlocConsumer<AuthcubitCubit,
                                            AuthcubitState>(
                                            builder: (context, state) {
                                              return InkWell(
                                                onTap: () async {
                                                  AuthcubitCubit.get(
                                                      context)
                                                      .logout(
                                                      context:
                                                      context);
                                                },
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset('assets/icons/logout.svg'),
                                                    Text(
                                                      translateString('Logout', 'خـــــروج'),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w * 0.03,
                                                          fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                              );
                                            },
                                            listener: (context, state) {})
                                            : Container(),
                                        (isLogin && isDeleted)
                                            ? BlocConsumer<AuthcubitCubit,
                                            AuthcubitState>(
                                            builder: (context, state) {
                                              return InkWell(
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                              DeleteAccountScreen()));
                                                },
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset('assets/icons/delete.svg'),
                                                    Text(
                                                      translateString(
                                                          "Delete Account",
                                                          "حذف الحساب"),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w * 0.03,
                                                          fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                              );
                                            },
                                            listener: (context, state) {})
                                            : Container(),
                                      ],
                                    ),
                                    if(isLogin)
                                    SizedBox(height: h*0.02,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ));
              },
              listener: (context, state) {})),
    );
  }
}
