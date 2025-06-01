// ignore_for_file: use_key_in_widget_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../allproducts/all_offers/all_offers.dart';
import '../../category/category.dart';

class CategorySection extends StatefulWidget {
  final List catItem;

  const CategorySection({Key? key, required this.catItem}) : super(key: key);
  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
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
    return SizedBox(
      width: w,
      height: h * 0.13,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: h*0.03,),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.catItem.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  child: SizedBox(
                    width: w*0.23,
                    height: h * 0.13,
                    child: Stack(
                      children: [
                        SizedBox(height: h*0.01,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: w*0.27,
                            height: h * 0.15,
                            child: customCachedNetworkImage(
                                url: EndPoints.IMAGEURL2 +
                                    widget.catItem[index].imageUrl,
                                context: context,
                                fit: BoxFit.cover),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(color: Colors.black.withOpacity(0.5),),
                        ),
                        SizedBox(height: h*0.02,),
                        Align(
                          alignment:  (lang == 'en') ? Alignment.bottomCenter : Alignment.bottomCenter,
                          child: (lang == 'en')
                              ? Text(
                                widget.catItem[index].nameEn,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                    color: Colors.white,
                                    fontSize: w * 0.04),
                                overflow: TextOverflow.clip,
                              )
                              : Text(
                                widget.catItem[index].nameAr,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Almarai',
                                    color: Colors.white,
                                    fontSize: w * 0.04),
                                overflow: TextOverflow.clip,
                              ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesSection(
                              mainCat: (lang == 'en') ? widget.catItem[index].nameEn : widget.catItem[index].nameAr,
                                  mainCatId:
                                      widget.catItem[index].id.toString(),
                                  subCategory:
                                      widget.catItem[index].categoriesSub,
                                )));
                  },
                );
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
