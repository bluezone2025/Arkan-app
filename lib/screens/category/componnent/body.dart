// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../product_detail/product_detail.dart';
import '../../tabone_screen/cubit/home_cubit.dart';
import '../model/product_cat_model.dart';

class CategoryProducts extends StatefulWidget {
  final String subCatId;

  const CategoryProducts({Key? key, required this.subCatId}) : super(key: key);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
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
      var response = await http.get(Uri.parse(EndPoints.BASE_URL +
          "get-products-in-child/${widget.subCatId}?page=$page"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        CategoryProductModel categoryProductModel =
            CategoryProductModel.fromJson(data);
        setState(() {
          products = categoryProductModel.data!.products!;
        });
      }
    } catch (error) {
      print("product error ----------------------" + error.toString());
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
        var response = await http.get(Uri.parse(EndPoints.BASE_URL +
            "get-products-in-child/${widget.subCatId}?page=$page"));
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          CategoryProductModel categoryProductModel =
              CategoryProductModel.fromJson(data);
          setState(() {
            fetchedPosts = categoryProductModel.data!.products!;
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
        print("product error ----------------------" + error.toString());
      }
      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    firstLoad();
    getLang();
    scrollController = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    String sale = (lang == 'en') ? 'OFF' : 'خصم';
    return Column(
      children: [
        SizedBox(
          height: h * 0.03,
        ),
        isFirstLoadRunning
            ? Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              )
            : (products.isNotEmpty)
                ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w*0.02),
                      child: GridView.builder(
                          controller: scrollController,
                          itemCount: products.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 0.38*h,
                            mainAxisSpacing: w * 0.02,
                            crossAxisSpacing: 5,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  HomeCubit.get(context).getProductdata(
                                      productId: products[index].id.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const ProductDetail()));
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
                                          if(products[index].availability == 0)
                                            Positioned(
                                              top: 0.1*h,
                                              child: Container(
                                                width: w * 0.42,
                                                height: h * 0.05,
                                                color: Colors.black38,
                                                child: Center(
                                                  child: Text(
                                                    translateString('sold out', 'نفذت الكمية'),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: w * 0.04,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Almarai',color: Colors.white
                                                    ),
                                                    overflow: TextOverflow.fade,
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
                                                    maxHeight: h * 0.09, maxWidth: w * 0.38,),
                                                child: (lang == 'en')
                                                    ? Text(products[index].titleEn,maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: w * 0.035,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Nunito',
                                                    ),)
                                                    : Text(
                                                  products[index].titleAr,maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: w * 0.035,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Almarai',
                                                  ),
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
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: h * 0.3),
                    child: Center(
                      child: Text(
                        LocalKeys.NO_PRODUCT.tr(),
                        style: TextStyle(
                            color: mainColor,
                            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
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
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Alamrai'),
              ),
            ),
          ),
      ],
    );
  }
}
