
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfatoorah_flutter/MFApplePayButton.dart';
import 'package:myfatoorah_flutter/MFCardView.dart';
import 'package:myfatoorah_flutter/MFGooglePayButton.dart';
import 'package:myfatoorah_flutter/MFModels.dart';
import 'package:myfatoorah_flutter/MFUtils.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../DBhelper/cubit.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../fatorah/fatorah.dart';
import '../orders/cubit/order_cubit.dart';
import 'checkout.dart';

class Config {
  /*
TODO: The following API token key for testing only, so that when you go live
      don't forget to replace the following key with the live key provided by MyFatoorah.
      You can get the API Token Key from here:
      https://myfatoorah.readme.io/docs/test-token
*/
  static const String testAPIKey =
      'WCuWqL9a-aCqaGBL9zk7KrS1w0cAuymXsSnXJzyp-ctEi8TH-6Etpv-d7DdE-NGVMnGuE1ODXV80UILG3n-45mahc4zHFImPivt5zQ52nvCY_XQXMDpOEenNEVG5OSBLy9h6SECjx4m-ePMK3JnDZdoMayYWQZCpqNGxyDboIQscZeCuWwf2T4IrZF9mwz8ErXy1uGl55LXXzBqmwkh7ffdfn1AYLkNn3dibJ3F5VrVoRSbqtJi6plk4bha-f39yAB8TUgMXBkldkcf4Wz3zm5pX3PC_Xmt4v0QNJBumYUjPJpa8zJqJrjyLOBKEDYi-tbURShKYgHMIqKy2uWHxiCAfkKkDaXrJZiE7Pl2PqZ1FzYErg0si9hf9xMFucQlOUj5rLqJL0A58Z8aaWpQWRFvXpjx3Qk9DX79YoufoJQpqiQ85WOXhuiQt5r_C6XTvB1Q03K2DY5xlcaHQClXQfbv25qqwbuROS4sSxj0ztWFF5O5HI4q082lUl4agC9exOiGQfKTFD1yWsn7pLMqM7y0G2zTzecbNwLtjc7szo1stTFhauSUnBRLEV0A24eqY1pYG-oEtBI9_9O_rvFpOEltJQg29ZoI_0jN-t7qeGwO-Z1mSfHWzjsWD3-YQ5B5_cAd8P2T_Hkj2PCiSmd2eAjRxWfLZL6wwP0J8wuZ0ZoHUxm0Z3lpF4di-nNAG2R__AoOPMETFdj_64b7fZyNIM31i1fQK6MFZjTSMaVziwaE6_M7e';//TODO Get your google merchant id
  static const String googleMerchantId = "your_google_merchant_id";
}

String mAPIKey = 'WCuWqL9a-aCqaGBL9zk7KrS1w0cAuymXsSnXJzyp-ctEi8TH-6Etpv-d7DdE-NGVMnGuE1ODXV80UILG3n-45mahc4zHFImPivt5zQ52nvCY_XQXMDpOEenNEVG5OSBLy9h6SECjx4m-ePMK3JnDZdoMayYWQZCpqNGxyDboIQscZeCuWwf2T4IrZF9mwz8ErXy1uGl55LXXzBqmwkh7ffdfn1AYLkNn3dibJ3F5VrVoRSbqtJi6plk4bha-f39yAB8TUgMXBkldkcf4Wz3zm5pX3PC_Xmt4v0QNJBumYUjPJpa8zJqJrjyLOBKEDYi-tbURShKYgHMIqKy2uWHxiCAfkKkDaXrJZiE7Pl2PqZ1FzYErg0si9hf9xMFucQlOUj5rLqJL0A58Z8aaWpQWRFvXpjx3Qk9DX79YoufoJQpqiQ85WOXhuiQt5r_C6XTvB1Q03K2DY5xlcaHQClXQfbv25qqwbuROS4sSxj0ztWFF5O5HI4q082lUl4agC9exOiGQfKTFD1yWsn7pLMqM7y0G2zTzecbNwLtjc7szo1stTFhauSUnBRLEV0A24eqY1pYG-oEtBI9_9O_rvFpOEltJQg29ZoI_0jN-t7qeGwO-Z1mSfHWzjsWD3-YQ5B5_cAd8P2T_Hkj2PCiSmd2eAjRxWfLZL6wwP0J8wuZ0ZoHUxm0Z3lpF4di-nNAG2R__AoOPMETFdj_64b7fZyNIM31i1fQK6MFZjTSMaVziwaE6_M7e';
class PaymentScreen extends StatefulWidget {
  final String totalPrice;
  final String orderId;
  const PaymentScreen(
      {Key? key,
        required this.totalPrice,
        required this.orderId})
      : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  String? _response = '';
  MFInitiateSessionResponse? session;

