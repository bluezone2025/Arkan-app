// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../DBhelper/appState.dart';
import '../../../DBhelper/cubit.dart';
import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../cart/cart.dart';
import '../../cart/cart_product/body.dart';
import '../../product_detail/product_detail.dart';
import '../../searchScreen/search_screen.dart';
import '../../tabone_screen/cubit/home_cubit.dart';
import '../model/newproduct_model.dart';

class NewProductScreen extends StatefulWidget {
  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  late ScrollController scrollController;
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List products = [];
  String lang = '';
  String code = '';
  String currency = '';
  String sort = '';

  List<String> sortName = [
    translateString('Discounts', 'التخفيضات'),
    translateString('New arrival', 'وصل حديثا'),
    translateString('The cheapest', 'الأقل سعرا'),
    translateString('highest price', 'الأعلى سعرا'),
  ];
  List<String> sortKey = [
    'offers',
    'new_arrive',
    'lowest_price',
    'highest_price',
  ];

  int sortIndex = 0;

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
      var response = await http
          .get(Uri.parse("${EndPoints.BASE_URL}new_arrive?page=$page&sort=$sort"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        NewproductModel newproductModel = NewproductModel.fromJson(data);
        print(response.body);
        print(products);
        for(int i=0; i< newproductModel.data!.newArrivals!.dataItems!.length;i++){
          for(int x=0; x< newproductModel.data!.newArrivals!.dataItems![i].countries!.length;x++){
            if(newproductModel.data!.newArrivals!.dataItems![i].countries![x].code == code){
              setState(() {
                products.add(newproductModel.data!.newArrivals!.dataItems![i]);
              });
            }
          }
        }
        print(products);
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
            .get(Uri.parse("${EndPoints.BASE_URL}new_arrive?page=$page&sort=$sort"));
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          NewproductModel newproductModel = NewproductModel.fromJson(data);
          setState(() {
            fetchedPosts = newproductModel.data!.newArrivals!.dataItems!;
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
          translateString('recommended', 'موصي به'),
          style: TextStyle(
              color: Colors.black, fontSize: w * 0.035, fontFamily: 'Nunito',fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchScreen()));
              },
              child: SvgPicture.asset('assets/icons/search.svg')),
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
                      icon: SvgPicture.asset('assets/icons/cart.svg'),
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
                  SizedBox(height: h*0.03,),
                  InkWell(
                    onTap: (){
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // Enab// le full-screen resizing for the keyboard
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.0),
                          ),
                        ),
                        builder: (context) => StatefulBuilder(
                          builder: (BuildContext context, StateSetter set) {
                            return SizedBox(
                              width: w,
                              height: h*0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: h*0.005),
                                    Center(
                                      child: Container(
                                        color: Colors.grey,
                                        height: h*0.004,
                                        width: w*0.1,
                                      ),
                                    ),
                                    SizedBox(height: h*0.04),
                                    Center(
                                      child: Text(translateString('Sort by', 'رتب حسب'),style: TextStyle(
                                          fontFamily: 'Almarai',
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),),
                                    ),
                                    SizedBox(height: h*0.04),
                                    Column(
                                      children: List.generate(4, (index)=> Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  sortIndex = index;
                                                  sort = sortKey[index];
                                                });
                                                set(() {
                                                  sortIndex = index;
                                                  sort = sortKey[index];
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(sortName[index],style: TextStyle(
                                                      fontFamily: 'Almarai',
                                                      fontSize: w * 0.03,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black),),
                                                  Container(
                                                    height: h*0.02,
                                                    width: w*0.05,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: sortIndex == index ? mainColor : Colors.transparent,
                                                        border: Border.all(color: Colors.grey,width: 0.5)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: h*0.01),
                                            Center(
                                              child: Container(
                                                color: Colors.grey[300],
                                                height: h*0.001,
                                                width: w*0.9,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                    ),
                                    SizedBox(
                                      height: h * 0.02,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        products.clear();
                                        firstLoad();
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: w*0.95,
                                        height: h*0.05,
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: Center(
                                            child: Text(
                                              translateString('Show results', 'إظهار النتائج'),
                                              style: TextStyle(
                                                  fontSize: w * 0.035,
                                                  fontFamily: (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: h*0.035,
                      width: w*0.65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey,width: 0.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/filter.svg'),
                          SizedBox(
                            width: w * 0.03,
                          ),
                          Text(translateString('Sort by', 'رتب حسب'),style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.04,
                  ),
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
                              ): Container()),
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
