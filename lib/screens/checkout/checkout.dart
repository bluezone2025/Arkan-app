// ignore_for_file: use_key_in_widget_constructors
import 'dart:convert';

import 'package:arkan/screens/checkout/payment.dart';
import 'package:arkan/screens/checkout/tabby_checkout.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import '../../DBhelper/appState.dart';
import '../../DBhelper/cubit.dart';
import '../../app_cubit/app_cubit.dart';
import 'package:http/http.dart' as http;
import '../../app_cubit/appstate.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../cart/cart_product/body.dart';
import '../cart/cart_product/conponent.dart';
import '../cart/cubit/cart_cubit.dart';
import '../fatorah/fatorah.dart';
import '../loading.dart';
import '../orders/cubit/order_cubit.dart';
import '../orders/model/all_orders.dart';
import '../tabone_screen/cubit/home_cubit.dart';

class ConfirmCart extends StatefulWidget {
  final String totalPrice;
  final String orderId;
  final String subTotal;
  final String city;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? discount;
  final int cartLength;
  final String tabbyAmount;

  const ConfirmCart(
      {Key? key,
      required this.totalPrice,
      required this.discount,
      required this.subTotal,
      required this.orderId,
      required this.cartLength,
      required this.city,
      required this.address, required this.name, required this.email, required this.phone, required this.tabbyAmount})
      : super(key: key);

  @override
  _ConfirmCartState createState() => _ConfirmCartState();
}

class _ConfirmCartState extends State<ConfirmCart> {
  int? selected;
  int _counter = 2;
  int loyalty = 0;
  String lang = '';
  String currency = '';
  String rejectionReason = '';
  String _status = 'idle';
  bool islogin = false;
  bool rejected = false;
  bool show = false;
  TabbySession? session;
  TransactionStatusResponse? tabbyStatus;

