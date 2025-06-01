// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors
import 'package:arkan/screens/allproducts/reception_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../DBhelper/appState.dart';
import '../../../DBhelper/cubit.dart';
import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../cart/cart.dart';
import '../product_detail/product_detail.dart';
import '../tabone_screen/cubit/home_cubit.dart';
import 'model/newproduct_model.dart';

class ReceptionProducts extends StatefulWidget {
  const ReceptionProducts({super.key});

  @override
  State<ReceptionProducts> createState() => _ReceptionProductsState();
}

class _ReceptionProductsState extends State<ReceptionProducts> {
  late ScrollController scrollController;
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List products = [];
  String lang = '';
  String currency = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
    });
  }

  void firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
    });
    try {
      var response = await http
          .get(Uri.parse("${EndPoints.BASE_URL}reception?page=$page"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        ReceptionProductsModel newproductModel = ReceptionProductsModel.fromJson(data);
        setState(() {
          products = newproductModel.data.receptions.data;
        });
      }
    } catch (error) {
      print("product error ----------------------$error");
    }
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 15) {
      setState(() {
        isLoadMoreRunning = true;
        page++;
      });
      List fetchedPosts = [];
      try {
        var response = await http
            .get(Uri.parse(EndPoints.BASE_URL + "reception_products?page=$page"));
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          NewproductModel newproductModel = NewproductModel.fromJson(data);
          setState(() {
            fetchedPosts = newproductModel.data!.newArrivals!.dataItems!;
          });
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            products.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (error) {
        print("product error ----------------------$error");
      }
      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    getLang();
    firstLoad();
    scrollController = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    String sale = (lang == 'en') ? 'OFF' : 'خصم';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: h*0.05,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          translateString('Reception Products', 'دزة و استقبال'),
          style: TextStyle(
              color: Colors.black, fontSize: w * 0.05, fontFamily: 'Nunito',fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: BlocConsumer<DataBaseCubit, DatabaseStates>(
              builder: ((context, state) => badges.Badge(
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
              )),
              listener: (context, state) {},
            ),
          ),
          SizedBox(
            width: w * 0.05,
          ),
        ],
      ),
      body: isFirstLoadRunning
          ? Center(
        child: CircularProgressIndicator(
          color: mainColor,
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric( horizontal: w * 0.03),
        child: Column(
          children: [
            (products.isNotEmpty)
                ? Expanded(
              child: GridView.builder(
                  controller: scrollController,
                  itemCount: products.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: h* 0.38,
                    mainAxisSpacing: w * 0.02,
                    crossAxisSpacing: 2,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      HomeCubit.get(context).getProductdata(
                          productId:
                          products[index].id.toString());
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
                                  height: h * 0.25,
                                  color: Colors.white,
                                  child: customCachedNetworkImage(
                                      url: EndPoints.IMAGEURL2 +
                                          products[index].img.toString(),
                                      context: context,
                                      fit: BoxFit.fill),
                                ),
                              ),
                              (products[index].hasOffer == 1)
                                  ? Positioned(
                                //top: h*0.0,
                                right: lang == 'en' ? w*0.02 :w*0.35,
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
                                          " %${(((products[index]
                                              .beforePrice - products[index].price) / products[index]
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
                                      height: h * 0.13,
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
                                right: lang == 'en' ? w*0.02 :w*0.35,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
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
                            width: w * 0.45,
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
                                        ? Text(products[index].titleEn,maxLines: 1,
                                        style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Nunito',
                                        ),
                                        overflow: TextOverflow.fade)
                                        : Text(
                                      products[index].titleAr,maxLines: 1,
                                      style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.bold,
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
                                      if(products[index].hasOffer == 1)
                                        Text(
                                          getProductprice(
                                              currency: currency,
                                              productPrice: products[index]
                                                  .beforePrice),
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              decoration:
                                              TextDecoration.lineThrough,
                                              color: Colors.black87,
                                              decorationColor: mainColor),
                                        ),
                                      Text(
                                        getProductprice(
                                            currency: currency,
                                            productPrice:
                                            products[index].price),
                                        style: TextStyle(
                                            fontSize: w * 0.04,
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color: mainColor,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(products[index].quantityAttribute == 0)
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

            if (isLoadMoreRunning == true)
              Padding(
                padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                child: Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                ),
              ),

            // When nothing else to load
            if (hasNextPage == false)
              Container(
                padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                color: Colors.white,
                child: Center(
                  child: Text(
                    LocalKeys.NO_MORE_PRODUCT.tr(),
                    style: TextStyle(
                        fontFamily:
                        (lang == 'en') ? 'Nunito' : 'Alamrai'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
