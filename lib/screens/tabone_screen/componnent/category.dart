// ignore_for_file: use_key_in_widget_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../allproducts/all_offers/all_offers.dart';
import '../../category/category.dart';
import '../model/home_model.dart';

class CategorySection extends StatefulWidget {
  final List<Categories> catItem;

  const CategorySection({Key? key, required this.catItem}) : super(key: key);
  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  String lang = '';
  String code = '';
  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      code = preferences.getString('country_code').toString();
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
    return SizedBox(
      width: w,
      height: h * 0.2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: h*0.02,),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.catItem.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return widget.catItem[index].countries!.any((v) => v.code == code) ? InkWell(
                  child: SizedBox(
                    width: w*0.33,
                    height: h * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: h*0.01,),
                        CircleAvatar(
                          radius: 0.07*h, // Image radius
                          backgroundImage: NetworkImage(EndPoints.IMAGEURL2 +
                              widget.catItem[index].imageUrl!,),
                        ),
                        SizedBox(height: h*0.02,),
                        (lang == 'en')
                            ? Text(
                          widget.catItem[index].nameEn!,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              color: Colors.black,
                              fontSize: w * 0.033),
                          overflow: TextOverflow.clip,textAlign: TextAlign.center,
                        )
                            : Text(
                          widget.catItem[index].nameAr!,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Almarai',
                              color: Colors.black,
                              fontSize: w * 0.033),textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesSection(
                              mainCat: (lang == 'en') ? widget.catItem[index].nameEn! : widget.catItem[index].nameAr!,
                              mainCatId:
                              widget.catItem[index].id.toString(),
                              subCategory:
                              widget.catItem[index].categoriesSub!,
                            )));
                  },
                ) : Container();
              },
              separatorBuilder: (context, index) => SizedBox(
                width: w * 0.025,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
