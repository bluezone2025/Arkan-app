// ignore_for_file: use_key_in_widget_constructors, avoid_print
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DBhelper/appState.dart';
import '../../DBhelper/cubit.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../cart/cart.dart';
import '../product_detail/product_detail.dart';
import '../tabone_screen/cubit/home_cubit.dart';
import 'cubit/favourite_cubit.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  String lang = '';
  String currency = '';
  bool isLogin = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      isLogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    FavouriteCubit.get(context).getWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: BackButton(
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            LocalKeys.FAV.tr(),
            style: TextStyle(
              color: Colors.black,
              fontSize: w * 0.04,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
          //centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: w * 0.01),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: BlocConsumer<DataBaseCubit, DatabaseStates>(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        : const Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                    position: badges.BadgePosition.topStart(start: 6),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                        size: 25,
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
              ),
            ),
            SizedBox(
              width: w * 0.05,
            ),
          ],
        ),
        body: BlocConsumer<FavouriteCubit, FavouriteState>(
            builder: (context, state) {
          return (isLogin)
              ? ConditionalBuilder(
                  condition: state is! GetFavouriteLoadingState,
                  builder: (context) => ListView(
                    primary: true,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        vertical: h * 0.03, horizontal: w * 0.03),
                    children: [
                      SizedBox(
                        height: h * 0.01,
                      ),
                      (FavouriteCubit.get(context)
                              .wishlistModel!
                              .data!
                              .isNotEmpty)
                          ? SizedBox(
                        height: h * 0.9,
                            child: GridView.builder(
                            itemCount: FavouriteCubit.get(context)
                                .wishlistModel!
                                .data!
                                .length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 0.38*h,
                              mainAxisSpacing: w * 0.02,
                              crossAxisSpacing: 5,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                HomeCubit.get(context).getProductdata(
                                    productId:
                                    FavouriteCubit.get(context)
                                        .wishlistModel!
                                        .data![index]
                                        .id
                                        .toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetail()));
                              },
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Container(
                                            width: w * 0.45,
                                            height: h * 0.3,
                                            color: Colors.white,
                                            child: customCachedNetworkImage(
                                                url: EndPoints.IMAGEURL2 +
                                                    FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index].img.toString(),
                                                context: context,
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        (FavouriteCubit.get(context)
                                            .wishlistModel!
                                            .data![index].hasOffer == 1)
                                            ? Positioned(
                                          //top: h*0.0,
                                          right: lang == 'en' ? w*0.02 :w*0.37,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: mainColor,
                                                    shape: BoxShape.circle
                                                ),
                                                height: h*0.06,
                                                child: Center(
                                                  child: Text(
                                                    " %${(((FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index]
                                                        .beforePrice - FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index].price) / FavouriteCubit.get(context)
                                                        .wishlistModel!
                                                        .data![index]
                                                        .beforePrice ) * 100).toInt()} ",
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                        'Bahij',
                                                        fontSize: w * 0.028,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.18,
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle
                                                ),
                                                height: h*0.06,
                                                child:  Center(
                                                  child: Icon(Icons.add,color: mainColor,),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                            : Positioned(
                                          bottom: 1,
                                          right: lang == 'en' ? w*0.02 :w*0.37,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            height: h * 0.06,
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: mainColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: w * 0.4,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxHeight: h * 0.07, maxWidth: w * 0.38),
                                              child: (lang == 'en')
                                                  ? Text(FavouriteCubit.get(context)
                                                  .wishlistModel!
                                                  .data![index].titleEn.toString(),maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: w * 0.03,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'Nunito',
                                                  ),
                                                  overflow: TextOverflow.fade)
                                                  : Text(
                                                FavouriteCubit.get(context)
                                                    .wishlistModel!
                                                    .data![index].titleAr.toString(),maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: w * 0.03,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'Almarai',
                                                ),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                if(FavouriteCubit.get(context)
                                                    .wishlistModel!
                                                    .data![index].hasOffer == 1)
                                                    Text(
                                                  getProductprice(
                                                      currency: currency,
                                                      productPrice: FavouriteCubit.get(context)
                                                          .wishlistModel!
                                                          .data![index]
                                                          .beforePrice),
                                                  style: TextStyle(
                                                      fontSize: w * 0.03,
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      decoration:
                                                      TextDecoration.lineThrough,
                                                      color: Colors.grey,
                                                      decorationColor: mainColor),
                                                ),
                                                Text(
                                                  getProductprice(
                                                      currency: currency,
                                                      productPrice:
                                                      FavouriteCubit.get(context)
                                                          .wishlistModel!
                                                          .data![index].price),
                                                  style: TextStyle(
                                                      fontSize: w * 0.03,
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      color: mainColor,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if(FavouriteCubit.get(context)
                                                .wishlistModel!
                                                .data![index].availability == 0)
                                              Center(
                                                child: Text(
                                                  translateString('sold out', 'نفذت الكمية'),maxLines: 1,textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: w * 0.03,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Almarai',color: mainColor
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            SizedBox(
                                              height: h * 0.01,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          )
                          : Padding(
                              padding: EdgeInsets.only(top: h * 0.3),
                              child: Center(
                                child: Text(
                                  LocalKeys.NO_PRODUCT.tr(),
                                  style: TextStyle(
                                      color: mainColor,
                                      fontFamily:
                                          (lang == 'en') ? 'Nunito' : 'Almarai',
                                      fontSize: w * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                    ],
                  ),
                  fallback: (context) => Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/3099609.jpg",
                        height: h * 0.35,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Center(
                      child: Text(
                        LocalKeys.MUST_LOGIN.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                            fontSize: w * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
        }, listener: (context, state) {
          if (state is GetFavouriteSuccessState) {
            print("-------------------------------------------------------");
          } else if (state is GetFavouriteLoadingState) {
            print("loading---------------------------------");
          }
        }));
  }
}
