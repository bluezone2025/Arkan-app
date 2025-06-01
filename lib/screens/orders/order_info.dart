// ignore_for_file: use_key_in_widget_constructors, prefer_adjacent_string_concatenation
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import 'cubit/order_cubit.dart';

class OrderInfo extends StatefulWidget {
  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: SizedBox(
            width: w * 0.7,
            child: Text(
              "",
              style: TextStyle(
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              ),
            ),
          ),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: w * 0.04),
          centerTitle: false,
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
            builder: (context, state) {
              return ConditionalBuilder(
                  condition: state is! SingleOrdersLoadingState,
                  builder: (context) => Container(
                      width: w,
                      height: h,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                SizedBox(
                                  width: w,
                                  child: Padding(
                                    padding: EdgeInsets.all(w * 0.05),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey,
                                          size: w * 0.09,
                                        ),
                                        SizedBox(
                                          width: w * 0.02,
                                        ),
                                        SizedBox(
                                          width: w * 0.7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                OrderCubit.get(context)
                                                    .singleOrderModel!
                                                    .order!
                                                    .street!,
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    color: Colors.black,
                                                    fontSize: w * 0.04),
                                              ),
                                              // Text(
                                              //    OrderCubit.get(context)
                                              //       .singleOrderModel!
                                              //       .order!
                                              //       .!,
                                              //   style: TextStyle(
                                              //     fontFamily: (lang == 'en')
                                              //         ? 'Nunito'
                                              //         : 'Almarai',
                                              //     color: Colors.grey,
                                              //     fontSize: w * 0.035,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        const Expanded(
                                            child: SizedBox(
                                          width: 1,
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: h * 0.02,
                                  width: w,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(w * 0.05),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        OrderCubit.get(context)
                                            .singleOrderModel!
                                            .order!
                                            .orderItems!
                                            .length, (i) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.00,
                                            vertical: h * 0.01),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (lang == 'en')
                                                ? Text(
                                                    OrderCubit.get(context)
                                                        .singleOrderModel!
                                                        .order!
                                                        .orderItems![i]
                                                        .product!
                                                        .titleEn!,
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: mainColor,
                                                        fontSize: w * 0.035),
                                                  )
                                                : Text(
                                                    OrderCubit.get(context)
                                                        .singleOrderModel!
                                                        .order!
                                                        .orderItems![i]
                                                        .product!
                                                        .titleAr!,
                                                    style: TextStyle(
                                                        fontFamily: 'Almarai',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: mainColor,
                                                        fontSize: w * 0.035),
                                                  ),
                                            SizedBox(
                                              height: h * 0.01,
                                            ),
                                            SizedBox(
                                              width: w,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: w * 0.09,
                                                  ),
                                                  SizedBox(
                                                    height: h * 0.12,
                                                    width: w * 0.18,
                                                    child: customCachedNetworkImage(
                                                        url: EndPoints
                                                                .IMAGEURL2 +
                                                            OrderCubit.get(
                                                                    context)
                                                                .singleOrderModel!
                                                                .order!
                                                                .orderItems![i]
                                                                .product!
                                                                .img!,
                                                        context: context,
                                                        fit: BoxFit.fitHeight),
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.03,
                                                  ),
                                                  SizedBox(
                                                    height: h * 0.13,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          getProductprice(
                                                              currency:
                                                                  currency,
                                                              productPrice: OrderCubit
                                                                      .get(
                                                                          context)
                                                                  .singleOrderModel!
                                                                  .order!
                                                                  .orderItems![
                                                                      i]
                                                                  .product!
                                                                  .price),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  (lang == 'en')
                                                                      ? 'Nunito'
                                                                      : 'Almarai',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: mainColor,
                                                              fontSize:
                                                                  w * 0.035),
                                                        ),
                                                        Container(
                                                          height: h * 0.07,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    w * 0.03),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      w * 0.04,
                                                                ),
                                                                Text(
                                                                  OrderCubit.get(
                                                                          context)
                                                                      .singleOrderModel!
                                                                      .order!
                                                                      .orderItems![
                                                                          i]
                                                                      .quantity
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontFamily: (lang ==
                                                                              'en')
                                                                          ? 'Nunito'
                                                                          : 'Almarai',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          w * .04),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      w * 0.04,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: h * 0.02,
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                              thickness: h * 0.002,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Container(
                                  height: h * 0.02,
                                  width: w,
                                  color: Colors.grey[200],
                                ),
                                SizedBox(
                                  height: h * 0.02,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(w * 0.05),
                                  child: SizedBox(
                                    width: w,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: h * 0.03,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              LocalKeys.TOTAL.tr(),
                                              style: TextStyle(
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  color: Colors.black,
                                                  fontSize: w * 0.05),
                                            ),
                                            Text(
                                              getProductprice(
                                                currency: currency,
                                                productPrice: num.parse(
                                                    OrderCubit.get(context)
                                                        .singleOrderModel!
                                                        .order!
                                                        .totalPrice!),
                                              ),
                                              style: TextStyle(
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  color: Colors.black,
                                                  fontSize: w * 0.055,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: h * 0.06,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  fallback: (context) => Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ));
            },
            listener: (context, state) {}),
      ),
    );
  }
}

InputBorder form() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: mainColor, width: 1.5),
    borderRadius: BorderRadius.circular(5),
  );
}