  List<MFPaymentMethod> paymentMethods = [];
  List<bool> isSelected = [];
  int selectedPaymentMethodIndex = -1;

  bool visibilityObs = false;
  late MFCardPaymentView mfCardView;
  late MFApplePayButton mfApplePayButton;
  late MFGooglePayButton mfGooglePayButton;
  String lang = '';
  String token = '';
  bool islogin = false;
  int? orderID;
  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      token = preferences.getString('token') ?? '';
      islogin = preferences.getBool('login') ?? false;
      orderID = prefs.getInt('order_id')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getLang();
    initiate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initiate() async {
    if (Config.testAPIKey.isEmpty) {
      setState(() {
        _response =
        "Missing API Token Key.. You can get it from here: https://myfatoorah.readme.io/docs/test-token";
      });
      return;
    }

    // TODO, don't forget to init the MyFatoorah Plugin with the following line
    print(1);
    try{
      await MFSDK.init(Config.testAPIKey, MFCountry.KUWAIT, MFEnvironment.LIVE);
    }catch(e){
      print(e.toString());
    }
    print(2);
    // (Optional) un comment the following lines if you want to set up properties of AppBar.
    // MFSDK.setUpActionBar(
    //     toolBarTitle: 'Company Payment',
    //     toolBarTitleColor: '#FFEB3B',
    //     toolBarBackgroundColor: '#CA0404',
    //     isShowToolBar: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initiateSessionForCardView();
      await initiateSessionForGooglePay();
      await initiatePayment();
      // await initiateSession();
    });
  }

  log(Object object) {
    var json = const JsonEncoder.withIndent('  ').convert(object);
    setState(() {
      debugPrint(json);
      _response = json;
    });
  }

  // Initiate Payment
  initiatePayment() async {
    print(7);
    var request = MFInitiatePaymentRequest(
        invoiceAmount: double.parse(widget.totalPrice.toString()),
        currencyIso: MFCurrencyISO.KUWAIT_KWD);
    print(8);
    try{
      await MFSDK
          .initiatePayment(request, MFLanguage.ENGLISH)
          .then((value) => {
        log(value),
        paymentMethods.addAll(value.paymentMethods!),
        for (int i = 0; i < paymentMethods.length; i++)
          isSelected.add(false)
      })
          .catchError((error) => {log(error.message)});
    }catch(e){
      print(e.toString());
    }
    print(9);
    print(paymentMethods.length);
  }

  // Execute Regular Payment
  executeRegularPayment(int paymentMethodId) async {
    var request = MFExecutePaymentRequest(
        paymentMethodId: paymentMethodId, invoiceValue: double.parse(widget.totalPrice.toString()));
    request.displayCurrencyIso = MFCurrencyISO.KUWAIT_KWD;

    // var recurring = MFRecurringModel();
    // recurring.intervalDays = 10;
    // recurring.recurringType = MFRecurringType.Custom;
    // recurring.iteration = 2;
    // request.recurringModel = recurring;

    await MFSDK
        .executePayment(request, MFLanguage.ENGLISH, (invoiceId) {
      log(invoiceId);
    })
        .then((res) async {
      DataBaseCubit.get(context).deleteTableContent();
      Fluttertoast.showToast(
          msg: (lang == "en")
              ? "Payment completed successfully"
              : "لقد تمت عملية الدفع بنجاح ",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
      try {
        var response = await http.post(
            Uri.parse(EndPoints.CALL_BACK +
                "$orderID?paymentId=${res.invoiceId}&Id=${res.invoiceId}"),
            headers: {'Content-Language': lang});
        print(response.body);
      } catch (error) {
        print("call back error state : " + error.toString());
      }

      print("success url : ---------" + res.invoiceReference.toString());

      if (islogin) {
        DataBaseCubit.get(context).deleteTableContent();
        DataBaseCubit.get(context).cart = [];
        OrderCubit.get(context).getAllorders();
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => Orders()),
        //     (route) => false);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const FatorahScreen()),
                (route) => false);

    }})
        .catchError((error) {
      DataBaseCubit.get(context).deleteTableContent();
      DataBaseCubit.get(context).cart = [];
      Fluttertoast.showToast(
          msg: (lang == "en")
              ? "Please try again later"
              : "بالرجاء المحاولة ف وقت لاحق",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    });
  }

  setPaymentMethodSelected(int index, bool value) {
    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = value;
        if (value) {
          selectedPaymentMethodIndex = index;
          visibilityObs = paymentMethods[index].isDirectPayment!;
        } else {
          selectedPaymentMethodIndex = -1;
          visibilityObs = false;
        }
      } else {
        isSelected[i] = false;
      }
    }
  }

  executePayment() {
    if (selectedPaymentMethodIndex == -1) {
      setState(() {
        _response = "Please select payment method first";
      });
    } else {
      if (widget.totalPrice.toString().isEmpty) {
        setState(() {
          _response = "Set the amount";
        });
      } else {
        executeRegularPayment(
            paymentMethods[selectedPaymentMethodIndex].paymentMethodId!);
      }
    }
  }

  MFCardViewStyle cardViewStyle() {
    MFCardViewStyle cardViewStyle = MFCardViewStyle();
    cardViewStyle.cardHeight = 240;
    cardViewStyle.hideCardIcons = false;
    cardViewStyle.backgroundColor = getColorHexFromStr("#ccd9ff");
    cardViewStyle.input?.inputMargin = 3;
    cardViewStyle.label?.display = true;
    cardViewStyle.input?.fontFamily = MFFontFamily.TimesNewRoman;
    cardViewStyle.label?.fontWeight = MFFontWeight.Light;
    cardViewStyle.savedCardText?.saveCardText = "حفظ بيانات البطاقة";
    cardViewStyle.savedCardText?.addCardText = "استخدام كارت اخر";
    MFDeleteAlert deleteAlertText = MFDeleteAlert();
    deleteAlertText.title = "حذف البطاقة";
    deleteAlertText.message = "هل تريد حذف البطاقة";
    deleteAlertText.confirm = "نعم";
    deleteAlertText.cancel = "لا";
    cardViewStyle.savedCardText?.deleteAlertText = deleteAlertText;
    return cardViewStyle;
  }

  initiateSessionForCardView() async {
    /*
      If you want to use saved card option with embedded payment, send the parameter
      "customerIdentifier" with a unique value for each customer. This value cannot be used
      for more than one Customer.
     */
    // var request = MFInitiateSessionRequest("12332212");
    /*
      If not, then send null like this.
     */
    MFInitiateSessionRequest initiateSessionRequest =
    MFInitiateSessionRequest(customerIdentifier: "123");
    print(3);
    try{
      await MFSDK.initSession(initiateSessionRequest, MFLanguage.ENGLISH)
          .then((value) => loadEmbeddedPayment(value))
          .catchError((error) => {log(error.message)});
    }catch(e){
      print(e.toString());
    }
    print(4);
  }
  loadCardView(MFInitiateSessionResponse session) {
    mfCardView.load(session, (bin) {
      log(bin);
    });
  }

  loadEmbeddedPayment(MFInitiateSessionResponse session) async {
    MFExecutePaymentRequest executePaymentRequest =
    MFExecutePaymentRequest(invoiceValue: 10);
    executePaymentRequest.displayCurrencyIso = MFCurrencyISO.KUWAIT_KWD;
    await loadCardView(session);
    if (Platform.isIOS) {
      applePayPayment(session);
    }
  }

  applePayPayment(MFInitiateSessionResponse session) async {
    MFExecutePaymentRequest executePaymentRequest =
    MFExecutePaymentRequest(invoiceValue: 0.01);
    executePaymentRequest.displayCurrencyIso = MFCurrencyISO.SAUDIARABIA_SAR;

    await mfApplePayButton
        .displayApplePayButton(
        session, executePaymentRequest, MFLanguage.ENGLISH)
        .then((value) => {
      log(value),
      // mfApplePayButton
      //     .executeApplePayButton(null, (invoiceId) => log(invoiceId))
      //     .then((value) => log(value))
      //     .catchError((error) => {log(error.message)})
    })
        .catchError((error) => {log(error.message)});
  }

  pay() async {
    var executePaymentRequest = MFExecutePaymentRequest(invoiceValue: 10);

    await mfCardView
        .pay(executePaymentRequest, MFLanguage.ENGLISH, (invoiceId) {
      debugPrint("-----------$invoiceId------------");
      log(invoiceId);
    })
        .then((value) => log(value))
        .catchError((error) => {log(error.message)});
  }

  // GooglePay Section
  initiateSessionForGooglePay() async {
    MFInitiateSessionRequest initiateSessionRequest = MFInitiateSessionRequest(
      // A uniquue value for each customer must be added
        customerIdentifier: "12332212");
    print(5);
    try{
      await MFSDK
          .initSession(initiateSessionRequest, MFLanguage.ENGLISH)
          .then((value) => {setupGooglePayHelper(value.sessionId)})
          .catchError((error) => {log(error.message)});
    }catch(e){
      print(e.toString());
    }
    print(6);
  }

  setupGooglePayHelper(String sessionId) async {
    MFGooglePayRequest googlePayRequest = MFGooglePayRequest(
        totalPrice: "1",
        merchantId: Config.googleMerchantId,
        merchantName: "Test Vendor",
        countryCode: MFCountry.KUWAIT,
        currencyIso: MFCurrencyISO.UAE_AED);

    await mfGooglePayButton
        .setupGooglePayHelper(sessionId, googlePayRequest, (invoiceId) {
      log("-----------Invoice Id: $invoiceId------------");
    })
        .then((value) => log(value))
        .catchError((error) => {log(error.message)});
  }
