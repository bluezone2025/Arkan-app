// ignore_for_file: use_key_in_widget_constructors, avoid_print
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers/dio_helper.dart';
import 'lang.dart';
import 'screens/auth/cubit/authcubit_cubit.dart';
import 'screens/auth/login.dart';
import 'screens/bottomnav/homeScreen.dart';
import 'screens/country/country.dart';
import 'screens/favourite_screen/cubit/favourite_cubit.dart';
import 'screens/orders/cubit/order_cubit.dart';
import 'screens/profile/cubit/userprofile_cubit.dart';
import 'screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_cubit/app_cubit.dart';
import 'componnent/constants.dart';
import 'screens/cart/cubit/cart_cubit.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'screens/country/cubit/country_cubit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget screen = LangPage();
  final Geolocator geolocator = Geolocator();
  late Position currentPosition;
  late String currentAddress;
  int ios_version = 8;
  int android_version = 1;

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {}

    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) async {
      setState(() {
        currentPosition = position;
      });
      getAddressFromLatLong(currentPosition);
      SharedPreferences pres = await SharedPreferences.getInstance();
      pres.setString('late', position.altitude.toString());
      pres.setString('lang', position.longitude.toString());
    }).catchError((e) {
      print("location errrrrrrrrrrrrrrrrrrrrrrrr : $e");
    });
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    String address = '${place.street}, ${place.subLocality},${place.country}';
    String street = "${place.street}";
    String region = "${place.administrativeArea}";

    prefs.setString('user_address', address);
    prefs.setString('street', street);
    prefs.setString('region', region);
    print("user address: " + address);
  }

  getScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLogin = prefs.getBool('login') ?? false;
    final bool selectLang = prefs.getBool('select_lang') ?? false;
    final bool countrySelected = prefs.getBool('select_country') ?? false;
    UserprofileCubit.get(context).getAllinfo();
    HomeCubit.get(context).getSetting();
    CartCubit();
    if (selectLang == true) {
      if (isLogin == true) {
        UserprofileCubit.get(context).getUserProfile();
        FavouriteCubit.get(context).getWishlist();
        OrderCubit.get(context).getAllorders();
        setState(() {
          screen = HomeScreen(index: 0);
        });
      } else if (countrySelected == true) {
        CountryCubit().getCity();
        setState(() {
          screen = HomeScreen(index: 0);
        });
      } else {
        setState(() {
          screen = Country(1);
        });
      }
    } else {
      setState(() {
        screen = LangPage();
      });
    }
  }

  @override
  void initState() {
    getScreen();
    deleteUserAccount(appversion: version);
    getCurrentLocation();
    UserprofileCubit.get(context).getAllinfo();
    BlocProvider.of<AppCubit>(context).notifyCount();
    BlocProvider.of<AppCubit>(context).getBrands();
    BlocProvider.of<AppCubit>(context).getAds1();
    BlocProvider.of<AppCubit>(context).getAds2();
    print(prefs.getString('token'));
    DioHelper.getData(url: 'settings').then((value) async {
      final response = value.data;
      print(response);
      prefs.setString('ios_url', response['data']["ios_link"] ?? '');
      prefs.setString('android_url', response['data']["android_link"] ?? '');
      prefs.setString('contact_us_phone', response['data']["phone"] ?? '');
      prefs.setString('contact_us_whatsapp', response['data']["whatsapp"] ?? '');
      prefs.setString('contact_us_facebook', response['data']["facebook"] ?? '');
      prefs.setString('contact_us_inst', response['data']["instagram"] ?? '');
      prefs.setString('contact_us_snap', response['data']["twitter"] ?? '');
      prefs.setInt('is_tabby_active', response['data']["is_tabby_active"] ?? 0);
      if(!kIsWeb) {
        if (Platform.isAndroid) {
          if (android_version < response['data']["android_version"]) {
            //todo reverse commenting blocks after finish
            return update_app(
                context: context, url: response['data']["android_link"] ?? '');
            /*  Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => OnBoarding()));*/
          } else {
            Timer(
                const Duration(seconds: 0),
                    () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) => screen)));
          }
        }

        if (Platform.isIOS) {
          if (ios_version < response['data']["ios_version"]) {
            return update_app(
                context: context, url: response['data']["ios_link"] ?? '');
          } else {
            print("ios") ;
            if (mounted) {
              Timer(
                  const Duration(seconds: 0),
                      () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) => screen)));
            }
          }
        }
      }else{
        if (mounted) {
          Timer(
              const Duration(seconds: 0),
                  () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => screen)));
        }
      }
    }).catchError((e){
      print('seetttiiinggg$e');
    });
    Timer(
        const Duration(seconds: 0),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => screen)));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? _token = await FirebaseMessaging.instance.getToken();
      if (_token != null) {
        prefs.setString('davice_token', _token);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w,
      height: h,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/icons/splash.png"), fit: BoxFit.cover),
      ),
    );
  }

  void update_app({required context,required url }){
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child:
              AlertDialog(
                elevation: 2,
                clipBehavior: Clip
                    .antiAliasWithSaveLayer,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(
                            20.0))),
                title: Center(child: Text(translateString('Update the application', "تحديث التطبيق")  ,style: TextStyle(fontWeight: FontWeight.w500,fontSize:w*0.04,color: mainColor),)),
                content: Container(child:Text(translateString('A new update is available, please update', "يتوفر اصدار جديد يرجي تحديث التطبيق")  ,style: TextStyle(fontWeight: FontWeight.w500,fontSize:w*0.04,color: mainColor),) ,),
                actions: <Widget>[
                  InkWell(
                    child: Container(
                      width: w * 0.8,
                      height: h*0.06,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius:
                        BorderRadius.circular(
                            15),),
                      child: Center(
                        child: Padding(
                          padding:
                          const EdgeInsets.all(
                              8.0),
                          child: Text(
                            translateString('to update', 'تحديث'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      if(await canLaunch(url)){
                        await launch(url);
                      }else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Transform.scale(
            scale: animation1.value,
            child: Opacity(
              opacity: animation1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Hello!!'),
                content: Text('How are you?'),
              ),
            ),
          );
        });
  }
}
