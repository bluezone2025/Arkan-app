import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../product_detail/product_detail.dart';
import '../cubit/home_cubit.dart';

class BestSellers extends StatefulWidget {
  final List bestItem;
  const BestSellers({Key? key, required this.bestItem}) : super(key: key);

  @override
  _BestSellersState createState() => _BestSellersState();
}

class _BestSellersState extends State<BestSellers> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: h * 0.02,
        ),
        Padding(
          padding: EdgeInsets.only(left: w * 0.01, right: w * 0.01),
          child: Center(
            child: Text(
              LocalKeys.HOME_BEST.tr(),
              style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        SizedBox(
          width: w,
          height: h * 0.3,
          child: ListView.builder(
            itemCount: widget.bestItem.length,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return InkWell(
                child: Padding(
                  padding: (lang == 'en')
                      ? EdgeInsets.only(left: w * 0.04)
                      : EdgeInsets.only(right: w * 0.04),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(w * 0.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: w * 0.4,
                          height: h * 0.3,
                          color: Colors.grey[200],
                          child: ClipRRect(
                            child: customCachedNetworkImage(
                              url:
                                  EndPoints.IMAGEURL2 + widget.bestItem[i].img!,
                              context: context,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: w * 0.02,
                        ),
                        SizedBox(
                          width: w * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: h * 0.01,
                              ),
                              Container(
                                  constraints: BoxConstraints(
                                      maxHeight: h * 0.07, maxWidth: w * 0.4),
                                  child: (lang == 'en')
                                      ? Text(widget.bestItem[i].titleEn,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Nunito',
                                              fontSize: w * 0.05),
                                          overflow: TextOverflow.fade)
                                      : Text(widget.bestItem[i].titleAr,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Almarai',
                                              fontSize: w * 0.05),
                                          overflow: TextOverflow.fade)),
                              SizedBox(
                                height: h * 0.005,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        (lang == 'en')
                                            ? TextSpan(
                                                text: widget
                                                    .bestItem[i].descriptionEn,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                ))
                                            : TextSpan(
                                                text: widget
                                                    .bestItem[i].descriptionAr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                )),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getProductprice(
                                            currency: currency,
                                            productPrice:
                                                widget.bestItem[i].price),
                                        style: TextStyle(
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          color: mainColor,
                                        ),
                                      ),
                                      (widget.bestItem[i].hasOffer == 1)
                                          ? Text(
                                              getProductprice(
                                                  currency: currency,
                                                  productPrice: widget
                                                      .bestItem[i].beforePrice),
                                              style: TextStyle(
                                                  fontSize: w * 0.04,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.grey,

                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  decorationColor: mainColor),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  (widget.bestItem[i].availability == 0)
                                      ? SizedBox(
                                          height: h * 0.01,
                                        )
                                      : Container(),
                                  (widget.bestItem[i].availability == 0)
                                      ? Text(
                                          translateString(
                                              "product is unavailable",
                                              "المنتج غير متاح حاليا"),
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color: mainColor,
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  (widget.bestItem[i].availability != 0)
                                      ? InkWell(
                                          onTap: () {
                                            HomeCubit.get(context)
                                                .getProductdata(
                                                    productId: widget
                                                        .bestItem[i].id
                                                        .toString());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetail()));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: w * 0.023,
                                                vertical: h * 0.015),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.02)),
                                            child: Text(
                                              LocalKeys.ADD_CART.tr(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: w * 0.04,
                                                color: Colors.white,
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  HomeCubit.get(context).getProductdata(
                      productId: widget.bestItem[i].id.toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductDetail()));
                },
              );
            },
          ),
        ),
        SizedBox(
          height: h * 0.02,
        ),
      ],
    );
  }
}
