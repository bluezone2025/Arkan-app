// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../DBhelper/appState.dart';
import '../../../DBhelper/cubit.dart';
import '../../../app_cubit/app_cubit.dart';
import '../../../app_cubit/appstate.dart';
import '../../../componnent/constants.dart';
import '../../../generated/local_keys.dart';
import '../../favourite_screen/cubit/favourite_cubit.dart';
import '../../tabone_screen/cubit/home_cubit.dart';

addtoCartHeader(
    {required double w,
      required double h,
      required context,
      required String lang,
      required String currency,
      required int count}) {
  return BlocConsumer<HomeCubit, AppCubitStates>(
    listener: (context, state) {},
    builder: (context, state) => Padding(
      padding: EdgeInsets.only(top: h * 0.86),
      child: Container(
        width: w,
        height: h * 0.12,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: w * 0.01, vertical: h * 0.01),
        child: Column(
          children: [
            SizedBox(
              height: h * 0.01,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.014),
                    child: Text(
                      " ${getfinalPrice(count: count, productPrice: HomeCubit.get(context).singleProductModel!.data!.price!, currency: currency)}"
                          " " +
                          currency,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.05),
                    ),
                  ),
                  BlocConsumer<DataBaseCubit, DatabaseStates>(
                      builder: (context, state) => InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          if (HomeCubit.get(context)
                              .singleProductModel!
                              .data!
                              .sizes!
                              .isNotEmpty) {
                            if (DataBaseCubit.get(context).isexist[
                            HomeCubit.get(context)
                                .singleProductModel!
                                .data!
                                .id] ==
                                true) {
                              DataBaseCubit.get(context).deletaFromDB(
                                  id: HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .id!);
                              Fluttertoast.showToast(
                                  backgroundColor: Colors.red,
                                  gravity: ToastGravity.TOP,
                                  toastLength: Toast.LENGTH_LONG,
                                  msg: LocalKeys.REMOVE_ITEM.tr());
                            } else {
                              if (AppCubit.get(context).colorselected ==
                                  null ||
                                  AppCubit.get(context).sizeselected ==
                                      null) {
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.black,
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_LONG,
                                    msg: LocalKeys.ATTRIBUTES.tr());
                              } else if (AppCubit.get(context)
                                  .colorselected ==
                                  null) {
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.black,
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_LONG,
                                    msg: "you should select color");
                              } else {
                                DataBaseCubit.get(context).inserttoDatabase(
                                    sizeOption: int.parse(prefs
                                        .getString('sizeOption')
                                        .toString()),
                                    colorOption: int.parse(prefs
                                        .getString('colorOption')
                                        .toString()),
                                    productId: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .id!,
                                    productNameEn: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .titleEn!,
                                    productNameAr: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .titleAr!,
                                    productDescEn: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .descriptionEn!,
                                    productDescAr: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .descriptionAr!,
                                    productQty: count,
                                    productPrice: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .price,
                                    productImg: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .img!,
                                    sizeId: int.parse(prefs
                                        .getString('size_id')
                                        .toString()),
                                    colorId: int.parse(prefs
                                        .getString('color_id')
                                        .toString()));
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.black,
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_LONG,
                                    msg: LocalKeys.ADD_CAR.tr());
                              }
                            }
                          } else {
                            Fluttertoast.showToast(
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_LONG,
                                msg: LocalKeys.PRODUCT_UNAVAILABLE.tr());
                          }
                        },
                        child: Container(
                          width: w * 0.6,
                          height: h * 0.055,
                          color: Colors.black,
                          child: Center(
                            child: (DataBaseCubit.get(context).isexist[
                            HomeCubit.get(context)
                                .singleProductModel!
                                .data!
                                .id!] ==
                                true)
                                ? Text(
                              LocalKeys.REMOVE_CART.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: (lang == 'en')
                                      ? 'Nunito'
                                      : 'Almarai',
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.05),
                            )
                                : Text(
                              LocalKeys.ADD_CART.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: (lang == 'en')
                                      ? 'Nunito'
                                      : 'Almarai',
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.05),
                            ),
                          ),
                        ),
                      ),
                      listener: (context, state) {})
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//////////////////////////////////////////////////////////////////////////////////////////

