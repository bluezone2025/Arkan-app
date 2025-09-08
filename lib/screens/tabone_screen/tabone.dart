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
import 'package:shimmer/shimmer.dart';
import '../../app_cubit/appstate.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../../splash.dart';
import '../all_categories.dart';
import '../allproducts/all_offers/all_offers.dart';
import '../allproducts/new_product/new_product.dart';
import '../auth/login.dart';
import '../cart/cart.dart';
import '../category/category.dart';
import '../country/cubit/country_cubit.dart';
import '../notifications/noti.dart';
import '../product_detail/product_detail.dart';
import '../profile/cubit/userprofile_cubit.dart';
import 'componnent/appbar.dart';
import 'componnent/category.dart';
import 'componnent/newproducts.dart';
import 'componnent/offers.dart' as offer;
import 'componnent/section_title.dart';
import 'cubit/home_cubit.dart';
import 'package:badges/badges.dart' as badges;

import 'model/home_model.dart';

class TaboneScreen extends StatefulWidget {
  @override
  _TaboneScreenState createState() => _TaboneScreenState();
}

class _TaboneScreenState extends State<TaboneScreen> {
  String lang = '';
  bool islogin = false;
  bool finish = false;
  String code = '';
  String country = '';
  int deleteSlider = 0;
  List<Sliders> sliders =[];

