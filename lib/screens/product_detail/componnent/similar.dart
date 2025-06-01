import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'as localized;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../tabone_screen/cubit/home_cubit.dart';
import '../product_detail.dart';

class SimilarProduct extends StatefulWidget {
  final List similar;

  const SimilarProduct({Key? key, required this.similar}) : super(key: key);

  @override
  State<SimilarProduct> createState() => _SimilarProductState();
}

class _SimilarProductState extends State<SimilarProduct> {
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
    String sale = (lang == 'en') ? 'OFF' : 'خصم';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            bottom: 5, // Space between underline and text
          ),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(
                color: mainColor,
                width: 1.0, // Underline thickness
              ))
          ),
          child: Text(
            translateString(LocalKeys.SIMILAR_PRODUCT.tr(), 'منتجات مشاهبه'),
            style: TextStyle(
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        GridView.builder(
          itemCount: widget.similar.length,
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 0.35*h,
            mainAxisSpacing: w * 0.02,
            crossAxisSpacing: 5,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              HomeCubit.get(context).getProductdata(
                  productId: widget.similar[index].id.toString());
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ProductDetail()));
            },
            child: Card(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: w * 0.45,
                          height: h * 0.25,
                          color: Colors.white,
                          child: customCachedNetworkImage(
                              url: EndPoints.IMAGEURL2 +
                                  widget.similar[index].img.toString(),
                              context: context,
                              fit: BoxFit.fill),
                        ),
                      ),
                      (widget.similar[index].hasOffer == 1)
                          ? Positioned(
                        //top: h*0.0,
                        right: lang == 'en' ? w*0.02 :w*0.35,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  shape: BoxShape.circle
                              ),
                              height: h*0.06,
                              child: Center(
                                child: Text(
                                  " %${(((widget
                                      .similar[index]
                                      .beforePrice - widget
                                      .similar[index].price) / widget
                                      .similar[index]
                                      .beforePrice ) * 100).toInt()} ",
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                      'Bahij',
                                      fontSize: w * 0.028,
                                      fontWeight:
                                      FontWeight
                                          .w500),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.13,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                              height: h*0.06,
                              child:  Center(
                                child: Icon(Icons.add,color: mainColor,),
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    width: w * 0.4,
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
                                ? Text(widget.similar[index].titleEn,maxLines: 1,
                                style: TextStyle(
                                  fontSize: w * 0.03,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                                overflow: TextOverflow.fade)
                                : Text(
                              widget.similar[index].titleAr,maxLines: 1,
                              style: TextStyle(
                                fontSize: w * 0.03,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Almarai',
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getProductprice(
                                    currency: currency,
                                    productPrice:
                                    widget.similar[index].price),
                                style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontFamily: (lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    color: mainColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              (widget.similar[index].hasOffer == 1)
                                  ? Text(
                                getProductprice(
                                    currency: currency,
                                    productPrice: widget.similar[index]
                                        .beforePrice),
                                style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontFamily: (lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    decoration:
                                    TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    decorationColor: mainColor),
                              )
                                  : Container(),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.01,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: h * 0.05,
        ),

        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextAnimator(
                'Arkan store is the best place for shipping',
                style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontSize: w * 0.04,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0
                ),
                incomingEffect:
                WidgetTransitionEffects.incomingScaleDown(),
                characterDelay: const Duration(milliseconds: 50),
                atRestEffect: WidgetRestingEffects.wave(),
                //outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
