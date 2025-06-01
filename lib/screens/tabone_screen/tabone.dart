// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:arkan/screens/allproducts/reception_products.dart';
import 'package:arkan/screens/searchScreen/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DBhelper/appState.dart';
import '../../DBhelper/cubit.dart';
import '../../app_cubit/app_cubit.dart';
import '../../app_cubit/appstate.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../all_categories.dart';
import '../allproducts/all_offers/all_offers.dart';
import '../allproducts/new_product/new_product.dart';
import '../cart/cart.dart';
import '../notifications/noti.dart';
import 'componnent/appbar.dart';
import 'componnent/category.dart';
import 'componnent/newproducts.dart';
import 'model//home_model.dart' as home;
import 'componnent/offers.dart';
import 'componnent/section_title.dart';
import 'cubit/home_cubit.dart';
import 'package:badges/badges.dart' as badges;

class TaboneScreen extends StatefulWidget {
  @override
  _TaboneScreenState createState() => _TaboneScreenState();
}

class _TaboneScreenState extends State<TaboneScreen> {
  String lang = '';
  bool islogin = false;

  List<home.Daza> daza = [
    home.Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
    home.Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
    home.Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
    home.Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
  ];

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      islogin = preferences.getBool('login') ?? false;
    });
  }

  final Geolocator geolocator = Geolocator();
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  late Position currentPosition;
  late String currentAddress;
  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {}

    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) async {
      setState(() {
        currentPosition = position;
      });
      SharedPreferences pres = await SharedPreferences.getInstance();
      pres.setString('late', position.altitude.toString());
      pres.setString('lang', position.longitude.toString());
      print("lattitude ................. : " + position.altitude.toString());
      print("longtitude ................. : " + position.longitude.toString());
    }).catchError((e) {
      print("location errrrrrrrrrrrrrrrrrrrrrrrr : " + e.toString());
    });
  }

  @override
  void initState() {
    getLang();
    getCurrentLocation();
    DataBaseCubit.get(context).cart.length;
    BlocProvider.of<AppCubit>(context).notifyCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        // appBar: AppBarHome.app_bar_home(
        //   context,
        //   lang: lang,
        //   login: islogin
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 0.26*h,
                  width: w,
                  child: Stack(
                    children: [
                      Container(
                        height: 0.24*h,
                        width: w,
                        decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/icons/art2.png'),fit: BoxFit.fill,)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: w*0.04),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocConsumer<AppCubit, AppCubitStates>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return SizedBox(
                                    width: w*0.15,
                                    child: badges.Badge(
                                      badgeStyle: const badges.BadgeStyle(
                                        badgeColor: Colors.white,
                                      ),
                                      badgeAnimation: const badges.BadgeAnimation.slide(
                                        animationDuration: Duration(
                                          seconds: 1,
                                        ),
                                      ),
                                      badgeContent: Text(
                                        islogin ? BlocProvider.of<AppCubit>(context).count == null
                                            ? "0"
                                            : BlocProvider.of<AppCubit>(context).count.toString() : "0",
                                        style:  TextStyle(
                                          color: mainColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      position: badges.BadgePosition.topStart(start: 3),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                        padding: EdgeInsets.zero,
                                        focusColor: Colors.white,
                                        onPressed: () {
                                          if(islogin){
                                            BlocProvider.of<AppCubit>(context).notifyShow();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Notifications()));
                                          }else{
                                            Fluttertoast.showToast(
                                                msg: LocalKeys.MUST_LOGIN.tr(),
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                gravity: ToastGravity.TOP,
                                                toastLength: Toast.LENGTH_LONG);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: h*0.04),
                                child: Image.asset('assets/icons/logo_w.png',height: 0.11*h,),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: w * 0.01),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: BlocConsumer<DataBaseCubit, DatabaseStates>(
                                    builder: (context, state) => badges.Badge(
                                      badgeStyle: const badges.BadgeStyle(
                                        badgeColor: Colors.white,
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
                                          color: mainColor,
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
                                        icon: SvgPicture.asset('assets/icons/bag.svg'),
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
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 0.05*w,
                        child: Center(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchScreen()));
                            },
                            child: Container(
                              height:0.06*h,
                              width: 0.9*w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: mainColor)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 0.45*w,
                                      //height: 7.h,
                                      child: Text(translateString('search', 'عمَ تبحث؟'),
                                        style: TextStyle(color: Colors.black45,fontSize: w*0.03,fontWeight: FontWeight.w100,fontFamily: 'Bahij',),
                                      ),
                                    ),
                                     Icon(Icons.search,color: mainColor,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<HomeCubit, AppCubitStates>(
                    builder: (context, state) {
                      return ConditionalBuilder(
                          condition: state is! HomeitemsLoaedingState,
                          builder: (context) =>
                              Column(
                                children: [
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  SectionTitle(
                                      title: LocalKeys.HOME_CAT.tr(),
                                      press: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SubCategoriesScreen(
                                                catItem: HomeCubit.get(context)
                                                    .homeitemsModel!
                                                    .data!
                                                    .categories!,
                                              )))),
                                  SizedBox(
                                    height: h * 0.015,
                                  ),
                                  CategorySection(
                                    catItem: HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .categories!,
                                  ),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  CarouselSlider.builder(
                                      carouselController: _controller,
                                      itemCount: HomeCubit.get(context)
                                          .homeitemsModel!
                                          .data!
                                          .sliders!
                                          .length,
                                      itemBuilder: (context, index, realIndex) {
                                        return InkWell(
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          // overlayColor: ,
                                          onTap: () async {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: CachedNetworkImage(imageUrl: HomeCubit.get(context)
                                                  .homeitemsModel!
                                                  .data!
                                                  .sliders![index].imgFullPath!,width: w*0.8,height: h*0.4,fit: BoxFit.fill,),
                                            ),
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                          autoPlay: true,
                                          autoPlayAnimationDuration: const Duration(seconds: 1),
                                          autoPlayCurve: Curves.easeIn,
                                          //   enlargeCenterPage: true,
                                          aspectRatio: 2.0,
                                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                                          initialPage: 0,

                                          //  pageSnapping: false,

                                          viewportFraction: .8,
                                          height: 0.3*h,
                                          autoPlayInterval: const Duration(seconds: 5)
                                      )),
                                  DotsIndicator(
                                    dotsCount: HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .sliders!
                                        .length,
                                    position: _current.toDouble(),
                                    mainAxisSize: MainAxisSize.min,
                                    decorator: DotsDecorator(
                                      color: Colors.grey, // Inactive color
                                      activeColor: mainColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  SectionTitle(
                                      title: translateString('New Products', 'أحدث المنتجات'),
                                      press: () =>  Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => NewProductScreen()))),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  NewProducts(
                                    newItem: HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .newArrive!,
                                  ),
                                  // SizedBox(
                                  //   height: h * 0.02,
                                  // ),
                                  // BestSellers(
                                  //   bestItem: HomeCubit.get(context)
                                  //       .homeitemsModel!
                                  //       .data!
                                  //       .bestSell!,
                                  // ),
                                  SizedBox(
                                    height: h * 0.05,
                                  ),
                                  SizedBox(
                                    width: w*0.95,
                                    height: h * 0.25,
                                    child: Swiper(
                                      itemBuilder: (BuildContext context, int i) {
                                        return InkWell(
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          // overlayColor: ,
                                          onTap: () async {},
                                          child: CachedNetworkImage(imageUrl: HomeCubit.get(context)
                                              .homeitemsModel!
                                              .data!
                                              .sliders![i].imgFullPath!,fit: BoxFit.fill,),
                                        );
                                      },
                                      itemCount: HomeCubit.get(context)
                                          .homeitemsModel!
                                          .data!
                                          .sliders!
                                          .length,
                                      autoplay: true,
                                      autoplayDelay: 5000,
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.05,
                                  ),
                                  SectionTitle(
                                    title: translateString('Best Offers', 'أفضل العروض'),
                                    press: () =>  Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => AllOffersScreen())),),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  Offers(
                                    offersItem: HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .offers!,
                                  ),
                                  SizedBox(
                                    height: h * 0.05,
                                  ),
                                  SectionTitle(
                                    title: translateString('Dowry and reception', 'دزة و استقبال'),
                                    press: () =>  Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => const ReceptionProducts())),),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  Offers(
                                    offersItem: HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .reception_products!
                                  ),
                                ],
                              ),
                          // ),
                          //   ],
                          // ),
                          fallback: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              ));
                    },
                    listener: (context, state) {}),
              ],
            ),
          ),
        ));
  }
}