  void _setStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  Future<void> createSession() async {
    print(1);
    print(islogin);
    if(islogin){
      if(OrderCubit.get(context).allOrdersModel!.orders!.isNotEmpty){
        for(var i =0 ;i< OrderCubit.get(context).allOrdersModel!.orders!.length ;i++){
          if(OrderCubit.get(context).allOrdersModel!.orders![i].status != 0){
            setState(() {
              loyalty++;
            });
          }
        }
      }
    }
    List<Orders>? orders;
    if(islogin){
      orders = OrderCubit.get(context).allOrdersModel!.orders!;
      if(orders.isNotEmpty){
        for(var i =0 ;i< orders.length ;i++){
          if(orders[i].id.toString() == widget.orderId){
            orders.removeAt(i);
          }
        }
      }
    }
    try {
      _setStatus('pending');
      print(2);
      print(getProductPriceTabby(currency: currency, productPrice: num.parse(widget.totalPrice)));
      //print(getProductPriceTabby(currency: currency, productPrice: num.parse(DataBaseCubit.get(context).cart[0]['productPrice'].toString())));
      final s = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: "Arkan",
        lang: lang == 'en' ? Lang.en : Lang.ar,
        payment: Payment(
          amount: getProductPriceTabby(currency: currency, productPrice: num.parse(widget.totalPrice) + num.parse(widget.tabbyAmount)),
          currency: currency == 'BHD' ? Currency.bhd : currency == 'QAR' ? Currency.qar : currency == 'AED' ? Currency.aed : currency == 'SAR' ? Currency.sar : Currency.kwd,
          buyer: Buyer(
            email: widget.email,
            phone: widget.phone,
            name: widget.name,
            //dob: '',
          ),
          buyerHistory: BuyerHistory(
            loyaltyLevel: loyalty,
            registeredSince: prefs.getString('created_at') ?? '2019-08-24T14:15:22Z',
            wishlistCount: 0,
          ),
          shippingAddress: ShippingAddress(
            city: widget.city,
            address: widget.address,
            zip: 'string',
          ),
          order: Order(
              referenceId: widget.orderId,
              items: List.generate(
                  DataBaseCubit.get(context).cart.length,
                      (index) => OrderItem(
                    title: (RayanCartBody.lang == 'en')
                        ? DataBaseCubit.get(context).cart[index]
                    ['productNameEn']
                        : DataBaseCubit.get(context).cart[index]
                    ['productNameAr'],
                    description: (RayanCartBody.lang == 'en')
                        ? DataBaseCubit.get(context).cart[index]
                    ['productDescEn']
                        : DataBaseCubit.get(context).cart[index]
                    ['productDescAr'],
                    quantity: (DataBaseCubit.get(context).counter[
                    DataBaseCubit.get(context).cart[index]
                    ['productId']] ==
                        null)
                        ? DataBaseCubit.get(context).cart[index]
                    ['productQty']
                        : DataBaseCubit.get(context).counter[
                    DataBaseCubit.get(context).cart[index]
                    ['productId']],
                    unitPrice: getProductPriceTabby(currency: currency, productPrice: num.parse(DataBaseCubit.get(context).cart[index]['productPrice'].toString())) ,
                    referenceId: DataBaseCubit.get(context)
                        .cart[index]['productId']
                        .toString(),
                    productUrl: 'http://example.com',
                    category: 'gifts',
                  ))),
          orderHistory: islogin ? (orders!
              .isNotEmpty)
              ?
          List.generate(orders.length, (index) =>
              OrderHistoryItem(amount: getProductPriceTabby(currency: currency, productPrice: num.parse(orders![index].totalPrice!)),
                  status: orders[index].status == 2 ? OrderHistoryItemStatus.complete : orders[index].status == 1 ? OrderHistoryItemStatus.processing : OrderHistoryItemStatus.newOne,
                  purchasedAt: orders[index].createdAt!,
                paymentMethod: orders[index].cash! == 0 ? OrderHistoryItemPaymentMethod.card : OrderHistoryItemPaymentMethod.cod
              )) :
          [
            // OrderHistoryItem(
            //   purchasedAt: '2019-08-24T14:15:22Z',
            //   amount: '10.00',
            //   paymentMethod: OrderHistoryItemPaymentMethod.card,
            //   status: OrderHistoryItemStatus.newOne,
            // )
          ]:[
            // OrderHistoryItem(
            //   purchasedAt: '2019-08-24T14:15:22Z',
            //   amount: '10.00',
            //   paymentMethod: OrderHistoryItemPaymentMethod.card,
            //   status: OrderHistoryItemStatus.newOne,
            // )
          ],
        ),
      ));
      print(3);
      debugPrint('Session id: ${s.sessionId}');
      setState(() {
        session = s;
      });
      print(s);
      _setStatus('created');
      try {
        var response = await http.get(Uri.parse('https://api.tabby.ai/api/v2/checkout/${s.sessionId}'),headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${'pk_01906df0-1e90-6966-bc4a-db8b84a1b2ad'}',
        },);
        print(response.body);
        var data = jsonDecode(response.body);
        if(data['status'] == 'rejected'){
          setState(() {
            rejectionReason = data['configuration']['products']['installments']['rejection_reason'];
            rejected = true;
          });
        }
      } catch (error) {
        print("call back error state : " + error.toString());
      }
    } catch (e, s) {
      printError(e, s);
      _setStatus('error');
    }
  }

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      islogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    BlocProvider.of<AppCubit>(context).tabbyStatus();
    CartCubit.get(context).deliveryModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                LocalKeys.CHECKOUT.tr(),
                style: TextStyle(
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: w * 0.04),
              ),
              leading: const BackButton(color: Colors.black,),
              elevation: 0,
            ),
            body: Column(
              children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Image.asset('assets/payment_p.png',width: w*0.8,height: h*0.06,),
                    SizedBox(
                      height: h * 0.04,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                      child: Row(
                        children: [
                          Text(
                           translateString('Payment options', 'خيارات الدفع'),
                            style: TextStyle(
                                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: w * 0.034),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.04,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _counter = 2;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: w * 0.06,
                                  height: w * 0.06,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: mainColor, width: w * 0.005),
                                    color: _counter == 2 ? mainColor : Colors.white,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.done),
                                      onPressed: () {},
                                      iconSize: w * 0.04,
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: h * 0.02,
                                ),
                                Text(
                                  LocalKeys.VISA.tr(),
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/visa.png'
                                  ,height: h*0.04,
                                ),
                                SizedBox(
                                  width: h * 0.01,
                                ),
                                Image.asset('assets/icons/knet.png',height: h*0.04,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(currency != 'OMR')
                      Column(
                        children: [
                          SizedBox(
                            height: h * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _counter = 3;
                              });
                              createSession();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: w * 0.06,
                                        height: w * 0.06,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                              color: mainColor, width: w * 0.005),
                                          color: _counter == 3 ? mainColor : Colors.white,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(Icons.done),
                                            onPressed: () {},
                                            iconSize: w * 0.04,
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: h * 0.02,
                                      ),
                                      Text(
                                        translateString('Pay in 4. No interest, no fees.', 'قسّمها على 4. بدون أي فوائد، أو رسوم.'),
                                        style: TextStyle(
                                          fontSize: w * 0.03,
                                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/tabby.png'
                                    ,height: h*0.04,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if(_counter == 3 && rejected)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: w*0.95,
                                height: h*0.05,
                                color: Colors.red[50],
                                child: Center(child: Text(rejectionReason == 'not_available' ?
                                translateString('Sorry, Tabby is unable to approve this purchase. Please use an alternative payment method for your order.',
                                    'نأسف، تابي غير قادرة على الموافقة على هذه العملية. الرجاء استخدام طريقة دفع أخرى.') : rejectionReason == 'order_amount_too_high' ?
                                translateString('This purchase is above your current spending limit with Tabby, try a smaller cart or use another payment method',
                                    'قيمة الطلب تفوق الحد الأقصى المسموح به حاليًا مع تابي. يُرجى تخفيض قيمة السلة أو استخدام وسيلة دفع أخرى.') : rejectionReason == 'order_amount_too_low' ?
                                translateString('The purchase amount is below the minimum amount required to use Tabby, try adding more items or use another payment method',
                                    'قيمة الطلب أقل من الحد الأدنى المطلوب لاستخدام خدمة تابي. يُرجى زيادة قيمة الطلب أو استخدام وسيلة دفع أخرى.') : '',style: const TextStyle(color: Colors.red,fontSize: 11),)),
                              ),
                            ),
                          if(prefs.getInt('is_tabby_active') == 1 && _counter == 3)
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
                          if(_counter == 3)
                            TabbyCheckoutSnippet(price: getProductPriceTabby(currency: currency, productPrice: num.parse(widget.totalPrice) + num.parse(widget.tabbyAmount)),
                              currency: currency == 'BHD' ? Currency.bhd : currency == 'QAR' ? Currency.qar : currency == 'AED' ? Currency.aed : currency == 'SAR' ? Currency.sar : Currency.kwd,
                              lang: RayanCartBody.lang == 'en' ? Lang.en : Lang.ar,),
                        ],
                      ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _counter = 1;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: w * 0.06,
                                  height: w * 0.06,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: mainColor, width: w * 0.005),
                                    color: _counter == 1 ? mainColor : Colors.white,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.done),
                                      onPressed: () {},
                                      iconSize: w * 0.04,
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: h * 0.02,
                                ),
                                Text(
                                  translateString(
                                      'cash on delivery', 'الدفع عند الاستلام'),
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/cash.png'
                              ,height: h*0.04,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.04,
                    ),
                    Text(
                      translateString('Application Summary', 'ملخص الطلب'),
                      style: TextStyle(
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontWeight: FontWeight.normal,
                          color: mainColor,
                          fontSize: w * 0.034),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    BlocConsumer<CartCubit, CartState>(
                        builder: (context, state) {
                          return ConditionalBuilder(
                              condition: state is! DeliveryLoadingState,
                              builder: (context) => Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: w * 0.043),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translateString(LocalKeys.PRICE.tr(), 'الإجمالي'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.normal,
                                              fontSize: w * 0.034),
                                        ),
                                        Text(
                                          getProductprice(
                                              currency: currency,
                                              productPrice:
                                              num.parse(widget.subTotal)),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.normal,
                                              fontSize: w * 0.04),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: h * 0.01,
                                    ),
                                    BlocConsumer<HomeCubit, AppCubitStates>(
                                        builder: (context, state) {
                                          return Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                translateString(LocalKeys.SHIPPING.tr(), 'التوصيل'),
                                                style: TextStyle(
                                                    color: (HomeCubit.get(
                                                        context)
                                                        .settingModel!
                                                        .data!
                                                        .isFreeShop! ==
                                                        0)
                                                        ? Colors.black
                                                        : Colors.red,
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: w * 0.034),
                                              ),
                                              (HomeCubit.get(context)
                                                  .settingModel!
                                                  .data!
                                                  .isFreeShop ==
                                                  0)
                                                  ? Text(
                                                getProductprice(
                                                  currency: currency,
                                                  productPrice:
                                                  num.parse(
                                                    prefs
                                                        .getString(
                                                        "delivery_value")
                                                        .toString(),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                    (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: w * 0.04),
                                              )
                                                  : Text(
                                                LocalKeys.FREE_SHIPPING
                                                    .tr(),
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily:
                                                  (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  fontSize: w * 0.04,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        listener: (context, state) {}),
                                    SizedBox(
                                      height: h * 0.01,
                                    ),
                                    (widget.discount != null)
                                        ? Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          LocalKeys.DISCOUNT.tr(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.normal,
                                              fontSize: w * 0.034),
                                        ),
                                        Text(
                                          getProductprice(
                                              currency: currency,
                                              productPrice: num.parse(
                                                  widget.discount!)),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.w400,
                                              fontSize: w * 0.04),
                                        ),
                                      ],
                                    )
                                        : const SizedBox(),
                                    (widget.discount != null)
                                        ? SizedBox(
                                      height: h * 0.03,
                                    )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: h * 0.01,
                                    )
                                  ],
                                ),
                              ),
                              fallback: (context) => Container());
                        },
                        listener: (context, state) {}),
                    Padding(
                      padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                      child: Row(
                        children: [
                          Text(
                            translateString('Review the order', 'مراجعة الطلب'),
                            style: TextStyle(
                                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: w * 0.034),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${translateString('Review the order', 'شحنة 1 من ( ')} ${DataBaseCubit.get(context).cart.length} ${translateString('Review the order', 'منتج ) ')}',
                            style: TextStyle(
                                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: w * 0.034),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                show = true;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  translateString('more', 'المزيد'),
                                  style: TextStyle(
                                      fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: w * 0.034),
                                ),
                                const Icon(Icons.arrow_drop_down,color: Colors.grey,)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[350],
                      height: 3,
                    ),
                    if(show)
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
                            increaseqty: InkWell(
                              onTap: () async {
                                CartCubit.get(context).checkProductQty(
                                    context: context,
                                    index: index,
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
                            )
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
                    Divider(
                      color: Colors.grey[350],
                      height: 3,
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translateString('By completing the purchase, you agree to all', 'بإتمام عملية الشراء، فانت توافق على كافة'),
                                style: TextStyle(
                                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: w * 0.03),
                              ),
                              Text(
                                translateString('terms and conditions and the privacy policy', 'الشروط والأحكام و سياسة الخصوصية'),
                                style: TextStyle(
                                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                    fontSize: w * 0.03),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    Divider(
                      color: Colors.grey[350],
                      height: 3,
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocalKeys.TOTAL_PRICE.tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily:
                                (lang == 'en') ? 'Nunito' : 'Almarai',
                                fontWeight: FontWeight.normal,
                                fontSize: w * 0.035),
                          ),
                          Text(
                            getProductprice(
                                currency: currency,
                                productPrice:
                                num.parse(widget.subTotal) + num.parse(
                                  prefs
                                      .getString(
                                      "delivery_value")
                                      .toString(),
                                ) + (_counter == 3 ? num.parse(widget.tabbyAmount) : 0)),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                fontWeight: FontWeight.normal,
                                fontSize: w * 0.045),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    BlocConsumer<DataBaseCubit, DatabaseStates>(
                        builder: (context, state) =>
                            BlocConsumer<OrderCubit, OrderState>(
                              listener: (context, state) {
                                if (state is CashOrdersSuccessState) {
                                  LoadingScreen.pop(context);
                                  DataBaseCubit.get(context)
                                      .deleteTableContent();
                                  Fluttertoast.showToast(
                                      msg: (lang == "en")
                                          ? "Order completed successfully"
                                          : "لقد تمت عملية الطلب بنجاح ",
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_LONG);
                                  if (islogin) {
                                    DataBaseCubit.get(context)
                                        .deleteTableContent();
                                    DataBaseCubit.get(context).cart =
                                    [];
                                    OrderCubit.get(context)
                                        .getAllorders();
                                    // Navigator.pushAndRemoveUntil(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => Orders()),
                                    //     (route) => false);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const FatorahScreen()),
                                            (route) => false);
                                  } else {
                                    DataBaseCubit.get(context)
                                        .deleteTableContent();
                                    DataBaseCubit.get(context).cart =
                                    [];
                                    OrderCubit.get(context)
                                        .getSingleOrder(
                                        orderId: widget.orderId);
                                    // Navigator.pushAndRemoveUntil(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => HomeScreen(
                                    //               index: 0,
                                    //             )),
                                    //     (route) => false);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const FatorahScreen()),
                                            (route) => false);
                                  }
                                }
                                if(state is CashOrdersLoadingState){
                                  LoadingScreen.show(context);
                                }if(state is CashOrdersErrorState){
                                  LoadingScreen.pop(context);
                                }
                              },
                              builder: (context, state) {
                                return BlocConsumer<AppCubit,
                                    AppCubitStates>(
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    return InkWell(
                                      onTap: () async {
                                        // DataBaseCubit.get(context)
                                        //     .deleteTableContent();
                                        await OrderCubit.get(context)
                                            .getSingleOrder(
                                            orderId:
                                            widget.orderId);
                                        print(widget.orderId);
                                        if (_counter == 1) {
                                          DataBaseCubit.get(context).deleteTableContent();
                                          OrderCubit.get(context)
                                              .cashOrder(
                                              orderId:
                                              widget.orderId);
                                          BlocProvider.of<AppCubit>(
                                              context)
                                              .notifyCount();
                                          prefs.setString('paymentMethod', 'cash' );
                                        }
                                        if (_counter == 2) {
                                          prefs.setString('paymentMethod', 'online' );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen(
                                                    orderId: widget.orderId,
                                                    totalPrice:
                                                    widget.totalPrice,
                                                  ),
                                            ),
                                          );
                                        }
                                        if (_counter == 3 && _status == 'created') {
                                          prefs.setString('paymentMethod', 'tabby' );
                                          Navigator.pushNamed(
                                            context,
                                            '/checkout',
                                            arguments:
                                            TabbyCheckoutNavParams(
                                              selectedProduct: session!
                                                  .availableProducts
                                                  .installments!,
                                            ),
                                          );
                                          setState(() {
                                            _counter = 2;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: w * 0.75,
                                        height: h * 0.06,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                w * 0.02),
                                            color: mainColor),
                                        child: Center(
                                          child: Text(
                                            translateString(
                                                'Complete Order',
                                                'استكمال الطلب'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: w * 0.034),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        listener: (context, state) {
                          if (state is DeleteTablecontentDatabase) {
                            DataBaseCubit.get(context).cart = [];
                          }
                        }),
                    SizedBox(
                      height: h * 0.03,
                    ),
                  ],
                ),
              ),
            ),
                          ],
                        ),
          ),
        );
      },
    );
  }
}
