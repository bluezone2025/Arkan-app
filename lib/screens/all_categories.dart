// ignore_for_file: use_key_in_widget_constructors

import 'package:arkan/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:arkan/screens/tabone_screen/model/home_model.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
  String code = '';
  List products = [];
  List<Sliders> sliders =[];
  bool finish = false;
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      code = preferences.getString('country_code').toString();
    });
    for(int i=0; i< widget.catItem.length;i++){
      for(int x=0; x< widget.catItem[i].countries!.length;x++){
        if(widget.catItem[i].countries![x].code == code){
          setState(() {
            products.add(widget.catItem[i]);
          });
        }
      }
    }
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
                icon: SvgPicture.asset('assets/icons/cart.svg',height: h*0.03,),
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
      backgroundColor: const Color(0xffFBFBFB),
      body: SizedBox(
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(imageUrl: sliders[index].imgFullPath!,width: w,height: h*0.4,fit: BoxFit.fill,)),
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
                        height: 0.3*h,
                        autoPlayInterval: const Duration(seconds: 5)
                    )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w*0.02),
                child: GridView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: h*0.25,
                      mainAxisSpacing: w * 0.03,
                      crossAxisSpacing: w*0.02,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (ctx, index) {
                      return products[index].countries!.any((v) => v.code == code) ?InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoriesSection(
                                  mainCat: (lang == 'en') ? products[index].nameEn : products[index].nameAr,
                                      mainCatId:
                                      products[index].id.toString(),
                                      subCategory:
                                      products[index].categoriesSub,
                                    ))),
                        child: SizedBox(
                            width: w,
                            child: Stack(
                              children: [
                                SizedBox(
                                    width: w*0.49,
                                    height: h * 0.25,
                                    child: customCachedNetworkImage(
                                        url: EndPoints.IMAGEURL2 +
                                            products[index].imageUrl,
                                        context: context,
                                        fit: BoxFit.cover)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: (lang == 'en')
                                          ? Text(
                                        products[index].nameEn,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Nunito',
                                            fontSize: w * 0.035,
                                            fontWeight:
                                            FontWeight.w600),textAlign: TextAlign.center,
                                      )
                                          : Text(
                                        products[index].nameAr,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Almarai',
                                            fontSize: w * 0.035,
                                            fontWeight:
                                            FontWeight.w600),textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ) : Container();
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
