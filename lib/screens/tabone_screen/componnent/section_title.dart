import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../generated/local_keys.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final VoidCallback press;
  const SectionTitle({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  _SectionTitleState createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
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
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only( right: w * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          InkWell(
            onTap: widget.press,
            child: Container(
              height: w*0.08,
              width: w*0.2,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topRight: Radius.circular(15))
              ),
              child: Center(
                child: Text(
                  translateString('view all', 'عرض الكل'),
                  style: TextStyle(
                      fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
