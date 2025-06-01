// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'componnent/constants.dart';
import 'generated/local_keys.dart';
import 'screens/country/country.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangPage extends StatefulWidget {
  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return PreferredSize(
      preferredSize: Size(w, h),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
              Image.asset('assets/icons/logo.png',height: h*0.15,),
              SizedBox(
                height: h * 0.04,
              ),
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
                      preferences.setBool('select_lang', true);
                      setState(() {
                        context.locale = const Locale('ar', '');
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Country(1)),
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
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setString("language", 'en');
                      preferences.setBool('select_lang', true);
                      setState(() {
                        context.locale = const Locale('en', '');
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Country(1)),
                          (route) => false);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
