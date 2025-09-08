import 'package:arkan/componnent/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../DBhelper/appState.dart';
import '../../DBhelper/cubit.dart';
import '../../generated/local_keys.dart';
import '../bottomnav/homeScreen.dart';
import 'cart_product/body.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: h*0.05,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          translateString(LocalKeys.CART.tr(), 'حقيبة التسوق'),
          style: TextStyle(
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              fontSize: w * 0.04,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   InkWell(
        //     onTap: () {},
        //     child: const Icon(
        //       Icons.menu,
        //       color: Colors.black,
        //     ),
        //   ),
        // ],
      ),
      body: BlocConsumer<DataBaseCubit, DatabaseStates>(
        builder: (context, state) {
          return (DataBaseCubit.get(context).cart.isNotEmpty)
              ? RayanCartBody(cartLength: DataBaseCubit.get(context).cart.length,)
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * 0.05,
                      ),
                      Center(
                        child: SvgPicture.asset('assets/icons/cart.svg',height: h*0.1,),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Text(
                       translateString('Your shopping bag is empty', 'حقيبة التسوق الخاصة بك فارغة'),
                        style: TextStyle(
                            fontSize: w * 0.035,
                            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Center(
                        child: Text(translateString('Add a new product', 'قم بإضافة منتج جديد'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: w * 0.035,
                                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                fontWeight: FontWeight.normal)),
                      ),
                      SizedBox(
                        height: h * 0.05,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        index: 0,
                                      )),
                              (route) => false);
                        },
                        child: Container(
                          width: w * 0.75,
                          height: h * 0.06,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                             translateString( LocalKeys.SHOP_NOW.tr(), 'متابعة التسوق'),
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontFamily:
                                      (lang == 'en') ? 'Nunito' : 'Almarai',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
              );
        },
        listener: (context, state) {},
      ),
    );
  }
}
