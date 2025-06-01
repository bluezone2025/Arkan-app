// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../generated/local_keys.dart';
import '../../bottomnav/homeScreen.dart';

class UserLanguageSelection extends StatefulWidget {
  @override
  State<UserLanguageSelection> createState() => _UserLanguageSelectionState();
}

class _UserLanguageSelectionState extends State<UserLanguageSelection> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return PreferredSize(
      preferredSize: Size(w, h),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/icons/lang.png"),fit: BoxFit.fill)
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: const BackButton(color: Colors.black,),
            title: Text('يرجي اختيار اللغة',style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.black,
                fontSize: w * 0.04,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold),),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'اختيار اللغة',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: w * 0.045,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: h * 0.04,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        height: h*0.07,
                        width: w*0.35,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'العربية',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.04,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () async {
                        SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                        preferences.setString("language", 'ar');
                        setState(() {
                          context.locale = const Locale('ar', '');
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(index: 3)),
                                (route) => false);
                      },
                    ),
                    SizedBox(
                      width: w * 0.03,
                    ),
                    InkWell(
                      child: Container(
                        height: h*0.07,
                        width: w*0.35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'English',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.04,
                                fontFamily: 'Nnito',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          context.locale = const Locale('en', '');
                        });
                        SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                        preferences.setString("language", 'en');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(index: 3)),
                                (route) => false);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
