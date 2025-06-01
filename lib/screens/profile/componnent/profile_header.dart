import 'package:arkan/componnent/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHeaderComponnent extends StatefulWidget {
  final VoidCallback press;
  final String title;
  final String? image;
  final Color color;
  const ProfileHeaderComponnent(
      {Key? key, required this.press, required this.title, this.image, required this.color})
      : super(key: key);

  @override
  _ProfileHeaderComponnentState createState() =>
      _ProfileHeaderComponnentState();
}

class _ProfileHeaderComponnentState extends State<ProfileHeaderComponnent> {
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
        height: h*0.07,
        width: w*0.45,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: widget.color == Colors.white ? mainColor : Colors.transparent)
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.image != null ?
              SizedBox(
                height: 59,
                child: Image(
                  image: AssetImage(widget.image!),
                  color: widget.color == Colors.white ? Colors.black :Colors.white,
                  fit: BoxFit.contain,
                  height: 20,
                  width: 20,
                ),
              ) : Container(),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    fontSize: 14,
                    color: widget.color == Colors.white ? Colors.black :Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