//#region aaa

//endregion

  // UI Section
  @override
  Widget build(BuildContext context) {
    mfCardView = MFCardPaymentView(cardViewStyle: cardViewStyle());
    mfApplePayButton = MFApplePayButton(applePayStyle: MFApplePayStyle());
    mfGooglePayButton = MFGooglePayButton();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 1,
        //   title: const Text('Plugin example app'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Text("Payment Amount", style: textStyle()),
              Text(widget.totalPrice.toString(), style: textStyle().copyWith(fontSize: 25)),
              paymentMethodsList(),
              btn("Execute Payment", executePayment),

            ],
          ),
        ),
      ),
    );
  }

  Widget embeddedCardView() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: mfCardView,
        ),
        Row(
          children: [
            const SizedBox(width: 2),
            Expanded(child: elevatedButton("Pay", pay)),
            const SizedBox(width: 2),
            elevatedButton("", initiateSessionForCardView),
          ],
        )
      ],
    );
  }

  Widget applePayView() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: mfApplePayButton,
        )
      ],
    );
  }

  Widget googlePayButton() {
    return SizedBox(
      height: 70,
      child: mfGooglePayButton,
    );
  }

  Widget paymentMethodsList() {
    return Column(
      children: [
        Text("Select payment method", style: textStyle()),
        SizedBox(
          height: 200,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: paymentMethods.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return paymentMethodsItem(ctxt, index);
              }),
        ),
      ],
    );
  }

  Widget paymentMethodsItem(BuildContext ctxt, int index) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: 70,
        height: 75,
        child: Container(
          decoration: isSelected[index]
              ? BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2))
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Image.network(
                      paymentMethods[index].imageUrl!,
                      height: 35.0,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      paymentMethods[index].paymentMethodEn ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight:
                        isSelected[index] ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Checkbox(
                      checkColor: Colors.blueAccent,
                      activeColor: const Color(0xFFC9C5C5),
                      value: isSelected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          setPaymentMethodSelected(index, value!);
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btn(String title, Function onPressed) {
    return SizedBox(
      width: double.infinity, // <-- match_parent
      child: elevatedButton(title, onPressed),
    );
  }

  Widget elevatedButton(String title, Function onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        backgroundColor:
        WidgetStateProperty.all<Color>(const Color(0xff000000)),
        shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.red, width: 1.0),
              );
            } else {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.white, width: 1.0),
              );
            }
          },
        ),
      ),
      child: (title.isNotEmpty)
          ? Text(title, style: textStyle())
          : const Icon(Icons.refresh),
      onPressed: () async {
        await onPressed();
      },
    );
  }

  Widget amountInput() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: TextEditingController(text: widget.totalPrice.toString()),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color(0xff0495ca),
        hintText: "0.00",
        contentPadding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      onChanged: (value) {

      },
    );
  }

  TextStyle textStyle() {
    return const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic);
  }

