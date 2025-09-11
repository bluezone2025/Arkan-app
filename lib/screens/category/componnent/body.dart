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
  String code = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      code = preferences.getString('country_code').toString();
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
        for(int i=0; i< categoryProductModel.data!.products!.length;i++){
          for(int x=0; x< categoryProductModel.data!.products![i].countries!.length;x++){
            if(categoryProductModel.data!.products![i].countries![x].code == code){
              setState(() {
                products.add(categoryProductModel.data!.products![i]);
              });
            }
          }
        }
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
          for(int i=0; i< fetchedPosts.length;i++){
            for(int x=0; x< fetchedPosts[i].countries!.length;x++){
              if(fetchedPosts[i].countries![x].code == code){
                setState(() {
                  products.add(fetchedPosts[i]);
                });
              }
            }
          }
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
                          itemBuilder: (context, index) => products[index].countries!.any((v) => v.code == code) ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: w*0.005),
                            child: InkWell(
                              onTap: () {
                                HomeCubit.get(context).getProductdata(
                                    productId: products[index].id.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail()));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          width: w * 0.5,
                                          height: h * 0.24,
                                          color: Colors.white,
                                          child: customCachedNetworkImage(
                                              url: EndPoints.IMAGEURL2 +
                                                  products[index].img.toString(),
                                              context: context,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      if(products[index].availability == 0)
                                        Positioned(
                                          top: 0.08*h,
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
                                              constraints: BoxConstraints(maxWidth: w * 0.4),
                                              child: Text(translateString(products[index].titleEn, products[index].titleAr),maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: w * 0.032,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Nunito',
                                                ),)
                                          ),
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          Container(
                                              constraints: BoxConstraints(maxWidth: w * 0.4),
                                              child: Text(translateString(products[index].descriptionEn, products[index].descriptionAr),maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: w * 0.03,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Nunito',
                                                ),)
                                          ),
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          if(products[index].hasOffer == 1)
                                            Text(
                                              getProductprice(
                                                  currency: currency,
                                                  productPrice: products[index]
                                                      .beforePrice),
                                              style: TextStyle(
                                                  fontSize: w * 0.025,
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  decoration:
                                                  TextDecoration.lineThrough,
                                                  color: Colors.red,
                                                  decorationColor: Colors.black),
                                            ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
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
                                                  color: Colors.black,
                                                ),
                                              ),
                                              if(products[index].hasOffer == 1)
                                                Container(
                                                  color: mainColor,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                                    child: Text(
                                                      " %${(((products[index]
                                                          .beforePrice - products[index].price) / products[index]
                                                          .beforePrice ) * 100).toInt()}",
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                          'Bahij',
                                                          fontSize: w * 0.025,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
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
                          ) : Container()),
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
