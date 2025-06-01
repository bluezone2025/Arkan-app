import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../generated/local_keys.dart';
import '../../change_password/change_password.dart';
import '../../update_profile/update_profile.dart';
import '../cubit/userprofile_cubit.dart';

class ProfileSettingScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  const ProfileSettingScreen(
      {Key? key, required this.userName, required this.userEmail})
      : super(key: key);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          LocalKeys.UPDATE.tr(),
          style: TextStyle(
              fontSize: w * 0.05,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: (() => Navigator.pop(context)),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        child: ListView(
          primary: true,
          shrinkWrap: true,
          padding:
              EdgeInsets.symmetric(vertical: h * 0.04, horizontal: w * 0.05),
          children: [
            Text(
              LocalKeys.INFO.tr(),
              style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontWeight: FontWeight.w600,
                  fontSize: w * 0.05,
                  color: Colors.black),
            ),
            SizedBox(
              height: h * 0.015,
            ),
            Text(
              widget.userName,
              style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontWeight: FontWeight.w400,
                  fontSize: w * 0.05,
                  color: Colors.black),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Text(
              widget.userEmail,
              style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontWeight: FontWeight.w400,
                  fontSize: w * 0.05,
                  color: Colors.black),
            ),
            SizedBox(
              height: h * 0.07,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => UpdateProfile(
                          userPhone: UserprofileCubit.get(context)
                              .userModel!
                              .phone
                              .toString(),
                          userEmail: UserprofileCubit.get(context)
                              .userModel!
                              .email
                              .toString(),
                          userName: UserprofileCubit.get(context)
                              .userModel!
                              .name
                              .toString(),
                        )),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: h * 0.07,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    LocalKeys.UPDATE.tr(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: w * 0.04,
                        fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.05,
            ),
            Text(
              LocalKeys.PASSWORD.tr(),
              style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontWeight: FontWeight.w600,
                  fontSize: w * 0.05,
                  color: Colors.black),
            ),
            SizedBox(
              height: h * 0.05,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePass()));
              },
              child: Container(
                width: double.infinity,
                height: h * 0.07,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    LocalKeys.UPDATE.tr(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: w * 0.04,
                        fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
