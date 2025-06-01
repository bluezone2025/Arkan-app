import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileItem extends StatefulWidget {
  final VoidCallback press;
  final String title;
  final String image;
  const ProfileItem(
      {Key? key, required this.press, required this.title, required this.image})
      : super(key: key);

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  int? selected;
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
    return InkWell(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: h*0.005, horizontal: 0.04*w),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(widget.image),
                  SizedBox(
                    width: 0.03*w,
                  ),
                  Center(
                      child: Container(
                        padding: EdgeInsets.zero,
                        height: 0.04*h,
                        color: Colors.grey[400],
                        width: 1,
                      )),
                  SizedBox(
                    width: 0.04*w,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 17,
              color: Colors.black87,
            ),
            SizedBox(
              width: 0.01*w,
            )
          ],
        ),
      ),
    );
  }
}
