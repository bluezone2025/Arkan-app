// // ignore_for_file: avoid_print
// import 'package:easy_localization/easy_localization.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:rayan_store/componnent/constants.dart';
// import 'package:rayan_store/componnent/http_services.dart';
// import 'package:rayan_store/generated/local_keys.dart';
// import 'package:rayan_store/screens/product_detail/product_detail.dart';
// import 'package:rayan_store/screens/searchScreen/model/search_model.dart';
// import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// int page = 1;
// bool hasNextPage = true;
// bool isFirstLoadRunning = false;
// bool isLoadMoreRunning = false;
// List searchData = [];

// class SearchBody extends StatefulWidget {
//   final String keyword;
//   const SearchBody({Key? key, required this.keyword}) : super(key: key);

//   @override
//   _SearchBodyState createState() => _SearchBodyState();
// }

// class _SearchBodyState extends State<SearchBody> {
//   String lang = '';
//   String token = '';
//   getLang() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       lang = preferences.getString('language').toString();
//       token = preferences.getString('token') ?? '';
//     });
//   }

//   void firstLoad() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       isFirstLoadRunning = true;
//     });
//     try {
//       Map data = {"text": widget.keyword};
//       Response response = await Dio().post(EndPoints.SEARCH,
//           queryParameters: {'page': page},
//           data: data,
//           options: Options(headers: {
//             'auth-token': preferences.getString('token') ?? '',
//           }));
//       if (response.data['status'] == 1) {
//         SearchModel searchModel = SearchModel.fromJson(response.data);
//         if (searchModel.data!.product!.data!.isNotEmpty) {
//           setState(() {
//             searchData = searchModel.data!.product!.data!;
//           });
//         }
//       }
//     } catch (err) {
//       print(err.toString());
//     }

//     setState(() {
//       isFirstLoadRunning = false;
//     });
//   }

//   void loadMore() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     if (hasNextPage == true &&
//         isFirstLoadRunning == false &&
//         isLoadMoreRunning == false &&
//         _controller.position.extentAfter < 400) {
//       setState(() {
//         isLoadMoreRunning = true;
//         page++; // Display a progress indicator at the bottom
//       });
//       // Increase _page by 1
//       try {
//         Map data = {"text": widget.keyword};
//         Response response = await Dio().post(EndPoints.SEARCH,
//             queryParameters: {'page': page},
//             data: data,
//             options: Options(headers: {
//               'auth-token': preferences.getString('token') ?? '',
//             }));

//         SearchModel searchModel = SearchModel.fromJson(response.data);
//         List fetchedPosts = [];
//         if (searchModel.data!.product!.data!.isNotEmpty) {
//           setState(() {
//             fetchedPosts = searchModel.data!.product!.data!;
//           });
//         }
//         if (fetchedPosts.isNotEmpty) {
//           setState(() {
//             searchData.addAll(fetchedPosts);
//           });
//         } else {
//           setState(() {
//             hasNextPage = false;
//           });
//         }
//       } catch (err) {
//         print(err.toString());
//       }

//       setState(() {
//         isLoadMoreRunning = false;
//       });
//     }
//   }

//   late ScrollController _controller;
//   @override
//   void initState() {
//     firstLoad();
//     getLang();
//     _controller = ScrollController()..addListener(loadMore);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     return Container(
//       child: isFirstLoadRunning
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: mainColor,
//               ),
//             )
//           : Column(
//               children: [
//                 SizedBox(
//                   height: h * 0.55,
//                   child: (searchData.isNotEmpty)
//                       ? ListView.builder(
//                           controller: _controller,
//                           itemCount: searchData.length,
//                           itemBuilder: (context, index) {
//                             return (searchData.isNotEmpty)
//                                 ? Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       InkWell(
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: h * 0.01),
//                                           child: Row(
//                                             children: [
//                                               SizedBox(
//                                                 width: w * 0.1,
//                                                 height: w * 0.1,
//                                                 child: Image.network(
//                                                   EndPoints.IMAGEURL2 +
//                                                       searchData[index].img,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: w * 2.5 / 100,
//                                               ),
//                                               (lang == 'en')
//                                                   ? Text(
//                                                       searchData[index].titleEn,
//                                                       style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: w * 0.04),
//                                                     )
//                                                   : Text(
//                                                       searchData[index].titleAr,
//                                                       style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: w * 0.04),
//                                                     ),
//                                             ],
//                                           ),
//                                         ),
//                                         onTap: () async {
//                                           HomeCubit.get(context).getProductdata(
//                                               productId: searchData[index]
//                                                   .id
//                                                   .toString());
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ProductDetail()));
//                                         },
//                                       ),
//                                       Divider(
//                                         color: Colors.grey[200],
//                                         thickness: h * 0.002,
//                                       ),
//                                     ],
//                                   )
//                                 // ignore: prefer_const_constructors
//                                 : Center(
//                                     child: const Text("no products found"),
//                                   );
//                           })
//                       : Center(
//                           child: Text(
//                             LocalKeys.NO_SEARCH.tr(),
//                             style: TextStyle(
//                                 color: mainColor,
//                                 fontFamily:
//                                     (lang == 'en') ? 'Nunito' : 'Almarai',
//                                 fontSize: w * 0.035,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                 ),
//                 if (isLoadMoreRunning == true)
//                   Padding(
//                     padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: mainColor,
//                       ),
//                     ),
//                   ),

//                 // When nothing else to load
//                 if (hasNextPage == false)
//                   Container(
//                     padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
//                     color: Colors.white,
//                   ),
//               ],
//             ),
//     );
//   }
// }
