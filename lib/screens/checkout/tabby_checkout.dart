import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:http/http.dart' as http;

import '../../DBhelper/cubit.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../bottomnav/homeScreen.dart';
import '../fatorah/fatorah.dart';
import '../orders/cubit/order_cubit.dart';

class TabbyCheckoutNavParams {
  TabbyCheckoutNavParams({
    required this.selectedProduct,
  });

  final TabbyProduct selectedProduct;
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late TabbyProduct selectedProduct;

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
    getLang();
    super.initState();
  }

  Future<void> onResult(WebViewResult res) async {
    if(res.name == 'close'){
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: translateString('You aborted the payment. Please retry or choose another payment method.', 'لقد ألغيت الدفعة. فضلاً حاول مجددًا أو اختر طريقة دفع أخرى.'),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
    }else if(res.name == 'authorized'){
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
            Uri.parse('https://arkan-q8.com/api/V1/tabby_callback/$orderID' ),
            headers: {'Content-Language': lang});
        print(response.body);
      } catch (error) {
        print("call back error state : " + error.toString());
      }

      print("success url : ---------" + res.name.toString());

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
      } else {
        DataBaseCubit.get(context).deleteTableContent();
        DataBaseCubit.get(context).cart = [];
        OrderCubit.get(context).getSingleOrder(orderId: orderID.toString());
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
                builder: (context) => const FatorahScreen()),
                (route) => false);
      }
    }else if(res.name == 'rejected'){
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: translateString('Sorry, Tabby is unable to approve this purchase. Please use an alternative payment method for your order',
              'نأسف، تابي غير قادرة على الموافقة على هذه العملية. الرجاء استخدام طريقة دفع أخرى.'),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
    }else if(res.name == 'expired'){
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: translateString('Sorry, Tabby is unable to approve this purchase. Please use an alternative payment method for your order',
              'نأسف، تابي غير قادرة على الموافقة على هذه العملية. الرجاء استخدام طريقة دفع أخرى.'),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)!.settings;
    selectedProduct =
        (settings.arguments as TabbyCheckoutNavParams).selectedProduct;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: TabbyWebView(
          webUrl: selectedProduct.webUrl,
          onResult: onResult,
        ),
      ),
    );
  }
}