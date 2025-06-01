// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../DBhelper/appState.dart';
import '../../../DBhelper/cubit.dart';
import '../../../app_cubit/app_cubit.dart';
import '../../../app_cubit/appstate.dart';
import '../../../componnent/constants.dart';
import '../../../generated/local_keys.dart';
import '../../cart/cart.dart';
import '../../notifications/noti.dart';

class AppBarHome {
  late int currentindex;

  static PreferredSizeWidget app_bar_home(BuildContext context,
      {required String lang,required bool login}) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      //centerTitle: true,
      elevation: 0.0,
      toolbarHeight: h * 0.05,
      title: Text(
        LocalKeys.HOME.tr().toUpperCase(),
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
            child: BlocConsumer<AppCubit, AppCubitStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: mainColor,
                  ),
                  badgeAnimation: const badges.BadgeAnimation.slide(
                    animationDuration: Duration(
                      seconds: 1,
                    ),
                  ),
                  badgeContent: Text(
                    login ? BlocProvider.of<AppCubit>(context).count == null
                        ? "0"
                        : BlocProvider.of<AppCubit>(context).count.toString() : "0",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  position: badges.BadgePosition.topStart(start: 3),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    focusColor: Colors.white,
                    onPressed: () {
                      if(login){
                        BlocProvider.of<AppCubit>(context).notifyShow();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Notifications()));
                      }else{
                        Fluttertoast.showToast(
                            msg: LocalKeys.MUST_LOGIN.tr(),
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Cart()));
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: BlocConsumer<DataBaseCubit, DatabaseStates>(
                  builder: (context, state) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: mainColor,
                          ),
                          badgeAnimation: const badges.BadgeAnimation.slide(
                            animationDuration: Duration(
                              seconds: 1,
                            ),
                          ),
                          badgeContent:
                              (DataBaseCubit.get(context).cart.isNotEmpty)
                                  ? Text(
                                      DataBaseCubit.get(context)
                                          .cart
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  : const Text(
                                      "0",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                          position: badges.BadgePosition.topStart(start: -8),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: InkWell(
                              focusColor: Colors.white,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Cart()));
                              },
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  listener: (context, state) {})),
        ),
      ],
    );
  }
}
