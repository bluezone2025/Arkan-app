// ignore_for_file: use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../bottomnav/homeScreen.dart';
import 'cubit/order_cubit.dart';
import 'order_info.dart';

class Orders extends StatefulWidget {
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    OrderCubit.get(context).getAllorders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            LocalKeys.ORDERS.tr(),
            style: TextStyle(
                fontSize: w * 0.05,
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
            builder: (context, state) {
              return ConditionalBuilder(
                  condition: state is! AllOrdersLoadingState,
                  builder:
                      (context) =>
                          (OrderCubit.get(context)
                                  .allOrdersModel!
                                  .orders!
                                  .isNotEmpty)
                              ? ListView.builder(
                                  itemCount: OrderCubit.get(context)
                                      .allOrdersModel!
                                      .orders!
                                      .length,
                                  itemBuilder: (context, i) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: h * 0.007, bottom: h * 0.005),
                                        child: InkWell(
                                          child: SizedBox(
                                            width: w * 0.9,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: w * 0.9,
                                                  height: h * 0.11,
                                                  child: Row(
                                                    children: [
                                                      if(OrderCubit.get(
                                                          context)
                                                          .allOrdersModel!
                                                          .orders![i]
                                                          .products!.isNotEmpty)
                                                      Container(
                                                        width: w * 0.17,
                                                        height: h * 0.09,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child:
                                                            customCachedNetworkImage(
                                                                url: EndPoints.IMAGEURL2 +
                                                                    OrderCubit.get(
                                                                            context)
                                                                        .allOrdersModel!
                                                                        .orders![i]
                                                                        .products![0]
                                                                        .img!,
                                                                context: context,
                                                                fit: BoxFit.cover),
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.03,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: h * 0.11,
                                                          child: Align(
                                                            alignment: (lang ==
                                                                    'en')
                                                                ? Alignment
                                                                    .centerLeft
                                                                : Alignment
                                                                    .centerRight,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(" # ${OrderCubit.get(context).allOrdersModel!.orders![i].id!}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Almarai',
                                                                          fontSize:
                                                                              w * 0.03,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                SizedBox(
                                                                  height:
                                                                      h * 0.01,
                                                                ),
                                                                (OrderCubit.get(context)
                                                                            .allOrdersModel!
                                                                            .orders![
                                                                                i]
                                                                            .status ==
                                                                        0)
                                                                    ? Text(
                                                                        "#${LocalKeys.ORDER_STATUSE0.tr()}",
                                                                        style: TextStyle(
                                                                            fontSize: w *
                                                                                0.03,
                                                                            color:
                                                                                mainColor,
                                                                            fontFamily: (lang == 'en')
                                                                                ? 'Nunito'
                                                                                : 'Almarai'),
                                                                      )
                                                                    : (OrderCubit.get(context).allOrdersModel!.orders![i].status ==
                                                                            1)
                                                                        ? Text(
                                                                            "#${LocalKeys.ORDER_STATUSE1.tr()}",
                                                                            style: TextStyle(
                                                                                fontSize: w * 0.03,
                                                                                color: mainColor,
                                                                                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai'),
                                                                          )
                                                                        :  (OrderCubit.get(context).allOrdersModel!.orders![i].status ==
                                                                    2) ?
                                                                Text(
                                                                            "#${LocalKeys.ORDER_STATUSE2.tr()}",
                                                                            style: TextStyle(
                                                                                fontSize: w * 0.03,
                                                                                color: mainColor,
                                                                                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai'),
                                                                          ):Text(
                                                                  "#${translateString('pending', 'قيد الانتظار')}",
                                                                  style: TextStyle(
                                                                      fontSize: w * 0.03,
                                                                      color: mainColor,
                                                                      fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai'),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      h * 0.01,
                                                                ),
                                                                Text(
                                                                  OrderCubit.get(
                                                                          context)
                                                                      .allOrdersModel!
                                                                      .orders![
                                                                          i]
                                                                      .createdAt!
                                                                      .substring(
                                                                          0, 10)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontFamily: (lang ==
                                                                              'en')
                                                                          ? 'Nunito'
                                                                          : 'Almarai',
                                                                      fontSize: w *
                                                                          0.03,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: h * 0.01,
                                                ),
                                                Divider(
                                                  height: h * 0.005,
                                                  color: Colors.grey[300],
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            OrderCubit.get(context)
                                                .getSingleOrder(
                                                    orderId:
                                                        OrderCubit.get(context)
                                                            .allOrdersModel!
                                                            .orders![i]
                                                            .id
                                                            .toString());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderInfo()));
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/shopping-bag.png",
                                        height: h * 0.3,
                                        color: mainColor,
                                      ),
                                      SizedBox(
                                        height: h * 0.02,
                                      ),
                                      Text(
                                        LocalKeys.NO_PRODUCT.tr(),
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.05,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        LocalKeys.ORDER_NOW.tr(),
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.05,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: h * 0.02,
                                      ),
                                    ],
                                  ),
                                ),
                  fallback: (context) => Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ));
            },
            listener: (context, state) {}));
  }
}
