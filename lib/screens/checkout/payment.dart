// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../DBhelper/cubit.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../fatorah/fatorah.dart';
import '../orders/cubit/order_cubit.dart';

String mAPIKey =
    "GnU465_twWngnRHW5vL_oW6Y9-D8n2OqC-WxpOIvhQNYUkEQDT59thwVA6kb4627K1vFKJoPz-4DRu72vjWEuHZx_fb1PqoKlvCf5kyKS6E4z14_OZBp1ntT-U9_vXXI1DVR_xfvcL5G_wo7pMzLCGWs0hK9qFw0Sp7LpHOabU8rjokKKGfMQBNPzSXwUKIJFw9FoxzLA0zReS_chMUK2_F5yAfPIVnBsETA-6Jv8HJSEIrSE1f-ob7WI_-evjyWbNaYqT0mHWMOUFcsGGVwi49WnUXvJAsopIleFGdGdC1ExwsCLX6TMjuJDIaRrOtQpJ6XFxg7CpL_9fzWyycHQ1m18l9cqDEKphhx6EJIkLtV-WaTTQB5h-AmqwbWYDPguCEKygQO4ONHgBgIErxjkVUixl1iKCWfvMs5Jd43gxcNtgUZUiDbbfZVrQRi81X45DC1kqTO6lI4XGC7QSEUete72gIB_Ex5OXEvkjg273kSiGAHn04ChAu2nca6J2eF89AxHllbOx-wQDCWM-cdLfVOf0nRCzZ8VFZosgNX0E1rm7iKXDXQOnJs3m1En29C2QNiptTe2boZ-DdnKsW8IFGxuOmLjxHDG-WYtxWgHaCi-cdGt1pxREb7y0k69Cp0ip5gDGKxCPIo9o0Sc-YNefmz4M_b5CKRsADzhM0Uofkfg-hE";
String mApiKeyTest =
    "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";

class PaymentScreen extends StatefulWidget {
  final String totalPrice;
  final String orderId;

  const PaymentScreen(
      {Key? key, required this.totalPrice, required this.orderId})
      : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          LocalKeys.PAYMENT_APPBAR.tr(),
          style: TextStyle(
              fontSize: w * 0.05,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: mainColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MyFatoorah(
        afterPaymentBehaviour: AfterPaymentBehaviour.AfterCallbackExecution,
        buildAppBar: (context) {
          return AppBar(
            backgroundColor: Colors.white,
            title: Text(
              LocalKeys.CHECKOUT.tr(),
              style: TextStyle(
                  fontSize: w * 0.05,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            leading: BackButton(
              color: mainColor,
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            elevation: 0,
          );
        },
        onResult: (res) async {
          if (res.isSuccess) {
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
                      "$orderID?paymentId=${res.paymentId}&Id=${res.paymentId}"),
                  headers: {'Content-Language': lang});
              print(response.body);
            } catch (error) {
              print("call back error state : " + error.toString());
            }

            print("success url : ---------" + res.url.toString());

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
              OrderCubit.get(context).getSingleOrder(orderId: widget.orderId);
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

            return null;
          }
          if (res.isError) {
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
            print("error url : ---------" + res.url.toString());
            Navigator.pop(context);
          } else if (res.isNothing) {
            print("no thing url : ---------" + res.url.toString());
            Navigator.pop(context);
          }
        },
        request: MyfatoorahRequest.live(
          token: 'WCuWqL9a-aCqaGBL9zk7KrS1w0cAuymXsSnXJzyp-ctEi8TH-6Etpv-d7DdE-NGVMnGuE1ODXV80UILG3n-45mahc4zHFImPivt5zQ52nvCY_XQXMDpOEenNEVG5OSBLy9h6SECjx4m-ePMK3JnDZdoMayYWQZCpqNGxyDboIQscZeCuWwf2T4IrZF9mwz8ErXy1uGl55LXXzBqmwkh7ffdfn1AYLkNn3dibJ3F5VrVoRSbqtJi6plk4bha-f39yAB8TUgMXBkldkcf4Wz3zm5pX3PC_Xmt4v0QNJBumYUjPJpa8zJqJrjyLOBKEDYi-tbURShKYgHMIqKy2uWHxiCAfkKkDaXrJZiE7Pl2PqZ1FzYErg0si9hf9xMFucQlOUj5rLqJL0A58Z8aaWpQWRFvXpjx3Qk9DX79YoufoJQpqiQ85WOXhuiQt5r_C6XTvB1Q03K2DY5xlcaHQClXQfbv25qqwbuROS4sSxj0ztWFF5O5HI4q082lUl4agC9exOiGQfKTFD1yWsn7pLMqM7y0G2zTzecbNwLtjc7szo1stTFhauSUnBRLEV0A24eqY1pYG-oEtBI9_9O_rvFpOEltJQg29ZoI_0jN-t7qeGwO-Z1mSfHWzjsWD3-YQ5B5_cAd8P2T_Hkj2PCiSmd2eAjRxWfLZL6wwP0J8wuZ0ZoHUxm0Z3lpF4di-nNAG2R__AoOPMETFdj_64b7fZyNIM31i1fQK6MFZjTSMaVziwaE6_M7e',
          language: ApiLanguage.Arabic,
          invoiceAmount: double.parse(widget.totalPrice),
          successUrl: EndPoints.CALL_BACK + "$orderID",
          errorUrl:
              "https://st3.depositphotos.com/3000465/33237/v/380/depositphotos_332373348-stock-illustration-declined-payment-credit-card-vector.jpg?forcejpeg=true",
          currencyIso: Country.Kuwait,
        ),
      ),
    );
  }
}
