// ignore_for_file: use_key_in_widget_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DBhelper/appState.dart';
import '../../DBhelper/cubit.dart';
import '../../componnent/constants.dart';
import '../cart/cart.dart';
import 'componnent/body.dart';

class CategoriesSection extends StatefulWidget {
  final List subCategory;
  final String mainCatId;
  final String mainCat;

  const CategoriesSection(
      {Key? key, required this.subCategory, required this.mainCatId, required this.mainCat})
      : super(key: key);
  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection>
    with SingleTickerProviderStateMixin {
  int selectedSubCat = 0;
  String subCatId = "0";
  TabController? tabController;
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
    tabController =
        TabController(length: widget.subCategory.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: h*0.07,
          title: Text(
              widget.mainCat,
              style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black)
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: w * 0.01),
              child: Padding(
                padding: const EdgeInsets.all(5),
                // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
                child: BlocConsumer<DataBaseCubit, DatabaseStates>(
                  builder: (context, state) => badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: mainColor,
                    ),
                    badgeAnimation: const badges.BadgeAnimation.slide(
                      animationDuration: Duration(
                        seconds: 1,
                      ),
                    ),
                    badgeContent: (DataBaseCubit.get(context).cart.isNotEmpty)
                        ? Text(
                            DataBaseCubit.get(context).cart.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.03,
                            ),
                          )
                        : Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.03,
                            ),
                          ),
                    position: badges.BadgePosition.topStart(start: w * 0.007),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.zero,
                      focusColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Cart()));
                      },
                    ),
                  ),
                  listener: (context, state) {},
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size(w, h * 0.06),
            child: Container(
              height: h * 0.06 + 10,
              width: w,
              padding: const EdgeInsets.only(top: 10),
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                controller: tabController,
                indicatorColor: Colors.black,
                indicatorWeight: w * 0.003,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black45,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                ),
                unselectedLabelStyle: TextStyle(
                  color: Colors.black45,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                ),
                tabs: List.generate(
                  widget.subCategory.length,
                  (index) => Center(
                    child: (lang == 'en')
                        ? Text(
                            widget.subCategory[index].nameEn,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                          )
                        : Text(
                            widget.subCategory[index].nameAr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: w * 0.025),
          child: SizedBox(
              width: w,
              height: h,
              child: (widget.subCategory.isNotEmpty)
                  ? TabBarView(
                      controller: tabController,
                      children: List.generate(
                          widget.subCategory.length,
                          (index) => CategoryProducts(
                              subCatId:
                                  widget.subCategory[index].id.toString())))
                  : CategoryProducts(
                      subCatId: widget.mainCatId.toString(),
                    )),
        ),
      ),
    );
  }
}