sizeColorSelection(
    {required context,
      required double h,
      required double w,
      required String productId,
      required List size,
      required String lang}) {
  return BlocConsumer<HomeCubit, AppCubitStates>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              homeBottomSheet(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: h * 0.03,
                        ),
                        Text(
                          LocalKeys.SIZE.tr(),
                          style: TextStyle(
                              fontFamily:
                              (lang == 'en') ? 'Nunito' : 'Almarai',
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Container(
                          height: h*0.001,
                          width: w,
                          color: Colors.black26,
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        BlocConsumer<AppCubit, AppCubitStates>(
                            builder: (context, state) {
                              return ListView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: size.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: h * 0.02),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Radio(
                                              activeColor: mainColor,
                                              value: index,
                                              groupValue:
                                              AppCubit.get(context)
                                                  .sizeselected,
                                              onChanged: (value) async {
                                                SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                                prefs.setString(
                                                  'size_id',
                                                  size[index]
                                                      .id
                                                      .toString(),
                                                );
                                                prefs.setString(
                                                    'sizeOption',
                                                    size[index]
                                                        .pivot!
                                                        .id
                                                        .toString());
                                                AppCubit.get(context)
                                                    .sizeselected = index;
                                                AppCubit.get(context)
                                                    .sizeTitleselected =
                                                size[index].name!;
                                                AppCubit.get(context)
                                                    .sizeSelection(
                                                    selected: index,
                                                    title: size[index]
                                                        .name!);
                                                HomeCubit.get(context)
                                                    .getProductColor(
                                                  context: context,
                                                  productId: productId,
                                                  sizeId: size[index]
                                                      .id
                                                      .toString(),
                                                );
                                                Navigator.pop(context);
                                              }),
                                          Text(
                                            size[index].name!,
                                            style: TextStyle(
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontSize: w * 0.04,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            listener: (context, state) {})
                      ],
                    ),
                  ));
            },
            child: Container(
              height: h*0.07,
              width: w*0.9,
              decoration: BoxDecoration(border: Border.all(color: mainColor)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocalKeys.SIZE.tr(),
                      style: TextStyle(
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: w * 0.04,
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: Row(
                        children: [
                          BlocConsumer<AppCubit, AppCubitStates>(
                            builder: (context, state) =>
                            (AppCubit.get(context).sizeTitleselected != null)
                                ? Text(
                              AppCubit.get(context)
                                  .sizeTitleselected
                                  .toString(),
                              style: TextStyle(
                                  fontFamily: (lang == 'en')
                                      ? 'Nunito'
                                      : 'Almarai',
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            )
                                : Container(),
                            listener: (context, state) {},
                          ),
                          SizedBox(
                            width: w * 0.02,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: w * 0.08,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: h*0.02,),
          InkWell(
            onTap: () {
              (AppCubit.get(context).sizeselected != null)
                  ? homeBottomSheet(
                context: context,
                child: BlocConsumer<HomeCubit, AppCubitStates>(
                    builder: (context, state) {
                      return ConditionalBuilder(
                        condition: state
                        is! SingleProductColorLoaedingState,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: h * 0.03,
                              ),
                              Text(
                                LocalKeys.COLOR.tr(),
                                style: TextStyle(
                                    fontFamily: (lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                              Container(height: h*0.001,width: w,color: Colors.black26,),
                              SizedBox(
                                height: h * 0.02,
                              ),
                              BlocConsumer<AppCubit,
                                  AppCubitStates>(
                                  builder: (context, state) {
                                    return ListView.builder(
                                        primary: true,
                                        shrinkWrap: true,
                                        itemCount: HomeCubit.get(
                                            context)
                                            .singleProductColorModel!
                                            .data!
                                            .length,
                                        itemBuilder:
                                            (context, index) {
                                          return Padding(
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                h * 0.02),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Radio(
                                                    activeColor:
                                                    mainColor,
                                                    value: index,
                                                    groupValue: AppCubit
                                                        .get(
                                                        context)
                                                        .colorselected,
                                                    onChanged:
                                                        (value) async {
                                                      SharedPreferences
                                                      prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                      prefs.setString(
                                                          'color_id',
                                                          HomeCubit.get(
                                                              context)
                                                              .singleProductColorModel!
                                                              .data![
                                                          index]
                                                              .heightId
                                                              .toString());
                                                      prefs.setString(
                                                          'colorOption',
                                                          HomeCubit.get(
                                                              context)
                                                              .singleProductColorModel!
                                                              .data![
                                                          index]
                                                              .id
                                                              .toString());
                                                      AppCubit.get(
                                                          context)
                                                          .colorselected = index;
                                                      AppCubit.get(
                                                          context)
                                                          .colorTitleselected = HomeCubit
                                                          .get(
                                                          context)
                                                          .singleProductColorModel!
                                                          .data![
                                                      index]
                                                          .name!;
                                                      AppCubit.get(context).colorSelection(
                                                          selected:
                                                          index,
                                                          title: HomeCubit.get(
                                                              context)
                                                              .singleProductColorModel!
                                                              .data![
                                                          index]
                                                              .name!);
                                                      Navigator.pop(
                                                          context);
                                                    }),
                                                Text(
                                                  HomeCubit.get(
                                                      context)
                                                      .singleProductColorModel!
                                                      .data![index]
                                                      .name!,
                                                  style: TextStyle(
                                                      fontFamily: (lang ==
                                                          'en')
                                                          ? 'Nunito'
                                                          : 'Alamarai',
                                                      fontSize:
                                                      w * 0.04,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: Colors
                                                          .grey),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  listener: (context, state) {})
                            ],
                          ),
                        ),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ),
                      );
                    },
                    listener: (context, state) {}),
              )
                  : Fluttertoast.showToast(
                  msg: LocalKeys.COLOR_ERROR.tr(),
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_LONG);
            },
            child: Container(
              height: h*0.07,
              width: w*0.9,
              decoration: BoxDecoration(border: Border.all(color: mainColor)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocalKeys.COLOR.tr(),
                      style: TextStyle(
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: w * 0.04,
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          BlocConsumer<AppCubit, AppCubitStates>(
                              builder: (context, state) =>
                              (AppCubit.get(context).colorTitleselected !=
                                  null)
                                  ? Text(
                                AppCubit.get(context)
                                    .colorTitleselected
                                    .toString(),
                                style: TextStyle(
                                    fontFamily: (lang == 'en')
                                        ? 'Nunito'
                                        : 'Almarai',
                                    fontSize: w * 0.04,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              )
                                  : Container(),
                              listener: (context, state) {}),
                          SizedBox(
                            width: w * 0.02,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: w * 0.08,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      listener: (context, state) {});
}

///////////////////////////////////////////////////////////////////////////////////////////////
bool click = false;

favouriteButton(
    {required context, required bool login, required String productId}) {
  return BlocConsumer<FavouriteCubit, FavouriteState>(
    builder: (context, state) {
      return InkWell(
        onTap: () async {
          if (!click) {
            click = true;
            if (login) {
              FavouriteCubit.get(context).addtowishlist(productId: productId);
            } else {
              Fluttertoast.showToast(
                  msg: LocalKeys.MUST_LOGIN.tr(),
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_LONG);
            }
            await Future.delayed(
                const Duration(milliseconds: 2500));
            click = false;
          }
        },
        child: (FavouriteCubit.get(context).isFavourite[int.parse(productId)] ==
            true)
            ? Icon(
          Icons.favorite,
          color: Colors.red[700],
          size: 30,
        )
            : Icon(
          Icons.favorite_outline,
          color: Colors.black,
          size: 30,
        ),
      );
    },
    listener: (context, state) {},
  );
}
///////////////////////////////////////////////////////////////

