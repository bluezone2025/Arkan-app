import 'package:arkan/app_cubit/app_cubit.dart';
import 'package:arkan/app_cubit/appstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../product_detail/product_detail.dart';
import '../tabone_screen/cubit/home_cubit.dart';

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
  listener: (context, state) {},
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
      ),
      body: Column(
        children: [
          Image.network(EndPoints.IMAGEURL2 +
              model.brandProducts!.brand!.logo!,height: 0.25*h,fit: BoxFit.fill,width: w*0.95,),
          SizedBox(
            height: h * 0.03,
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(translateString('All Products', 'كل المنتجات'),style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),),
                  Container(
                    color: mainColor,
                    height: h*0.003,
                    width: w*0.25,
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: h * 0.03,
          ),
          Expanded(
            child: GridView.builder(
                itemCount: model.brandProducts!.products!.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: h* 0.3,
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
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: w * 0.42,
                            height: h * 0.2,
                            color: Colors.white,
                            child: customCachedNetworkImage(
                                url: EndPoints.IMAGEURL2 +
                                    model.brandProducts!.products![index].img.toString(),
                                context: context,
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          width: w * 0.42,
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
                                      ? Text(model.brandProducts!.products![index].titleEn!,maxLines: 1,
                                      style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                      ),
                                      overflow: TextOverflow.fade)
                                      : Text(
                                    model.brandProducts!.products![index].titleAr!,maxLines: 1,
                                    style: TextStyle(
                                      fontSize: w * 0.035,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Almarai',
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                if(model.brandProducts!.products![index].hasOffer == 1)
                                  Text(
                                    getProductprice(
                                        currency: currency,
                                        productPrice: model.brandProducts!.products![index]
                                            .beforePrice!),
                                    style: TextStyle(
                                        fontSize: w * 0.025,
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        decoration:
                                        TextDecoration.lineThrough,
                                        color: Colors.black,
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
                                          model.brandProducts!.products![index].price!),
                                      style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          color: mainColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    if(model.brandProducts!.products![index].hasOffer == 1)
                                      Text(
                                        " %${(((model.brandProducts!.products![index]
                                            .beforePrice! - model.brandProducts!.products![index].price!) / model.brandProducts!.products![index]
                                            .beforePrice! ) * 100).toInt()} ${translateString('off', 'خصم')}",
                                        textAlign:
                                        TextAlign.center,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontFamily:
                                            'Bahij',
                                            fontSize: w * 0.025,
                                            fontWeight:
                                            FontWeight
                                                .w500),
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
          )
        ],
      ),
    );
  },
);
  }
}