  List<Daza> daza = [
    Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
    Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
    Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
    Daza(appearance: 0,availability: 2,basicCategoryId: 3,beforePrice: 15,bestSelling: 0,categoryId: 45,deliveryPeriod: 2,descriptionAr: 'دزات استقبال ستاندات', descriptionEn: 'دزات استقبال ستاندات',featured: 0,hasOffer: 0,id: 11,img: '',newarrive: 0,price: 50,sizeGuideId: 0,titleAr: 'دزات استقبال ستاندات',titleEn: 'دزات استقبال ستاندات',daza: 1),
  ];

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.black26,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      islogin = preferences.getBool('login') ?? false;
      code = preferences.getString('country_code').toString();
      country = translateString(preferences.getString('country_en').toString(), preferences.getString('country_ar').toString());
    });
    if(HomeCubit.get(context).homeitemsModel != null){
      for(int i=0; i< HomeCubit.get(context).homeitemsModel!.data!.sliders!.length;i++){
        print(i);
        for(int x=0; x< HomeCubit.get(context).homeitemsModel!.data!.sliders![i].countries!.length;x++){
          print(x);
          print(code);
          if(HomeCubit.get(context).homeitemsModel!.data!.sliders![i].countries![x].code == code){
            setState(() {
              sliders.add(HomeCubit.get(context).homeitemsModel!.data!.sliders![i]);
            });
          }
        }
      }
      setState(() {
        finish = true;
      });
    }
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
    if(!finish){
      getLang();
    }
    if(HomeCubit.get(context).homeitemsModel == null){
      return _buildShimmer();
    }
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        // appBar: AppBarHome.app_bar_home(
        //   context,
        //   lang: lang,
        //   login: islogin
        // ),
        appBar: AppBar(
          backgroundColor: const Color(0xffFCF7F7),
          title: InkWell(
            onTap: (){
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Enable full-screen resizing for the keyboard
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                ),
                builder: (BuildContext bc) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 0.04 * w,
                        right: 0.04 * w,
                        top: 0.02 * h,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Center(
                            child: Container(
                              width: w*0.15,
                              height: 0.005*h,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Column(
                            children: List.generate(
                                CountryCubit.get(context)
                                    .countryModel!
                                    .data!
                                    .length, (index) {
                              return Column(
                                children: [
                                  SizedBox(
                                      width: w * 0.9,
                                      height: h * 0.07,
                                      child: BlocConsumer<AppCubit,
                                          AppCubitStates>(
                                          builder: (context, state) {
                                            return InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: (AppCubit.get(context).addressselected == index) ? mainColor : Colors.transparent,width: 1)
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: w * 0.03,
                                                    ),
                                                    Container(
                                                      width: w * 0.07,
                                                      height: w * 0.04,
                                                      decoration:
                                                      BoxDecoration(
                                                          color: Colors
                                                              .grey[
                                                          200],
                                                          shape: BoxShape.rectangle,
                                                          image:
                                                          DecorationImage(
                                                            image: NetworkImage(EndPoints
                                                                .IMAGEURL2 +
                                                                CountryCubit.get(context)
                                                                    .countryModel!
                                                                    .data![index]
                                                                    .imageUrl!),
                                                            fit: BoxFit
                                                                .fill,
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.03,
                                                    ),
                                                    Text(
                                                        translateString(CountryCubit.get(
                                                            context)
                                                            .countryModel!
                                                            .data![
                                                        index]
                                                            .nameEn!, CountryCubit.get(
                                                            context)
                                                            .countryModel!
                                                            .data![
                                                        index]
                                                            .nameAr!),
                                                        style:
                                                        TextStyle(
                                                          fontSize:
                                                          w * 0.035,
                                                          fontFamily:
                                                          'Almarai',
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                AppCubit.get(context)
                                                    .addressselected =
                                                    index;
                                                AppCubit.get(context)
                                                    .addressSelection(
                                                    selected: index);
                                                CountryCubit.get(context)
                                                    .getCity();
                                                SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                                setState(() {
                                                  prefs.setString(
                                                      "country_en",
                                                      CountryCubit.get(
                                                          context)
                                                          .countryModel!
                                                          .data![index]
                                                          .nameEn
                                                          .toString());
                                                  prefs.setString(
                                                      "country_ar",
                                                      CountryCubit.get(
                                                          context)
                                                          .countryModel!
                                                          .data![index]
                                                          .nameAr
                                                          .toString());
                                                  prefs.setString(
                                                      "ratio",
                                                      CountryCubit.get(
                                                          context)
                                                          .countryModel!
                                                          .data![index]
                                                          .currency!
                                                          .rate!);
                                                  prefs.setString(
                                                      'country_id',
                                                      CountryCubit.get(
                                                          context)
                                                          .countryModel!
                                                          .data![index]
                                                          .id!
                                                          .toString());

                                                  prefs.setBool(
                                                      'select_country',
                                                      true);
                                                  prefs.setString(
                                                      'currency',
                                                      translateString( CountryCubit.get(
                                                          context)
                                                          .countryModel!
                                                          .data![index]
                                                          .currency!
                                                          .code!,  CountryCubit.get(
                                                          context)
                                                          .countryModel!
                                                          .data![index]
                                                          .currency!
                                                          .codeAr!));
                                                  prefs.setString(
                                                      'country_code',
                                                      CountryCubit.get(
                                                          context)
                                                          .countryModel!
                                                          .data![index]
                                                          .code!);
                                                });
                                              },
                                            );
                                          },
                                          listener: (context, state) {})),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Divider(
                                    height: h * 0.005,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                ],
                              );
                            }),
                          ),
                          SizedBox(
                            height: h * 0.1,
                          ),
                            InkWell(
                              child: Container(
                                height: h * 0.06,
                                width: w*0.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: mainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    translateString('Save', 'حفظ'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontSize: w * 0.045,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> SplashScreen()));
                              },
                            ),
                          SizedBox(
                            height: h * 0.1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(country,style: TextStyle(
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    fontSize: w * 0.04,
                    color: Colors.black),),
                const Icon(Icons.arrow_drop_down,color: Color(0xffAE0000),size: 25,)
              ],
            ),
          ),
          centerTitle: true,
          leadingWidth: w * 0.25,
          leading: SizedBox(
            width: w * 0.2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: w * 0.02,
                ),
                Text(translateString('HELLO', 'مرحبا'),style: TextStyle(
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    fontSize: w * 0.035,
                    color: const Color(0xffAE0000)),),
                SizedBox(
                  width: w * 0.02,
                ),
                if(UserprofileCubit.get(context).userModel != null)
                  Text(
                    (islogin)
                        ? UserprofileCubit.get(context)
                        .userModel!
                        .name!
                        : '',style: TextStyle(
                      fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                      fontSize: w * 0.035,
                      color: Colors.black),
                  ),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchScreen()));
              },
                child: SvgPicture.asset('assets/icons/search.svg')),
            SizedBox(
              width: w * 0.02,
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
                if(HomeCubit.get(context).homeitemsModel != null)
                CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: sliders.length,
                    itemBuilder: (context, index, realIndex) {
                      return sliders[index].countries!.any((v) => v.code == code) ? InkWell(
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        // overlayColor: ,
                        onTap: () async {},
                        child: CachedNetworkImage(imageUrl: sliders[index].imgFullPath!,width: w,height: h*0.4,fit: BoxFit.fill,),
                       ): Container();
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
                // Center(
                //   child: InkWell(
                //     onTap: (){
                //       Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchScreen()));
                //     },
                //     child: Container(
                //       height:0.055*h,
                //       width: 0.95*w,
                //       decoration: BoxDecoration(
                //           color: const Color(0xffF2E8E8),
                //           borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 18.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             SizedBox(
                //               width: 0.45*w,
                //               //height: 7.h,
                //               child: Text(translateString('Search for products or brands', 'ابحث عن المنتجات أو الماركات'),
                //                 style: TextStyle(color: mainColor,fontSize: w*0.028,fontWeight: FontWeight.bold,fontFamily: 'Bahij',),
                //               ),
                //             ),
                //             Icon(Icons.search,color: mainColor,),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
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
                                  if(HomeCubit.get(context)
                                      .homeitemsModel != null)
                                  CategorySection(
                                    catItem: HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .categories!,
                                  ),
                                  SizedBox(
                                    height: h * 0.04,
                                  ),
                                  if(BlocProvider.of<AppCubit>(context).getAdsModel1 != null)
                                    BlocConsumer<AppCubit, AppCubitStates>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        var ads = BlocProvider.of<AppCubit>(context).getAdsModel1?.ads;
                                        return  CarouselSlider.builder(
                                            carouselController: _controller,
                                            itemCount: ads!.length,
                                            itemBuilder: (context, index, realIndex) {
                                              return ads[index].countries!.any((v) => v.code == code) ? InkWell(
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
                                                      ads[index].image!,width: w,height: h*0.5,fit: BoxFit.fill,),
                                                ),
                                              ): Container();
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
                                                height: 0.35*h,
                                                autoPlayInterval: const Duration(seconds: 5)
                                            ));
                                      },
                                    ),
                                  SizedBox(
                                    height: h * 0.04,
                                  ),
                                  if(HomeCubit.get(context)
                                      .homeitemsModel != null)
                                    NewProducts(
                                      newItem: HomeCubit.get(context)
                                          .homeitemsModel!
                                          .data!
                                          .newArrive!,
                                    ),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel != null)
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.normalBrands!.isNotEmpty)
                                  SectionTitle(
                                      title: translateString('Top brands', 'أبرز الماركات'),
                                      press: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const BrandsScreen()))),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel != null)
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
                                        height: h * 0.5,
                                        child: GridView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: normalBrands.length < 4 ? normalBrands.length : 4,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return normalBrands[index].countries!.any((v) => v.code == code) ? InkWell(
                                              child: Image.network(EndPoints.IMAGEURL2 +
                                                  normalBrands[index].logo!,height: 0.25*h,fit: BoxFit.fill,width: w*0.45,),
                                              onTap: (){
                                                BlocProvider.of<AppCubit>(context).getBrandProducts(normalBrands[index].id.toString());
                                              },
                                            ) : Container();
                                          },gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 0.25*h,
                                          mainAxisSpacing: h*0.01,
                                          crossAxisSpacing: w*0.02,
                                          crossAxisCount: 2,
                                        ),
                                        ),
                                      );},),
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
                                    height: h * 0.02,
                                  ),
                                  if(HomeCubit.get(context)
                                      .homeitemsModel != null)
                                    offer.Offers(
                                      offersItem: HomeCubit.get(context)
                                          .homeitemsModel!
                                          .data!
                                          .offers!,
                                    ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  if(BlocProvider.of<AppCubit>(context).getAdsModel2 != null)
                                    BlocConsumer<AppCubit, AppCubitStates>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        var ads = BlocProvider.of<AppCubit>(context).getAdsModel2?.ads;
                                        return ads!.isNotEmpty ? SizedBox(
                                          height: 0.35*h,
                                          child: ListView.builder(
                                            itemCount: ads.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return ads[index].countries!.any((v) => v.code == code) ? Padding(
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
                                              ) : Container();
                                            },),
                                        ) : Container();
                                      },
                                    ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel != null)
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.discountsBrands!.isNotEmpty)
                                    Text(
                                      translateString('Brand Discounts', 'خصومات الماركات'),
                                      style: TextStyle(
                                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                  if(BlocProvider.of<AppCubit>(context).getBrandsModel != null)
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
                                    height: h*0.23,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          SizedBox(width: w*0.01,),
                                          ListView.separated(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: discountBrands.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return discountBrands[index].countries!.any((v) => v.code == code) ? InkWell(
                                                child: SizedBox(
                                                  width: w*0.46,
                                                  height: h * 0.35,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(height: h*0.01,),
                                                      SizedBox(
                                                        width: w*0.46,
                                                        height: h * 0.15,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: customCachedNetworkImage(
                                                            url: EndPoints.IMAGEURL2 +
                                                                discountBrands[index].logo!,
                                                            context: context,
                                                            fit: BoxFit.fitWidth,),
                                                        ),
                                                      ),
                                                      SizedBox(height: h*0.01,),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          (lang == 'en')
                                                              ? Text(
                                                            discountBrands[index].nameEn!,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontFamily: 'Nunito',
                                                                color: Colors.black,
                                                                fontSize: w * 0.04),
                                                            overflow: TextOverflow.clip,textAlign: TextAlign.center,
                                                          )
                                                              : Text(
                                                            discountBrands[index].nameAr!,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontFamily: 'Almarai',
                                                                color: Colors.black,
                                                                fontSize: w * 0.04),textAlign: TextAlign.center,
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                          (lang == 'en')
                                                              ? Text(
                                                            ' ${discountBrands[index].discountPercentage == 0 ? discountBrands[index].startDiscountRange : discountBrands[index].discountPercentage}% ${translateString('off', 'خصم')}',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontFamily: 'Nunito',
                                                                color: mainColor,
                                                                fontSize: w * 0.035),
                                                            overflow: TextOverflow.clip,textAlign: TextAlign.center,
                                                          )
                                                              : Text(
                                                            ' ${discountBrands[index].discountPercentage == 0 ? discountBrands[index].startDiscountRange : discountBrands[index].discountPercentage}% ${translateString('off', 'خصم')}',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontFamily: 'Almarai',
                                                                color: mainColor,
                                                                fontSize: w * 0.035),textAlign: TextAlign.center,
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
                                              ) : Container();
                                            },
                                            separatorBuilder: (context, index) => SizedBox(
                                              width: w * 0.025,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );},),

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
