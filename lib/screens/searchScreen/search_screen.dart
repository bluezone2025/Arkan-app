// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DBhelper/cubit.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../cart/cart.dart';
import '../product_detail/product_detail.dart';
import '../tabone_screen/cubit/home_cubit.dart';
import 'componnent/category.dart';
import 'componnent/search_history.dart';
import 'model/search_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String lang = '';
  bool isSearching = false;
  bool login = false;
  late String search;

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List searchData = [];
  late ScrollController _controller;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      login = preferences.getBool('login') ?? false;
    });
  }

  void firstLoad({required String keyword}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFirstLoadRunning = true;
    });
    try {
      Map data = {"text": keyword};
      Response response = await Dio().post(EndPoints.SEARCH,
          queryParameters: {'page': page},
          data: data,
          options: Options(headers: {
            'auth-token': preferences.getString('token') ?? '',
          }));
      if (response.data['status'] == 1) {
        SearchModel searchModel = SearchModel.fromJson(response.data);
        if (searchModel.data!.product!.data!.isNotEmpty) {
          setState(() {
            searchData = searchModel.data!.product!.data!;
          });
        }
      }
    } catch (err) {
      print(err.toString());
    }

    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        _controller.position.extentAfter < 400) {
      setState(() {
        isLoadMoreRunning = true;
        page++; // Display a progress indicator at the bottom
      });
      // Increase _page by 1
      try {
        Map data = {"text": search};
        Response response = await Dio().post(EndPoints.SEARCH,
            queryParameters: {'page': page},
            data: data,
            options: Options(headers: {
              'auth-token': preferences.getString('token') ?? '',
            }));

        SearchModel searchModel = SearchModel.fromJson(response.data);
        List fetchedPosts = [];
        if (searchModel.data!.product!.data!.isNotEmpty) {
          setState(() {
            fetchedPosts = searchModel.data!.product!.data!;
          });
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            searchData.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (err) {
        print(err.toString());
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    firstLoad(keyword: '');
    getLang();
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: h*0.06,
          title: Text(
            LocalKeys.SEARCH.tr(),
            style: TextStyle(
              color: Colors.black,
              fontSize: w * 0.05,fontWeight: FontWeight.bold,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: badges.Badge(
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        )
                      : const Text(
                          "0",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                  position: badges.BadgePosition.topStart(start: 6),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                      size: 25,
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
              ),
            ),
            SizedBox(
              width: w * 0.05,
            ),
          ],
        ),
        body: ListView(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.03),
          primary: true,
          shrinkWrap: true,
          children: [
            TextFormField(
              cursorColor: Colors.black,
              textInputAction: TextInputAction.search,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  isSearching = true;
                });
                if (search.isEmpty) {
                  setState(() {
                    isSearching = false;
                  });
                }
              },
              decoration: InputDecoration(
                focusedBorder: form(),
                enabledBorder: form(),
                errorBorder: form(),
                focusedErrorBorder: form(),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: LocalKeys.SEARCH2.tr(),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                ),
              ),
              onChanged: (val) {
                firstLoad(keyword: val);
                setState(() {
                  isSearching = true;
                  search = val;
                });
                if (search.isEmpty) {
                  setState(() {
                    isSearching = false;
                  });
                }
              },
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: h * 0.03,
            ),
            if (isSearching)
              Container(
                child: isFirstLoadRunning
                    ? Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: h * 0.55,
                            child: (searchData.isNotEmpty)
                                ? ListView.builder(
                                    controller: _controller,
                                    itemCount: searchData.length,
                                    itemBuilder: (context, index) {
                                      return (searchData.isNotEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: h * 0.01),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: w * 0.1,
                                                          height: w * 0.1,
                                                          child: Image.network(
                                                            EndPoints
                                                                    .IMAGEURL2 +
                                                                searchData[
                                                                        index]
                                                                    .img,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: w * 2.5 / 100,
                                                        ),
                                                        (lang == 'en')
                                                            ? Text(
                                                                searchData[
                                                                        index]
                                                                    .titleEn,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: w *
                                                                        0.04),
                                                              )
                                                            : Text(
                                                                searchData[
                                                                        index]
                                                                    .titleAr,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: w *
                                                                        0.04),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    HomeCubit.get(context)
                                                        .getProductdata(
                                                            productId:
                                                                searchData[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetail()));
                                                  },
                                                ),
                                                Divider(
                                                  color: Colors.grey[200],
                                                  thickness: h * 0.002,
                                                ),
                                              ],
                                            )
                                          // ignore: prefer_const_constructors
                                          : Center(
                                              child: const Text(
                                                  "no products found"),
                                            );
                                    })
                                : Center(
                                    child: Text(
                                      LocalKeys.NO_SEARCH.tr(),
                                      style: TextStyle(
                                          color: mainColor,
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ),
                          if (isLoadMoreRunning == true)
                            Padding(
                              padding: EdgeInsets.only(
                                  top: h * 0.01, bottom: h * 0.01),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              ),
                            ),

                          // When nothing else to load
                          if (hasNextPage == false)
                            Container(
                              padding: EdgeInsets.only(
                                  top: h * 0.01, bottom: h * 0.01),
                              color: Colors.white,
                            ),
                        ],
                      ),
              ),
            if (login && !isSearching) SearchHistory(),
            if (!login && !isSearching) const SearchCatergory(),
          ],
        ),
      ),
    );
  }

  InputBorder form() {
    double w = MediaQuery.of(context).size.width;
    return OutlineInputBorder(
      borderSide: const BorderSide(color: (Colors.white), width: 1),
      borderRadius: BorderRadius.circular(w * 0.01),
    );
  }
}