// @override
// Widget build(BuildContext context) {
//   return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text(
//             translateString('PAY', 'الدفع'),
//             style: TextStyle(
//                 fontSize: w * 0.05,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold),
//           ),
//           leading: BackButton(
//             color: Colors.black,
//             onPressed: () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => ConfirmCart(
//                       maxCopounLimit: widget.maxCopounLimit,
//                       couponPrice: widget.couponPrice,
//                       couponName: widget.couponName,
//                       couponPercentage: widget.couponPercentage)),
//             ),
//           ),
//           centerTitle: true,
//           elevation: 0,
//         ),
//         body: MyFatoorah(
//           afterPaymentBehaviour: AfterPaymentBehaviour.AfterCallbackExecution,
//           onResult: (res) async {
//             if (res.isSuccess) {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text(''),
//                   content: Text(translateString(
//                       'Payment was completed successfully. \n Please wait and do not close the application until the invoice appears',
//                       'تم الدفع بنجاح \n برجاء الانتظار و عدم غلق التطبيق حتى تظهر الفاتورة'),textAlign: TextAlign.center,),
//                 ),
//               );
//               try {
//                 final String url = domain + "update-order";
//                 Response response = await Dio().post(
//                   url,
//                   data: {
//                     "order_id": widget.orderId,
//                     'invoice_id': res.paymentId,
//                     'invoice_link': res.url,
//                   },
//                   options: Options(headers: {
//                     "auth-token": (login) ? auth : null,
//                     "Content-Language": prefs.getString('language_code') ?? 'en'
//                   }),
//                 );
//                 print(response.data);
//                 if (response.data['status'] == 1){
//                   print("success url : ---------" + res.url.toString());
//                   Navigator.pop(context);
//                   Provider.of<CartProvider>(context, listen: false).clearAll();
//                   dbHelper.deleteAll();
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => Home()),
//                           (route) => false);
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceDetails(id: widget.orderId,tabby: false, wallet: false,)));
//                   BlocProvider.of<AppCubit>(context).isBox(false);
//                 }else{
//                   print("error url : ---------" + res.url.toString());
//                   Navigator.pop(context);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ConfirmCart(
//                             maxCopounLimit: widget.maxCopounLimit,
//                             couponPrice: widget.couponPrice,
//                             couponName: widget.couponName,
//                             couponPercentage: widget.couponPercentage)),
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(translateString("there is an error", 'حدث خطا'),style: TextStyle(color: Colors.black,fontSize: w*0.035,fontWeight: FontWeight.bold),),
//                       backgroundColor: Colors.white,
//                       duration: const Duration(seconds: 5),
//                     ),
//                   );
//                 }
//               } catch (e) {
//                 print(e.toString());
//               }
//             } else if (res.isError) {
//               print("error url : ---------" + res.url.toString());
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ConfirmCart(
//                         maxCopounLimit: widget.maxCopounLimit,
//                         couponPrice: widget.couponPrice,
//                         couponName: widget.couponName,
//                         couponPercentage: widget.couponPercentage)),
//               );
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(translateString("there is an error", 'حدث خطا'),style: TextStyle(color: Colors.black,fontSize: w*0.035,fontWeight: FontWeight.bold),),
//                   backgroundColor: Colors.white,
//                   duration: const Duration(seconds: 5),
//                 ),
//               );
//             } else if (res.isNothing) {
//               print("no thing url : ---------" + res.url.toString());
//               Navigator.pop(context);
//             }
//           },
//           buildAppBar: app_bar_home,
//           request: MyfatoorahRequest.live(
//               currencyIso: prefs.getString('currencyEn') == 'SAR' ?  Country.SaudiArabia : Country.Kuwait,
//               successUrl: 'https://www.svgrepo.com/show/13650/success.svg',
//               errorUrl: 'https://www.shutterstock.com/image-vector/caution-exclamation-mark-white-red-600w-1055269061.jpg',
//               invoiceAmount: widget.totalprice,
//               language: ApiLanguage.Arabic,
//               token:
//               '-hKvXHUcEYhfM9KlZpcP4ylBew7UL7BqLPkE4khaa-gVj-3-8Kptmbh_0BOmeh2FfLBdMbSkpbR3uh_cIhGVw_MFIafEKvzTH4tm6YXNADcRp2zeyDQO0FasIEf1LovI2qxbf6Vho5Cl4zO47opy9K6ajwCj2pzGhb83N6Im7iuib0vIfRTcYJjjW6M-b_0NVWzfDCoGl2YwGvQG57ciPEYJ9_VhEUH8wVt6xkkuRz0SFb0IatwO7XTAzwhMEMp-enmTdqOepi2dJ_o8a73y5nb8ERa-eEMTgn2IYLevtJHIAMDLOCE8BIS-0eIFYUHRbtwgwm6SWm6Ya2XreIXpJ72n_NoTHeTIQP2slUxLuyClTolc8JTkqOlOpb6q12J9J_8eJOUz5jSIThuKF4mrUpJlZoH4Pm4RFSuvwc8xCc8D4ehSUuLzBewUzqWuUF1_6nc9Cr62MV6JYPN0JfaNLOXq9wr-cmSUYgAKdWNbEzHOXF87GxxRO1RxK9d9LOPvM4OamQp0GbDgn-5YY2FzFntWEiUlVgOs3Ejc99OmkuBlEVvXm8XCGkBjZvT9gEkS_U7STMNe-m78Fl_XRpPgPhqe4E_hqkZDScMAlV0zt4_EnpBfFaYccp7OBTzLHXWZ1UPGyZVaisuiY_fCBZB3AVGaDhbc-6ZO8pwNITkYYG1A0hDU'
//           ),
//         ),
//       )
//   );
// }
//
// static PreferredSizeWidget app_bar_home(BuildContext context) {
//   var w = MediaQuery.of(context).size.width;
//   var h = MediaQuery.of(context).size.height;
//   return AppBar(
//     backgroundColor: Colors.white,
//     automaticallyImplyLeading: false,
//     elevation: 0.5,
//     toolbarHeight: h*0.07,
//     leading: BackButton(color: Colors.black,),
//     centerTitle: true,
//     title: Text(
//       translateString('PAY', 'الدفع'),
//       style: TextStyle(
//           fontSize: w * 0.05,
//           color: Colors.black,
//           fontWeight: FontWeight.bold),
//     ),
//     bottom: PreferredSize(
//       preferredSize: Size(w, h * 0.07),
//       child: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: w*0.05),
//           child: Text(
//             translateString('The payment process may be completed in three to five minutes. Please wait and do not close the program until the invoice appears', 'قد تكتمل عملية الدفع فى ثلاث الى خمس دقائق برجاء الانتظار و عدم غلق البرنامج حتى تظهر الفاتورة'),
//             style: TextStyle(
//                 color: Colors.black, fontSize: w * 0.035),textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     ),
//   );
// }
}