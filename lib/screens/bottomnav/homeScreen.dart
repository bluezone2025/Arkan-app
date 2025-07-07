// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_null_comparison, file_names

import 'package:arkan/screens/bottomnav/brands_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import '../../app_cubit/app_cubit.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../all_categories.dart';
import '../cart/cart.dart';
import '../favourite_screen/favourite_screen.dart';
import '../profile/cubit/userprofile_cubit.dart';
import '../profile/profile.dart';
import '../searchScreen/search_screen.dart';
import '../tabone_screen/cubit/home_cubit.dart';
import '../tabone_screen/tabone.dart';
import 'fabbuttom.dart';

class HomeScreen extends StatefulWidget {
  final int index;

  HomeScreen({Key? key, required this.index}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    TaboneScreen(),
    TaboneScreen(),
    const BrandsScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  gatScreen() {
    if (widget.index != null) {
      setState(() {
        currentIndex = widget.index;
      });
    } else {
      setState(() {
        currentIndex = 0;
      });
    }
  }

  @override
  void initState() {
    gatScreen();
    UserprofileCubit.get(context).getUserProfile();
    BlocProvider.of<AppCubit>(context).notifyCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
        ),
        child: Scaffold(
          //floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
          backgroundColor: const Color(0xffF6F6F6),
          // floatingActionButton: InkWell(
          //   onTap: (){
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const Cart()));
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 40.0),
          //     child: SvgPicture.asset(
          //       "assets/icons/cart_b.svg",
          //     ),
          //   ),
          // ),
          bottomNavigationBar: FABBottomAppBar(
            onTabSelected: (index) {
              index == 3 ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesScreen(
                        catItem: HomeCubit.get(context)
                            .homeitemsModel!
                            .data!
                            .categories!,
                      ))) : index == 1 ?
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Cart()))
                  :
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              FABBottomAppBarItem(
                  iconData: 'assets/icons/home.svg',
                  text: LocalKeys.HOME.tr()),
              FABBottomAppBarItem(
                  iconData: 'assets/icons/cart.svg',
                  text: LocalKeys.CART.tr()),
              // FABBottomAppBarItem(
              //     iconData: "assets/icons/Group 4.png",
              //     text: LocalKeys.HOME.tr()),
              FABBottomAppBarItem(
                  iconData: 'assets/icons/brand.svg',
                  text: translateString('Brands', 'الماركات'),),
              FABBottomAppBarItem(
                  iconData: 'assets/icons/cat.svg',
                  text: LocalKeys.CAT.tr()),
              FABBottomAppBarItem(
                  iconData: 'assets/icons/acc.svg',
                  text: LocalKeys.PROFILE.tr(),),
            ],
            backgroundColor: Colors.white,
            //centerItemText: translateString('Cart', 'عربة التسوق'),
            color: mainColor,
            selectedColor: Colors.black,
            height: 50, centerItemText: '',
          ),
          body: screens[currentIndex],
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(""),
            content: Text(LocalKeys.EXIT_TITLE.tr(),),
            actions: [
              // ignore: deprecated_member_use
              MaterialButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(LocalKeys.NO.tr(),style: const TextStyle(color: Colors.white),),
              ),
              // ignore: deprecated_member_use
              MaterialButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(LocalKeys.YES.tr(),style: const TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ) ??
        false;
  }
}
