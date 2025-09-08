// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../address/add_address.dart';
import 'body.dart';

Widget buildCartIem(
    {required String title,
    required String description,
    required String days,
    required String image,
    required num price,
    required int qty,
    required Widget increaseqty,
    required VoidCallback decreaseqty,
    required VoidCallback delete,
    required BuildContext context}) {
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;

  return SizedBox(
    width: w,
    height: h*0.22,
    //decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            EndPoints.IMAGEURL2 + image,
            width: w * 0.25,
            height: h * 0.1,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: w * 0.03,
        ),
        SizedBox(
          width: w*0.64,
          height: h * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: w*0.4,
                        child: Text(
                          title,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: w * 0.035,
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Almarai',
                          ),
                        ),
                      ),
                      IconButton(onPressed: delete, icon: SvgPicture.asset('assets/icons/delete.svg'))
                    ],
                  ),
                  Text(
                    description,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: w * 0.032,
                      fontFamily: (RayanCartBody.lang == 'en')
                          ? 'Nunito'
                          : 'Almarai',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.03,
              ),
              if(description == 'daza')
                Text('( $days ) * $qty ',style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: w * 0.025,
                  fontFamily: (RayanCartBody.lang == 'en')
                      ? 'Nunito'
                      : 'Almarai',
                ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getProductprice(
                      currency: RayanCartBody.currency,
                      productPrice: price),style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: w * 0.045,
                    fontFamily: (RayanCartBody.lang == 'en')
                        ? 'Nunito'
                        : 'Almarai',
                  ),),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  if(description != 'daza')
                  Row(
                    children: [
                      SizedBox(
                        width: w * 0.01,
                      ),
                      InkWell(
                          onTap: decreaseqty,
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffF3F3F3),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.remove,
                                size: w * 0.06,
                              ),
                            ),
                          )),
                      SizedBox(
                        width: w * 0.025,
                      ),
                      Text(
                        '$qty',
                        style: TextStyle(
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Alamari',
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: w * 0.025,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffF3F3F3),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: increaseqty,
                          )),
                      SizedBox(
                        width: w * 0.01,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget myDiv({
  required double height,
}) =>
    Container(
      width: double.infinity,
      height: height,
      color: Colors.black54,
    );

Widget payButton({required BuildContext context, required final  cartLength}) {
  var w = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddressInfo(cartLength: cartLength,)));
    },
    child: Container(
      height: 55,
      decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(15)),
      child: Center(
          child: Text(
        LocalKeys.CHECKOUT.tr(),
        style: TextStyle(
            fontSize: w * 0.05,
            fontFamily: (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
            fontWeight: FontWeight.bold,
            color: Colors.white),
      )),
    ),
  );
}
