// ignore_for_file: use_key_in_widget_constructors

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../componnent/constants.dart';
import '../componnent/http_services.dart';
import '../generated/local_keys.dart';
import '../screens/cart/cart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DBhelper/appState.dart';
import '../DBhelper/cubit.dart';
import 'allproducts/all_offers/all_offers.dart';
import 'category/category.dart';

class SubCategoriesScreen extends StatefulWidget {
  final List catItem;

  const SubCategoriesScreen({Key? key, required this.catItem})
      : super(key: key);
  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
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
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: h*0.05,
        title: Text(
          LocalKeys.CAT.tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: w * 0.05,fontWeight: FontWeight.bold,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          BlocConsumer<DataBaseCubit, DatabaseStates>(
            builder: (context, state) => badges.Badge(
              badgeStyle: badges.BadgeStyle(
                badgeColor: mainColor,
              ),
              badgeAnimation: const badges.BadgeAnimation.slide(
                animationDuration: Duration(
                  seconds: 1,
                ),
              ),
              badgeContent: (DataBaseCubit.get(context).cart.isNotEmpty)
                  ? Text(
                      DataBaseCubit.get(context).cart.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.03,
                      ),
                    )
                  : Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.03,
                      ),
                    ),
              position: badges.BadgePosition.topStart(start: w * 0.007),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,size: 30,
                ),
                padding: EdgeInsets.zero,
                focusColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Cart()));
                },
              ),
            ),
            listener: (context, state) {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w*0.02),
                child: GridView.builder(
                    itemCount: widget.catItem.length,
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: h*0.35,
                      mainAxisSpacing: w * 0.03,
                      crossAxisSpacing: w*0.02,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoriesSection(
                                  mainCat: (lang == 'en') ? widget.catItem[index].nameEn : widget.catItem[index].nameAr,
                                      mainCatId:
                                          widget.catItem[index].id.toString(),
                                      subCategory:
                                          widget.catItem[index].categoriesSub,
                                    ))),
                        child: SizedBox(
                            width: w,
                            child: Column(
                              children: [
                                SizedBox(
                                    width: w*0.49,
                                    height: h * 0.25,
                                    child: customCachedNetworkImage(
                                        url: EndPoints.IMAGEURL2 +
                                            widget
                                                .catItem[index].imageUrl,
                                        context: context,
                                        fit: BoxFit.cover)),
                                SizedBox(
                                  width: w*0.4,
                                  height: h * 0.06,
                                  child: Center(
                                    child: (lang == 'en')
                                        ? Text(
                                            widget.catItem[index].nameEn,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Nunito',
                                                fontSize: w * 0.045,
                                                fontWeight:
                                                    FontWeight.w600),
                                          )
                                        : Text(
                                            widget.catItem[index].nameAr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Almarai',
                                                fontSize: w * 0.045,
                                                fontWeight:
                                                    FontWeight.w600),
                                          ),
                                  ),
                                ),
                              ],
                            )),
                      );
                    }),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: h * 0.02,
                    left: h * 0.02,
                    right: h * 0.02,
                    bottom: h * 0.02,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllOffersScreen())),
                    child: SizedBox(
                        width: w,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: w * 2.5 / 100,
                            ),
                            // Icon(Icons.menu,color: Colors.black,size: w*0.06,),
                            SizedBox(
                                width: w,
                                height: h * 0.2,
                                child: customCachedNetworkImage(
                                    url:
                                        "https://img.freepik.com/free-vector/offer-deals-banner-red-background_1017-27332.jpg?t=st=1650986981~exp=1650987581~hmac=929c4dbc40ddddbe5aa3f45a1b90256a52590418dc1e9ad5379ddf5f56cbd408&w=740",
                                    context: context,
                                    fit: BoxFit.cover)),
                            Container(
                              width: w*0.5,
                              height: h * 0.06,
                              color: Colors.grey[300]!.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  LocalKeys.HOME_OFFER.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: (lang == 'en')
                                          ? 'Nunito'
                                          : 'Almarai',
                                      fontSize: w * 0.05,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
