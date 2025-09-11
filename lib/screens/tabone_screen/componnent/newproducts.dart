// ignore_for_file: use_key_in_widget_constructors

import 'package:arkan/screens/tabone_screen/componnent/section_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../allproducts/new_product/new_product.dart';
import '../../product_detail/product_detail.dart';
import '../cubit/home_cubit.dart';

class NewProducts extends StatefulWidget {
  final List newItem;

  const NewProducts({Key? key, required this.newItem}) : super(key: key);
  @override
  _NewProductsState createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  String lang = '';
  String currency = '';
  String code = '';
  List products = [];

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      code = preferences.getString('country_code').toString();
    });
    for(int i=0; i< widget.newItem.length;i++){
      for(int x=0; x< widget.newItem[i].countries!.length;x++){
        if(widget.newItem[i].countries![x].code == code){
          setState(() {
            products.add(HomeCubit.get(context).homeitemsModel!.data!.sliders![i]);
          });
        }
      }
    }
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
    return Column(
      children: [
        if(products.isNotEmpty)
        SectionTitle(
            title: translateString('recommended', 'موصي به'),
            press: () =>  Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewProductScreen()))),
        if(products.isNotEmpty)
        SizedBox(
          height: h * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.02),
          child: SizedBox(
            height: products.isEmpty ? 0 : h*0.38,
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>  widget.newItem[index].countries!.any((v) => v.code == code) ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w*0.005),
                child: InkWell(
                  onTap: () {
                    HomeCubit.get(context).getProductdata(
                        productId: widget.newItem[index].id.toString());
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
                                      widget.newItem[index].img.toString(),
                                  context: context,
                                  fit: BoxFit.fill),
                            ),
                          ),
                          if(widget.newItem[index].availability == 0)
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
                                  child: Text(translateString(widget.newItem[index].titleEn, widget.newItem[index].titleAr),maxLines: 1,
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
                                  child: Text(translateString(widget.newItem[index].descriptionEn, widget.newItem[index].descriptionAr),maxLines: 1,
                                    style: TextStyle(
                                      fontSize: w * 0.03,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Nunito',
                                    ),)
                              ),
                              SizedBox(
                                height: h * 0.01,
                              ),
                              if(widget.newItem[index].hasOffer == 1)
                                Text(
                                  getProductprice(
                                      currency: currency,
                                      productPrice: widget
                                          .newItem[index]
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
                                        widget.newItem[index].price),
                                    style: TextStyle(
                                      fontSize: w * 0.04,
                                      fontFamily: (lang == 'en')
                                          ? 'Nunito'
                                          : 'Almarai',
                                      color: Colors.black,
                                    ),
                                  ),
                                  if(widget.newItem[index].hasOffer == 1)
                                    Container(
                                      color: mainColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                        child: Text(
                                          " %${(((widget
                                              .newItem[index]
                                              .beforePrice - widget
                                              .newItem[index].price) / widget
                                              .newItem[index]
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
              ): Container(),
              itemCount: widget.newItem.length >= 4 ? 4 :widget.newItem.length, gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: w*0.47,
              mainAxisSpacing: w * 0.03,
              crossAxisSpacing: 1,
              crossAxisCount: 1,
            ),),
          ),
        ),
      ],
    );
  }
}
