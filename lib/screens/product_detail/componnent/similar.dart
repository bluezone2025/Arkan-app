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
  String code = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      code = preferences.getString('country_code').toString();
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
        SizedBox(
          height: h * 0.02,
        ),
        Center(
          child: Text(
            translateString(LocalKeys.SIMILAR_PRODUCT.tr(), 'عناصر مماثلة'),
            style: TextStyle(
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        GridView.builder(
          itemCount: widget.similar.length,
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 0.38*h,
            mainAxisSpacing: w * 0.02,
            crossAxisSpacing: 5,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index)  =>  Padding(
            padding: EdgeInsets.symmetric(horizontal: w*0.005),
            child: InkWell(
              onTap: () {
                HomeCubit.get(context).getProductdata(
                    productId: widget.similar[index].id.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductDetail()));
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
                                  widget.similar[index].img.toString(),
                              context: context,
                              fit: BoxFit.fill),
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
                              child: Text(translateString(widget.similar[index].titleEn, widget.similar[index].titleAr),maxLines: 1,
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
                              child: Text(translateString(widget.similar[index].descriptionEn, widget.similar[index].descriptionAr),maxLines: 1,
                                style: TextStyle(
                                  fontSize: w * 0.03,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Nunito',
                                ),)
                          ),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          if(widget.similar[index].hasOffer == 1)
                            Text(
                              getProductprice(
                                  currency: currency,
                                  productPrice: widget
                                      .similar[index]
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
                                    widget.similar[index].price),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontFamily: (lang == 'en')
                                      ? 'Nunito'
                                      : 'Almarai',
                                  color: Colors.black,
                                ),
                              ),
                              if(widget.similar[index].hasOffer == 1)
                                Container(
                                  color: mainColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                    child: Text(
                                      " %${(((widget
                                          .similar[index]
                                          .beforePrice - widget
                                          .similar[index].price) / widget
                                          .similar[index]
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
