// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../product_detail/product_detail.dart';
import '../cubit/home_cubit.dart';

class Offers extends StatefulWidget {
  final List offersItem;

  const Offers({Key? key, required this.offersItem}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  String lang = '';
  String currency = '';

  List<String> d = [
    'assets/d1.jpg',
    'assets/d2.jpg',
    'assets/d3.jpg',
    'assets/d4.jpg'
  ];

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w*0.02),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.005),
          child: InkWell(
            onTap: () {
              HomeCubit.get(context).getProductdata(
                  productId: widget.offersItem[index].id.toString());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail()));
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
                              url: (EndPoints.IMAGEURL2 +
                                  widget.offersItem[index].img.toString()),
                              context: context,
                              fit: BoxFit.cover)
                        ),
                      ),
                      (widget.offersItem[index].hasOffer == 1)
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
                                      .offersItem[index]
                                      .beforePrice - widget
                                      .offersItem[index].price) / widget
                                      .offersItem[index]
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
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
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
                          : Positioned(
                        bottom: 1,
                        right: lang == 'en' ? w*0.02 :w*0.35,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle),
                          height: h * 0.06,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: mainColor,
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
                            constraints: BoxConstraints(
                                maxHeight: h * 0.07, maxWidth: w * 0.38),
                            child: (lang == 'en')
                                ? Text(widget.offersItem[index].titleEn,maxLines: 1,
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                                overflow: TextOverflow.fade)
                                : Text(
                              widget.offersItem[index].titleAr,maxLines: 1,
                              style: TextStyle(
                                fontSize: w * 0.035,
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
                              if(widget.offersItem[index].hasOffer == 1)
                                Text(
                                  getProductprice(
                                      currency: currency,
                                      productPrice: widget
                                          .offersItem[index]
                                          .beforePrice),
                                  style: TextStyle(
                                      fontSize: w * 0.035,
                                      fontFamily: (lang == 'en')
                                          ? 'Nunito'
                                          : 'Almarai',
                                      decoration:
                                      TextDecoration.lineThrough,
                                      color: Colors.black87,
                                      decorationColor: mainColor),
                                ),
                              Text(
                                getProductprice(
                                    currency: currency,
                                    productPrice:
                                    widget.offersItem[index].price),
                                style: TextStyle(
                                    fontSize: w * 0.04,
                                    fontFamily: (lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    color: mainColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          if(widget.offersItem[index].availability == 0)
                            Center(
                              child: Text(
                                translateString('sold out', 'نفذت الكمية'),maxLines: 1,textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Almarai',color: mainColor
                                ),
                                overflow: TextOverflow.fade,
                              ),
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
        itemCount: widget.offersItem.length >= 4 ? 4 :widget.offersItem.length, gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: h*0.38,
        mainAxisSpacing: w * 0.03,
        crossAxisSpacing: 1,
        crossAxisCount: 2,
      ),),
    );
  }
}
