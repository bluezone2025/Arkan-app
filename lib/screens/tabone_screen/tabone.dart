// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:arkan/screens/allproducts/reception_products.dart';
import 'package:arkan/screens/bottomnav/brand_products_screen.dart';
import 'package:arkan/screens/bottomnav/brands_screen.dart';
import 'package:arkan/screens/loading.dart';
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
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../all_categories.dart';
import '../allproducts/all_offers/all_offers.dart';
import '../allproducts/new_product/new_product.dart';
import '../cart/cart.dart';
import '../category/category.dart';
import '../notifications/noti.dart';
import '../product_detail/product_detail.dart';
import '../profile/cubit/userprofile_cubit.dart';
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
        appBar: AppBar(
          backgroundColor: const Color(0xffFCF7F7),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(translateString('HELLO', 'اهلا'),style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff400000)),),
              SizedBox(
                width: w * 0.02,
              ),
              if(UserprofileCubit.get(context)
                  .userModel != null)
              Text(
                (islogin)
                    ? UserprofileCubit.get(context)
                    .userModel!
                    .name!
                    : '',style: TextStyle(
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
        fontSize: w * 0.03,
        color: const Color(0xff400000)),
              ),
              Text(translateString('  good after noon', '  مساء الخير'),style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontSize: w * 0.03,
                  color: const Color(0xff400000)),),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Cart()));
              },
                child: SvgPicture.asset('assets/icons/cart.svg')),
            SizedBox(
              width: w * 0.05,
            ),
            InkWell(
              onTap: (){
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
                child: SvgPicture.asset('assets/icons/notify.svg')),
            SizedBox(
              width: w * 0.01,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.01,
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
                        child: CachedNetworkImage(imageUrl: HomeCubit.get(context)
                            .homeitemsModel!
                            .data!
                            .sliders![index].imgFullPath!,width: w,height: h*0.4,fit: BoxFit.fill,),
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
                        aspectRatio: 3.0,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        initialPage: 0,

                        //  pageSnapping: false,

                        viewportFraction: 1,
                        height: 0.3*h,
                        autoPlayInterval: const Duration(seconds: 5)
                    )),
                SizedBox(
                  height: h * 0.01,
                ),
                Center(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchScreen()));
                    },
                    child: Container(
                      height:0.055*h,
                      width: 0.95*w,
                      decoration: BoxDecoration(
                          color: const Color(0xffF2E8E8),
                          borderRadius: BorderRadius.circular(10),
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
                              child: Text(translateString('Search for products or brands', 'ابحث عن المنتجات أو الماركات'),
                                style: TextStyle(color: mainColor,fontSize: w*0.028,fontWeight: FontWeight.bold,fontFamily: 'Bahij',),
                              ),
                            ),
                            Icon(Icons.search,color: mainColor,),
                          ],
                        ),
                      ),
                    ),
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
                                    height: h * 0.04,
                                  ),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.normalBrands!.isNotEmpty)
                                  SectionTitle(
                                      title: translateString('Brands', 'الماركات'),
                                      press: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const BrandsScreen()))),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.normalBrands!.isNotEmpty)
                                  BlocConsumer<AppCubit, AppCubitStates>(
                                    listener: (context, state) {
                                      if(state is GetBrandProductsLoading){
                                        LoadingScreen.show(context);
                                      }if(state is GetBrandProductsSuccess){
                                        LoadingScreen.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=> const BrandProductsScreen(discount: false,)));
                                      }if(state is GetBrandProductsError){
                                        LoadingScreen.pop(context);
                                      }
                                    },
                                    builder: (context, state) {
                                      var normalBrands = BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.normalBrands!;
                                      return SizedBox(
                                    width: w,
                                    height: h*0.26,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          SizedBox(width: w*0.05,),
                                          ListView.separated(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: normalBrands.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return  InkWell(
                                                child: SizedBox(
                                                  width: w*0.38,
                                                  height: h * 0.35,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(height: h*0.01,),
                                                      SizedBox(
                                                        width: w*0.4,
                                                        height: h * 0.18,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(15),
                                                          child: customCachedNetworkImage(
                                                          url: EndPoints.IMAGEURL2 +
                                                              normalBrands[index].logo!,
                                                          context: context,
                                                          fit: BoxFit.fill,),
                                                        ),
                                                      ),
                                                      SizedBox(height: h*0.02,),
                                                      (lang == 'en')
                                                          ? Text(
                                                        normalBrands[index].nameEn!,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Nunito',
                                                            color: Colors.black,
                                                            fontSize: w * 0.035),
                                                        overflow: TextOverflow.clip,textAlign: TextAlign.center,
                                                      )
                                                          : Text(
                                                        normalBrands[index].nameAr!,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Almarai',
                                                            color: Colors.black,
                                                            fontSize: w * 0.035),textAlign: TextAlign.center,
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: (){
                                                  BlocProvider.of<AppCubit>(context).getBrandProducts(normalBrands[index].id.toString());
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
  },
),
                                  BlocConsumer<AppCubit, AppCubitStates>(
                                    listener: (context, state) {},
                                    builder: (context, state) {
                                      var ads = BlocProvider.of<AppCubit>(context).getAdsModel1!.ads;
                                      return ads!.isNotEmpty ? SizedBox(
                                    height: 0.35*h,
                                    child: ListView.builder(
                                        itemCount: ads.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: InkWell(
                                              focusColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              // overlayColor: ,
                                              onTap: () async {
                                                if(ads[index].type == 'brand'){
                                                  BlocProvider.of<AppCubit>(context).getBrandProducts(ads[index].brandId.toString());
                                                }else if (ads[index].type == 'category'){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => CategoriesSection(
                                                            mainCat: '',
                                                            mainCatId:
                                                            ads[index].categoryId.toString(),
                                                            subCategory: [],
                                                          )));
                                                }else if (ads[index].type == 'product'){
                                                  HomeCubit.get(context).getProductdata(
                                                      productId: ads[index].productId.toString());
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => const ProductDetail()));
                                                }
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: CachedNetworkImage(imageUrl: EndPoints.IMAGEURL2 +
                                                    ads[index].image!,width: w*0.5,height: h*0.4,fit: BoxFit.fill,),
                                              ),
                                            ),
                                          );
                                        },),
                                  ) : Container();
  },
),
                                  // DotsIndicator(
                                  //   dotsCount: HomeCubit.get(context)
                                  //       .homeitemsModel!
                                  //       .data!
                                  //       .sliders!
                                  //       .length,
                                  //   position: _current.toDouble(),
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   decorator: DotsDecorator(
                                  //     color: Colors.grey, // Inactive color
                                  //     activeColor: mainColor,
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.discountsBrands!.isNotEmpty)
                                  SectionTitle(
                                      title: translateString('Brand Discounts', 'خصومات الماركات'),
                                      press: () =>  Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const BrandsScreen()))),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.discountsBrands!.isNotEmpty)
                                  BlocConsumer<AppCubit, AppCubitStates>(
                                    listener: (context, state) {
                                      if(state is GetDiscountBrandProductsLoading){
                                        LoadingScreen.show(context);
                                      }if(state is GetDiscountBrandProductsSuccess){
                                        LoadingScreen.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=> const BrandProductsScreen(discount: true,)));
                                      }if(state is GetDiscountBrandProductsError){
                                        LoadingScreen.pop(context);
                                      }
                                    },
                                    builder: (context, state) {
                                      var discountBrands = BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.discountsBrands!;
                                      return SizedBox(
                                    width: w,
                                    height: h*0.26,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          SizedBox(width: w*0.05,),
                                          ListView.separated(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: discountBrands.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                child: SizedBox(
                                                  width: w*0.38,
                                                  height: h * 0.35,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(height: h*0.01,),
                                                      SizedBox(
                                                        width: w*0.4,
                                                        height: h * 0.18,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(15),
                                                          child: customCachedNetworkImage(
                                                            url: EndPoints.IMAGEURL2 +
                                                                discountBrands[index].logo!,
                                                            context: context,
                                                            fit: BoxFit.fill,),
                                                        ),
                                                      ),
                                                      SizedBox(height: h*0.02,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          (lang == 'en')
                                                              ? Text(
                                                            '${discountBrands[index].nameEn!} -',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Nunito',
                                                                color: Colors.black,
                                                                fontSize: w * 0.035),
                                                            overflow: TextOverflow.clip,textAlign: TextAlign.center,
                                                          )
                                                              : Text(
                                                            '${discountBrands[index].nameAr!} -',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Almarai',
                                                                color: Colors.black,
                                                                fontSize: w * 0.035),textAlign: TextAlign.center,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                          (lang == 'en')
                                                              ? Text(
                                                            ' ${discountBrands[index].discountPercentage == 0 ? discountBrands[index].startDiscountRange : discountBrands[index].discountPercentage}% ${translateString('off', 'خصم')}',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Nunito',
                                                                color: mainColor,
                                                                fontSize: w * 0.03),
                                                            overflow: TextOverflow.clip,textAlign: TextAlign.center,
                                                          )
                                                              : Text(
                                                            ' ${discountBrands[index].discountPercentage == 0 ? discountBrands[index].startDiscountRange : discountBrands[index].discountPercentage}% ${translateString('off', 'خصم')}',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Almarai',
                                                                color: mainColor,
                                                                fontSize: w * 0.03),textAlign: TextAlign.center,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: (){
                                                  BlocProvider.of<AppCubit>(context).getDiscountBrandProducts(discountBrands[index].id.toString());
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
  },
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
                                  // SizedBox(
                                  //   width: w*0.95,
                                  //   height: h * 0.25,
                                  //   child: Swiper(
                                  //     itemBuilder: (BuildContext context, int i) {
                                  //       return InkWell(
                                  //         focusColor: Colors.transparent,
                                  //         splashColor: Colors.transparent,
                                  //         highlightColor: Colors.transparent,
                                  //         // overlayColor: ,
                                  //         onTap: () async {},
                                  //         child: CachedNetworkImage(imageUrl: HomeCubit.get(context)
                                  //             .homeitemsModel!
                                  //             .data!
                                  //             .sliders![i].imgFullPath!,fit: BoxFit.fill,),
                                  //       );
                                  //     },
                                  //     itemCount: HomeCubit.get(context)
                                  //         .homeitemsModel!
                                  //         .data!
                                  //         .sliders!
                                  //         .length,
                                  //     autoplay: true,
                                  //     autoplayDelay: 5000,
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: h * 0.05,
                                  // ),
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
                                    height: h * 0.02,
                                  ),
                                  BlocConsumer<AppCubit, AppCubitStates>(
                                    listener: (context, state) {},
                                    builder: (context, state) {
                                      var ads = BlocProvider.of<AppCubit>(context).getAdsModel2!.ads;
                                      return ads!.isNotEmpty ? SizedBox(
                                        height: 0.35*h,
                                        child: ListView.builder(
                                          itemCount: ads.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: InkWell(
                                                focusColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                // overlayColor: ,
                                                onTap: () async {
                                                  if(ads[index].type == 'brand'){
                                                    BlocProvider.of<AppCubit>(context).getBrandProducts(ads[index].brandId.toString());
                                                  }else if (ads[index].type == 'category'){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => CategoriesSection(
                                                              mainCat: '',
                                                              mainCatId:
                                                              ads[index].categoryId.toString(),
                                                              subCategory: [],
                                                            )));
                                                  }else if (ads[index].type == 'product'){
                                                    HomeCubit.get(context).getProductdata(
                                                        productId: ads[index].productId.toString());
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => const ProductDetail()));
                                                  }
                                                },
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: CachedNetworkImage(imageUrl: EndPoints.IMAGEURL2 +
                                                      ads[index].image!,width: w*0.5,height: h*0.4,fit: BoxFit.fill,),
                                                ),
                                              ),
                                            );
                                          },),
                                      ) : Container();
                                    },
                                  ),
                                  SizedBox(
                                    height: h * 0.05,
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
