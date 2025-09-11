import 'package:arkan/app_cubit/app_cubit.dart';
import 'package:arkan/app_cubit/appstate.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DBhelper/appState.dart';
import '../../DBhelper/cubit.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../cart/cart.dart';
import '../cart/cart_product/body.dart';
import '../loading.dart';
import '../product_detail/product_detail.dart';
import '../searchScreen/search_screen.dart';
import '../tabone_screen/cubit/home_cubit.dart';
import 'homeScreen.dart';

class BrandProductsScreen extends StatefulWidget {
  const BrandProductsScreen({super.key, required this.discount});

  final bool discount;

  @override
  State<BrandProductsScreen> createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  String lang = '';
  String currency = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
    });
  }
  
  List<String> sort = [
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

  @override
  void initState() {
    getLang();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return BlocConsumer<AppCubit, AppCubitStates>(
  listener: (context, state) {
    if(state is GetBrandProductsLoading){
      LoadingScreen.show(context);
    }if(state is GetBrandProductsSuccess){
      LoadingScreen.pop(context);
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>
                  HomeScreen(
                    index: 0,
                  )),
              (route) =>
          false);
      Navigator.push(context, MaterialPageRoute(builder: (_)=> const BrandProductsScreen(discount: false,)));
    }if(state is GetBrandProductsError){
      LoadingScreen.pop(context);
    }
  },
  builder: (context, state) {
    var model = widget.discount ? BlocProvider.of<AppCubit>(context).getDiscountBrandProductsModel! : BlocProvider.of<AppCubit>(context).getBrandProductsModel!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(translateString(model.brandProducts!.brand!.nameEn!, model.brandProducts!.brand!.nameAr!),style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: w * 0.04,
            fontWeight: FontWeight.normal,
            color: const Color(0xff400000)),),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.02,
            ),
            if(model.brandProducts!.brand!.cover != null)
            Image.network(EndPoints.IMAGEURL2 + model.brandProducts!.brand!.cover!,height: 0.22*h,fit: BoxFit.fill,width: w,),
            SizedBox(
              height: h * 0.02,
            ),
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
                                      });
                                      set(() {
                                        sortIndex = index;
                                      });

                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(sort[index],style: TextStyle(
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
                              BlocProvider.of<AppCubit>(context).getBrandProductsSort(model.brandProducts!.brand!.id.toString(),sortKey[sortIndex]);
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
                height: h*0.045,
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
              height: h * 0.03,
            ),
            GridView.builder(
                itemCount: model.brandProducts!.products!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: h* 0.38,
                  mainAxisSpacing: w * 0.02,
                  crossAxisSpacing: 2,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) =>  Padding(
                  padding: EdgeInsets.symmetric(horizontal: w*0.005),
                  child: InkWell(
                    onTap: () {
                      HomeCubit.get(context).getProductdata(
                          productId: model.brandProducts!.products![index].id.toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProductDetail()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: w * 0.5,
                            height: h * 0.24,
                            color: Colors.white,
                            child: customCachedNetworkImage(
                                url: EndPoints.IMAGEURL2 +
                                    model.brandProducts!.products![index].img.toString(),
                                context: context,
                                fit: BoxFit.fill),
                          ),
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
                                    child: Text(translateString(model.brandProducts!.products![index].titleEn!, model.brandProducts!.products![index].titleAr!),maxLines: 1,
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
                                    child: Text(translateString(model.brandProducts!.products![index].descriptionEn!, model.brandProducts!.products![index].descriptionAr!),maxLines: 1,
                                      style: TextStyle(
                                        fontSize: w * 0.03,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Nunito',
                                      ),)
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                if(model.brandProducts!.products![index].hasOffer == 1)
                                  Text(
                                    getProductprice(
                                        currency: currency,
                                        productPrice: model.brandProducts!.products![index]
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
                                          model.brandProducts!.products![index].price),
                                      style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        color: Colors.black,
                                      ),
                                    ),
                                    if(model.brandProducts!.products![index].hasOffer == 1)
                                      Container(
                                        color: mainColor,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                          child: Text(
                                            " %${(((model.brandProducts!.products![index]
                                                .beforePrice - model.brandProducts!.products![index].price) / model.brandProducts!.products![index]
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
                ))
          ],
        ),
      ),
    );
  },
);
  }
}
