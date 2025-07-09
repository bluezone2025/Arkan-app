import 'package:arkan/componnent/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_cubit/app_cubit.dart';
import '../../app_cubit/appstate.dart';
import '../../componnent/http_services.dart';
import '../loading.dart';
import '../searchScreen/search_screen.dart';
import 'brand_products_screen.dart';
import 'models/get_brands_model.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {

  List<Brand>? allBrands= [];

  @override
  void initState() {
    allBrands =  BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.normalBrands!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return BlocConsumer<AppCubit, AppCubitStates>(
  listener: (context, state) {
    if(state is GetBrandProductsSuccess){
      LoadingScreen.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_)=> const BrandProductsScreen(discount: false,)));
    }if(state is GetBrandProductsError){
      LoadingScreen.pop(context);
    }if(state is GetDiscountBrandProductsSuccess){
      LoadingScreen.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_)=> const BrandProductsScreen(discount: true,)));
    }if(state is GetDiscountBrandProductsError){
      LoadingScreen.pop(context);
    }
  },
  builder: (context, state) {
    var discountBrands = BlocProvider.of<AppCubit>(context).getBrandsModel!.brands!.discountsBrands!;
    return Scaffold(
      appBar: AppBar(
        title: Text(translateString('Brands', 'الماركات'),style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: w * 0.045,
            fontWeight: FontWeight.bold,
            color: const Color(0xff400000)),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02*w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: h * 0.02,
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
              SizedBox(
                height: h * 0.03,
              ),
              Text(translateString('Brand Discounts', 'خصومات الماركات'),style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai',
                  color: Colors.black,
                  fontSize: w * 0.045)),
              SizedBox(
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
                                  Text(
                                    translateString('${discountBrands[index].nameEn!} - ${discountBrands[index].discountPercentage == 0 ? discountBrands[index].startDiscountRange : discountBrands[index].discountPercentage}% ${translateString('off', 'خصم')}', '${discountBrands[index].nameAr!} - ${discountBrands[index].discountPercentage == 0 ? discountBrands[index].startDiscountRange : discountBrands[index].discountPercentage}% ${translateString('off', 'خصم')}'),
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
              ),
              SizedBox(
                height: h * 0.02,
              ),
              GridView.builder(
                itemCount: allBrands!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: h*0.1), itemBuilder: (context,index) {
                return InkWell(
                  onTap: (){
                    BlocProvider.of<AppCubit>(context).getBrandProducts(allBrands![index].id.toString());
                  },
                  child: Card(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: w*0.15,
                          height: h * 0.05,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: customCachedNetworkImage(
                              url: EndPoints.IMAGEURL2 +
                                  allBrands![index].logo!,
                              context: context,
                              fit: BoxFit.fill,),
                          ),
                        ),
                        Text(
                          translateString(allBrands![index].nameEn!, allBrands![index].nameAr!),
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
                );
              })
            ],
          ),
        ),
      ),
    );
  },
);
  }
}
