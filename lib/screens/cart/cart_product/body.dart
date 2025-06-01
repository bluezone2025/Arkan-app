// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../../DBhelper/appState.dart';
import '../../../DBhelper/cubit.dart';
import '../../../app_cubit/app_cubit.dart';
import '../../../app_cubit/appstate.dart';
import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../../address/add_address.dart';
import '../../country/cubit/country_cubit.dart';
import '../../tabone_screen/cubit/home_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../model/copoun_model.dart';
import 'conponent.dart';

class RayanCartBody extends StatefulWidget {
  final int cartLength;
  static String lang = '';
  static String currency = '';
  static num finalPrice = 0;
  static num discount = 0.0;

  const RayanCartBody({Key? key,required this.cartLength}) : super(key: key);
  @override
  State<RayanCartBody> createState() => _RayanCartBodyState();
}

class _RayanCartBodyState extends State<RayanCartBody> {
  String lang = '';
  String currency = '';
  TextEditingController controller = TextEditingController();
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();
  RoundedLoadingButtonController btncontroller =
      RoundedLoadingButtonController();
  CopounModel? copounModel;
  bool isCopoun = false;
  Future<CopounModel?> getCheckcobon(
      {required String cobon,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    try {
      var response = await http
          .post(Uri.parse(EndPoints.CHECK_COBON + "?coupon_code=$cobon"));
      var data = jsonDecode(response.body);
      print(response.body);
      if (data['status'] == 1) {
        controller.success();
        setState(() {
          copounModel = CopounModel.fromJson(data);
          isCopoun = true;
        });
        RayanCartBody.discount =
            (copounModel!.data!.percentage! * RayanCartBody.finalPrice) / 100;
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        return copounModel;
      } else {
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Fluttertoast.showToast(
            msg: data['message'].toString(),
            textColor: Colors.white,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    } catch (error) {
      print("errrrrrrrrrrrrrrrrrrrrrrrrrro " + error.toString());
    }
    return copounModel;
  }

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    RayanCartBody.finalPrice = 0;
    setState(
      () {
        RayanCartBody.lang = preferences.getString('language').toString();
        lang = preferences.getString('language').toString();
        RayanCartBody.currency = preferences.getString('currency').toString();
        currency = preferences.getString('currency').toString();
        for (var item in DataBaseCubit.get(context).cart) {
          RayanCartBody.finalPrice += item['productPrice'] * item['productQty'];
        }
      },
    );
  }

  @override
  void initState() {
    getLang();
    print(prefs.getInt('is_tabby_active'));
    super.initState();
  }

  bool click = false;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return BlocConsumer<DataBaseCubit, DatabaseStates>(
      builder: (context, state) {
        return SizedBox(
          width: w,
          height: h,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: DataBaseCubit.get(context).cart.length,
                        itemBuilder: (context, index) {
                          return buildCartIem(
                            days: DataBaseCubit.get(context).cart[index]['productDescAr'] == 'daza' ? DataBaseCubit.get(context).cart[index]['productDescEn'] : '',
                            title: (RayanCartBody.lang == 'en')
                                ? DataBaseCubit.get(context).cart[index]['productNameEn']
                                : DataBaseCubit.get(context).cart[index]['productNameAr'],
                            price: DataBaseCubit.get(context).cart[index]
                                    ['productPrice'] *
                                DataBaseCubit.get(context).counter[
                                    DataBaseCubit.get(context).cart[index]['productId']],
                            description: DataBaseCubit.get(context).cart[index]['productDescAr'] == 'daza' ? 'daza' :(RayanCartBody.lang == 'en')
                                ? DataBaseCubit.get(context).cart[index]['productDescEn']
                                : DataBaseCubit.get(context).cart[index]['productDescAr'],
                            image: DataBaseCubit.get(context).cart[index]['productImg'],
                            qty: (DataBaseCubit.get(context).counter[
                                        DataBaseCubit.get(context).cart[index]
                                            ['productId']] ==
                                    null)
                                ? DataBaseCubit.get(context).cart[index]['productQty']
                                : DataBaseCubit.get(context).counter[
                                    DataBaseCubit.get(context).cart[index]['productId']],
                            context: context,
                            decreaseqty: () {
                              if (DataBaseCubit.get(context).cart.isEmpty) {
                                setState(() {
                                  RayanCartBody.finalPrice = 0;
                                });
                              }
                              if (DataBaseCubit.get(context).counter[
                                      DataBaseCubit.get(context).cart[index]
                                          ['productId']] ==
                                  1) {
                                DataBaseCubit.get(context).deletaFromDB(
                                  id: DataBaseCubit.get(context).cart[index]['productId'],
                                );
                                setState(() {
                                  RayanCartBody.finalPrice -= DataBaseCubit.get(context)
                                      .cart[index]['productPrice'];
                                });
                              } else {
                                setState(() {
                                  DataBaseCubit.get(context).counter[
                                          DataBaseCubit.get(context).cart[index]
                                              ['productId']] =
                                      int.parse(DataBaseCubit.get(context)
                                              .cart[index]['productQty']
                                              .toString()) -
                                          1;
                                  RayanCartBody.finalPrice -= DataBaseCubit.get(context)
                                      .cart[index]['productPrice'];
                                  if (RayanCartBody.finalPrice < 0 ||
                                      DataBaseCubit.get(context).cart.isEmpty) {
                                    RayanCartBody.finalPrice = 0;
                                  }
                                });
                              }
                              DataBaseCubit.get(context).updateDatabase(
                                productId: DataBaseCubit.get(context).cart[index]
                                    ['productId'],
                                productQty: DataBaseCubit.get(context).counter[
                                    DataBaseCubit.get(context).cart[index]['productId']]!,
                              );
                            },
                            delete: (){
                              DataBaseCubit.get(context).deletaFromDB(
                                id: DataBaseCubit.get(context).cart[index]['productId'],
                              );
                              setState(() {
                                RayanCartBody.finalPrice -= DataBaseCubit.get(context)
                                    .cart[index]['productPrice'];
                              });
                            },
                            increaseqty: BlocConsumer<CartCubit, CartState>(
                              builder: (context, state) {
                                return InkWell(
                                  onTap: () async {
                                    CartCubit.get(context).checkProductQty(
                                        context: context,
                                        productId: DataBaseCubit.get(context)
                                            .cart[index]['productId']
                                            .toString(),
                                        productQty: DataBaseCubit.get(context)
                                            .cart[index]['productQty']
                                            .toString(),
                                        sizeId: DataBaseCubit.get(context)
                                            .cart[index]['sizeId']
                                            .toString(),
                                        colorId: DataBaseCubit.get(context)
                                            .cart[index]['colorId']
                                            .toString());
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: w * 0.06,
                                  ),
                                );
                              },
                              listener: (context, state) {
                                if(!click){
                                  if (state is CheckProductAddcartSuccessState &&
                                      DataBaseCubit.get(context).counter[
                                      DataBaseCubit.get(context).cart[index]
                                      ['productId']]! <=
                                          CartCubit.get(context).totalQuantity) {
                                    setState(() {
                                      click = true;
                                    });
                                    print(1);
                                    setState(() {
                                      RayanCartBody.finalPrice += DataBaseCubit.get(context)
                                          .cart[index]['productPrice'];
                                    });
                                    print(2);
                                    Future.delayed(const Duration(seconds: 1)).then((value) async {
                                      setState(() {
                                        click = false;
                                      });
                                    });
                                  } else if (state is CheckProductAddcartSuccessState &&
                                      DataBaseCubit.get(context).counter[
                                      DataBaseCubit.get(context).cart[index]
                                      ['productId']]! >
                                          CartCubit.get(context).totalQuantity) {
                                    setState(() {
                                      click = true;
                                    });
                                    print(3);
                                    setState(() {
                                      RayanCartBody.finalPrice = RayanCartBody.finalPrice;
                                    });
                                    print(4);
                                    Future.delayed(const Duration(seconds: 1)).then((value) async {
                                      setState(() {
                                        click = false;
                                      });
                                    });
                                  }
                                }
                              },
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>  Padding(
                          padding: EdgeInsets.symmetric(horizontal: w*0.06),
                          child: Container(
                            width: w*0.5,
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      if(currency != 'OMR')
                        TabbyPresentationSnippet(
                          price: getProductPriceTabby(currency: currency, productPrice: RayanCartBody.finalPrice),
                          currency: currency == 'BHD' ? Currency.bhd : currency == 'QAR' ? Currency.qar : currency == 'AED' ? Currency.aed : currency == 'SAR' ? Currency.sar : Currency.kwd,
                          lang: lang == 'en' ? Lang.en :Lang.ar,
                        ),
                      if(prefs.getInt('is_tabby_active') == 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                            child: Text(
                              translateString('7% tax will be added', 'سيتم اضافة 7% ضريبة'),
                              style: TextStyle(
                                fontSize: w * 0.035,
                                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translateString('add message', 'اضف رسالة'),
                            style: TextStyle(
                                fontFamily: (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                fontSize: w * 0.045,
                                fontWeight:
                                FontWeight.bold,
                                color: mainColor),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: w * 0.03,
                            right: w * 0.03),
                        decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius:
                            BorderRadius.circular(25)),
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily:
                              (lang == 'en')
                                  ? 'Nunito'
                                  : 'Almarai',
                              color: Colors.black),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          controller: editingController1,
                          maxLines: 5,
                          textInputAction:
                          TextInputAction.next,
                          validator: (value) {
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder:
                            InputBorder.none,
                            enabledBorder:
                            InputBorder.none,
                            errorBorder:
                            InputBorder.none,
                            focusedErrorBorder:
                            InputBorder.none,
                            errorStyle: TextStyle(
                                fontFamily:
                                (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                color: Colors.white),
                            hintText: 'اكتب الرسالة التي تريدها هنا',
                            hintStyle: TextStyle(
                                fontFamily:
                                (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',fontSize: w*0.03,
                                color:
                                Colors.black45),
                            labelStyle: TextStyle(
                                fontFamily:
                                (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.04,
                      ),
                      Container(
                        height:0.05*h,
                        width: 0.9*w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black45)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: SizedBox(
                                width: 0.45*w,
                                //height: 7.h,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: editingController2,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                      (lang == 'en')
                                          ? 'Nunito'
                                          : 'Almarai',
                                      color: Colors.black),
                                  cursorColor: Colors.black,
                                  maxLines: 1,
                                  textInputAction:
                                  TextInputAction.next,
                                  validator: (value) {
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder:
                                    InputBorder.none,
                                    enabledBorder:
                                    InputBorder.none,
                                    errorBorder:
                                    InputBorder.none,
                                    focusedErrorBorder:
                                    InputBorder.none,
                                    errorStyle: TextStyle(
                                        fontFamily:
                                        (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        color: Colors.white),
                                    hintText: translateString('Add link here', 'اضف لينك هنا'),
                                    hintStyle:TextStyle(color: Colors.black45,fontSize: w*0.04,fontWeight: FontWeight.w100,fontFamily: 'Almarai',),
                                    labelStyle: TextStyle(
                                        fontFamily:
                                        (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',fontSize: w*0.04,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SvgPicture.asset('assets/icons/link.svg',)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.04,
                      ),
                      cobonButton(
                        context: context,
                      ),
                      SizedBox(
                        height: h * 0.05,
                      ),
                      Row(
                        children: [
                          Text(
                            translateString(LocalKeys.PRICE.tr(), 'إجمالي المبلغ'),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily:
                                  (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.04,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            getProductprice(
                                currency: RayanCartBody.currency,
                                productPrice: RayanCartBody.finalPrice),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily:
                                  (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.04,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      BlocConsumer<HomeCubit, AppCubitStates>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Text(
                                  translateString(LocalKeys.SHIPPING.tr(), 'رسوم التوصيل'),
                                  style: TextStyle(
                                    color: (HomeCubit.get(context)
                                                .settingModel!
                                                .data!
                                                .isFreeShop! ==
                                            0)
                                        ? Colors.black
                                        : Colors.red,
                                    fontFamily: (RayanCartBody.lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                  ),
                                ),
                                const Spacer(),
                                (HomeCubit.get(context).settingModel!.data!.isFreeShop! ==
                                        0)
                                    ? Text(
                                        LocalKeys.DEPEND_CITY.tr(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: (RayanCartBody.lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.04,
                                        ),
                                      )
                                    : Text(
                                        LocalKeys.FREE_SHIPPING.tr(),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: (RayanCartBody.lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.04,
                                        ),
                                      )
                              ],
                            );
                          },
                          listener: (context, state) {}),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      (isCopoun)
                          ? Row(
                              children: [
                                Text(
                                  LocalKeys.DISCOUNT.tr(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: (RayanCartBody.lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  getProductprice(
                                      currency: RayanCartBody.currency,
                                      productPrice: double.parse(
                                          ((RayanCartBody.finalPrice *
                                                      copounModel!.data!.percentage!) /
                                                  100)
                                              .toStringAsFixed(2))),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: (RayanCartBody.lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: h*0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: w,
                child: BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: w*0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (isCopoun)
                              ? Text(
                            getProductprice(
                                currency: RayanCartBody.currency,
                                productPrice: (RayanCartBody.finalPrice -
                                    (RayanCartBody.finalPrice *
                                        copounModel!.data!.percentage!) /
                                        100)),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: (RayanCartBody.lang == 'en')
                                  ? 'Nunito'
                                  : 'Almarai',
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.055,
                            ),
                          )
                              : Text(
                            getProductprice(
                                currency: RayanCartBody.currency,
                                productPrice: RayanCartBody.finalPrice),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: (RayanCartBody.lang == 'en')
                                  ? 'Nunito'
                                  : 'Almarai',
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.055,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              BlocProvider.of<AppCubit>(context).getAvailableTimes();
                              SharedPreferences prefs =
                              await SharedPreferences
                                  .getInstance();
                              prefs.setString('add_message', editingController1.text);
                              prefs.setString('data_url', editingController2.text);
                              print( prefs.getString('add_message'));
                              await CountryCubit.get(context).getCity();
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => AddressInfo(cartLength: widget.cartLength,)));
                            },
                            child: Container(
                              width: w*0.4,
                              height: h*0.06,
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget cobonButton({required BuildContext context}) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    final formKey = GlobalKey<FormState>();
    return BlocConsumer<CartCubit, CartState>(
        builder: (context, state) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: w*0.65,
              decoration: BoxDecoration(
                color: const Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(5)
              ),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: controller,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily:
                    (lang == 'en')
                        ? 'Nunito'
                        : 'Almarai',
                    color: Colors.black),
                cursorColor: Colors.black,
                maxLines: 1,
                textInputAction:
                TextInputAction.next,
                validator: (value) {
                  return null;
                },
                decoration: InputDecoration(
                  focusedBorder:
                  InputBorder.none,
                  enabledBorder:
                  InputBorder.none,
                  errorBorder:
                  InputBorder.none,
                  focusedErrorBorder:
                  InputBorder.none,
                  errorStyle: TextStyle(
                      fontFamily:
                      (lang == 'en')
                          ? 'Nunito'
                          : 'Almarai',
                      color: Colors.white),
                  hintText: translateString(LocalKeys.ADD_COBON.tr(), 'اضف كوبون خصم'),
                  hintStyle: TextStyle(
                      fontFamily:
                      (lang == 'en')
                          ? 'Nunito'
                          : 'Almarai',fontSize: w*0.035,fontWeight: FontWeight.bold,
                      color:
                      Colors.black45),
                  labelStyle: TextStyle(
                      fontFamily:
                      (lang == 'en')
                          ? 'Nunito'
                          : 'Almarai',fontSize: w*0.04,
                      color: Colors.black),
                ),
              ),
            ),
            RoundedLoadingButton(
                controller: btncontroller,
                color: mainColor,
                width: w*0.3,
                successColor: Colors.green,
                errorColor: Colors.red,
                disabledColor: Colors.white,
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences
                      .getInstance();
                  prefs.setString(
                      'cobon', controller.text);
                  getCheckcobon(
                      cobon: controller.text,
                      context: context,
                      controller: btncontroller);
                },
                borderRadius: 5,
                child: Text(
                  translateString(LocalKeys.SEND.tr(), 'تطبيـق'),
                  style: TextStyle(
                      color: Colors.white,fontWeight: FontWeight.bold,fontSize: w*0.04),
                )),
          ],
        ),
        listener: (context, state) async {});
  }
}
