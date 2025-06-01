// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../model/search_history.dart';

class SearchHistory extends StatefulWidget {
  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List searchHistory = [];
  String lang = '';
  String token = '';
  late ScrollController _controller;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      // token = preferences.getString('token').toString();
    });
  }

  SearchHistoryModel? searchHistoryModel;
  void firstLoad() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFirstLoadRunning = true;
    });
    try {
      Response response = await Dio().post(EndPoints.SEARCH_HISTORY,
          queryParameters: {'page': page},
          options: Options(headers: {
            'auth-token': preferences.getString('token') ?? '',
          }));
      print(token);
      print(
          "search history : ------------------------------------------------------------");
      print(response.data);
      if (response.data['status'] == 1) {
        searchHistoryModel = SearchHistoryModel.fromJson(response.data);
        setState(() {
          searchHistory = searchHistoryModel!.texts!.data!;
        });
      }
    } catch (err) {
      print("........................................................" +
          err.toString());
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

      try {
        Response response = await Dio().post(EndPoints.SEARCH_HISTORY,
            queryParameters: {'page': page},
            options: Options(headers: {
              'auth-token': preferences.getString('token') ?? '',
            }));

        searchHistoryModel = SearchHistoryModel.fromJson(response.data);
        List fetchedPosts = [];
        if (searchHistoryModel!.texts!.data!.isNotEmpty) {
          setState(() {
            fetchedPosts = searchHistoryModel!.texts!.data!;
          });
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            searchHistory.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (err) {
        print("......................................................." +
            err.toString());
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    firstLoad();
    getLang();
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return isFirstLoadRunning
        ? Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: h * 0.55,
                child: ListView.separated(
                  controller: _controller,
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.01),
                      child: Row(
                        children: [
                          SizedBox(
                            width: w * 2.5 / 100,
                          ),
                          Text(
                            searchHistory[index].text.toString(),
                            style: TextStyle(
                                fontFamily:
                                    (lang == 'en') ? 'Nunito' : 'Alamari',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.04),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    color: Colors.grey[200],
                    thickness: h * 0.002,
                  ),
                ),
              ),
              if (isLoadMoreRunning == true)
                Padding(
                  padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                ),

              // When nothing else to load
              if (hasNextPage == false)
                Container(
                  padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                  color: Colors.white,
                ),
            ],
          );
  }
}
