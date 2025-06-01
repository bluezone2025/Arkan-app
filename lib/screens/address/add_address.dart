// ignore_for_file: use_key_in_widget_constructors

import 'package:arkan/app_cubit/appstate.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../app_cubit/app_cubit.dart';
import '../../componnent/constants.dart';
import '../../generated/local_keys.dart';
import '../cart/cubit/cart_cubit.dart';
import '../country/cubit/country_cubit.dart';
import '../profile/cubit/userprofile_cubit.dart';

class AddressInfo extends StatefulWidget {
  final int cartLength;

  const AddressInfo({Key? key, required this.cartLength}) : super(key: key);
  @override
  _AddressInfoState createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> with SingleTickerProviderStateMixin{
  String? areaName;
  late int areaId;
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      if (preferences.getBool('login') == true) {
        _listEd[0].text = UserprofileCubit.get(context).userModel!.name ?? '';
        _listEd[1].text = UserprofileCubit.get(context).userModel!.email ?? '';
        _listEd[2].text = UserprofileCubit.get(context).userModel!.phone ?? '';
        _listEd[5].text = prefs.getString("piece_add") ?? "";
        _listEd[6].text = prefs.getString("street_add") ?? "";
        _listEd[7].text = prefs.getString("building_add") ?? "";
        _listEd[8].text = prefs.getString("floor_add") ?? "";
        _listEd[9].text = prefs.getString("flat_add") ?? "";
        _listEd[10].text = prefs.getString("apartment_add") ?? "";
      } else {
        _listEd[0].text = prefs.getString("name_add") ?? "";
        _listEd[1].text = prefs.getString("email_add") ?? "";
        _listEd[2].text = prefs.getString("phone_add") ?? "";
        _listEd[5].text = prefs.getString("piece_add") ?? "";
        _listEd[6].text = prefs.getString("street_add") ?? "";
        _listEd[7].text = prefs.getString("building_add") ?? "";
        _listEd[8].text = prefs.getString("floor_add") ?? "";
        _listEd[9].text = prefs.getString("flat_add") ?? "";
        _listEd[10].text = prefs.getString("apartment_add") ?? "";
      }
      // _listEd[11].text = preferences.getString('user_address') ?? '';
      _listEd[7].text = prefs.getString('street') ?? "";
      _listEd[4].text = prefs.getString('region') ?? '';
    });
  }

  final List<FocusNode> _listFocus =
      List<FocusNode>.generate(12, (_) => FocusNode());
  final List<TextEditingController> _listEd =
      List<TextEditingController>.generate(12, (_) => TextEditingController());
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController phoneUser = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  TabController? tabController;
  String getText(int index) {
    return _listEd[index].text;
  }

  @override
  void initState() {
    getLang();
    //CountryCubit.get(context).getCity();
    tabController =
        TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final List<String> _hint = (lang == 'en')
        ? [
            'Name',
            'E-mail',
            'phone number',
            'Country',
            'Region',
            'The plot',
            'The Avenue',
            'Street name or number',
            'Building number',
            'Floor (optional)',
            'Apartment number (optional)',
            'Note (optional)'
          ]
        : [
            'الاسم',
            'البريد الإلكتروني',
            'رقم الهاتف',
            'الدوله',
            'المنطقه',
            'القطعة',
            'جادة',
            'اسم الشارع او الرقم',
            'رقم البناية',
            'الطابق ( اختياري)',
            'رقم الشقة ( اختياري)',
            'ملاحظات اخري ( اختياري )'
          ];
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              translateString('Address', 'العنـــوان'),
              style: TextStyle(
                  fontSize: w * 0.05,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            leading: const BackButton(
              color: Colors.black,
            ),
            centerTitle: true,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(w, h * 0.06),
              child: Container(
                height: h * 0.06,
                width: w*0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: mainColor)
                ),
                child: TabBar(
                  controller: tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Creates border
                      color: mainColor
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 0,
                  splashBorderRadius: BorderRadius.circular(20),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    SizedBox(
                      height: h * 0.08,
                      width: w*0.5,
                      child: Center(
                        child: Text(
                          translateString('Delivery to the address', 'توصيل على العنوان'),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.08,
                      width: w*0.5,
                      child: Center(
                        child: Text(
                          translateString('Delivery by phone', 'توصيل عبر الهاتف'),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Center(
            child: SizedBox(
              width: w * 0.9,
              height: h,
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Column(
                          children: [
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: _listEd[0],
                              focusNode: _listFocus[0],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  prefs.setString(
                                      "name_add", _listEd[0].text);
                                });
                              },
                              onEditingComplete: () {
                                setState(() {
                                  prefs.setString(
                                      "name_add", _listEd[0].text);
                                });
                                _listFocus[0].unfocus();

                                if (0 < _listEd.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_listFocus[0 + 1]);
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LocalKeys.VALID.tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: form(),
                                enabledBorder: form2(),
                                errorBorder: form2(),
                                focusedErrorBorder: form2(),
                                suffixIcon:Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                                hintText: _hint[0],
                                hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: _listEd[1],
                              focusNode: _listFocus[1],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  prefs.setString(
                                      "email_add", _listEd[1].text);
                                });
                              },
                              onEditingComplete: () {
                                setState(() {
                                  prefs.setString(
                                      "email_add", _listEd[1].text);
                                });
                                _listFocus[1].unfocus();

                                if (1 < _listEd.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_listFocus[1 + 1]);
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LocalKeys.VALID.tr();
                                } else{
                                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value))  {
                                    return LocalKeys.VALID_EMAIL.tr();
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: form(),
                                enabledBorder: form2(),
                                errorBorder: form2(),
                                focusedErrorBorder: form2(),
                                suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                                hintText: _hint[1],
                                hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: _listEd[2],
                              focusNode: _listFocus[2],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  prefs.setString(
                                      "phone_add", _listEd[2].text);
                                });
                              },
                              onEditingComplete: () {
                                setState(() {
                                  prefs.setString(
                                      "phone_add", _listEd[2].text);
                                });
                                _listFocus[2].unfocus();

                                if (2 < _listEd.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_listFocus[2 + 1]);
                                }
                              },
                              validator: (value) {
                                if (value!.length < 8) {
                                  return LocalKeys.VALID_PHONE.tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: form(),
                                enabledBorder: form2(),
                                errorBorder: form2(),
                                focusedErrorBorder: form2(),
                                suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                                hintText: _hint[2],
                                hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            SizedBox(
                              height: h * 0.1,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.29,
                                    child: FormField(
                                      builder: (state) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            BlocConsumer<CountryCubit,
                                                CountryState>(
                                                builder: (context, state) {
                                                  return ConditionalBuilder(
                                                      condition: state
                                                      is! GetCityLoadingState,
                                                      builder:
                                                          (context) => InkWell(
                                                            onTap: () => showModalBottomSheet(
                                                                context: context,
                                                                shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.vertical(
                                                                    top: Radius.circular(15.0),
                                                                  ),
                                                                ),
                                                                isScrollControlled: true,
                                                                constraints: BoxConstraints(
                                                                    minHeight: 0.45*h
                                                                ),
                                                                builder: (BuildContext bc){
                                                                  return SizedBox(
                                                                    height: 0.5*h,
                                                                    child: SingleChildScrollView(
                                                                      child: Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 0.04*w),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            SizedBox(height: h*0.01,),
                                                                            Center(child: Container(width: 0.15*w,height: 0.005*h,color: Colors.grey[300],)),
                                                                            SizedBox(height: h*0.01,),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: ()=> Navigator.pop(context),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                    child: Container(
                                                                                      height: h*0.05,
                                                                                      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: mainColor)),
                                                                                      child: Icon(Icons.close_rounded,color: mainColor,),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Center(child: Text(translateString('Select City', 'اختر المحافظة'),style: TextStyle(color: mainColor,fontSize: w*0.04,fontWeight: FontWeight.bold,),)),
                                                                            SizedBox(height: h*0.01,),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 0.03*w),
                                                                              child: GridView.builder(
                                                                                shrinkWrap: true,
                                                                                physics: const NeverScrollableScrollPhysics(),
                                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                    mainAxisExtent: 0.08*h,
                                                                                    crossAxisCount:2),

                                                                                itemBuilder: ( context, index) {
                                                                                  return Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 0.02*w,vertical: 0.01*h),
                                                                                    child: InkWell(
                                                                                      onTap: () async {
                                                                                        setState(() {
                                                                                          selected2 =index;
                                                                                        });
                                                                                        setState(
                                                                                                () {
                                                                                              areaName = (lang == 'en')
                                                                                                  ? CountryCubit.get(context).cityModel!.data![index].nameEn
                                                                                                  : CountryCubit.get(context).cityModel!.data![index].nameAr;
                                                                                              areaId =
                                                                                              CountryCubit.get(context).cityModel!.data![index].id!;
                                                                                            });
                                                                                        SharedPreferences
                                                                                        prefs =
                                                                                        await SharedPreferences.getInstance();
                                                                                        prefs.setString(
                                                                                            "delivery_value",
                                                                                            CountryCubit.get(context).cityModel!.data![index].delivery!);
                                                                                        prefs.setString('city_id', CountryCubit.get(context).cityModel!.data![index].id!.toString()).then((value) {
                                                                                          CartCubit.get(context).getDelivery(context: context);
                                                                                        });
                                                                                        prefs.setString('city', translateString(CountryCubit.get(context).cityModel!.data![index].nameEn.toString(), CountryCubit.get(context).cityModel!.data![index].nameAr.toString()));
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Container(
                                                                                        width: 0.42*w,
                                                                                        height: 0.07*h,
                                                                                        decoration: BoxDecoration(
                                                                                            color: const Color(0xffE9E9E9),
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            border: Border.all(color: selected2 == index ? mainColor: Colors.transparent)
                                                                                        ),
                                                                                        child: Center(child: Text(translateString(CountryCubit.get(context).cityModel!.data![index].nameEn!, CountryCubit.get(context).cityModel!.data![index].nameAr!),style: selected2 == index ? TextStyle(color: mainColor,fontSize: w*0.04,fontWeight: FontWeight.w100,) : TextStyle(color: Colors.black,fontSize: w*0.04,fontWeight: FontWeight.w100,),)),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                itemCount: CountryCubit.get(context).cityModel!.data!.length,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                            ),
                                                            child: Container(
                                                              width: w * 0.4,
                                                              height: h * 0.076,
                                                              decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey[400]!,),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                15),
                                                              ),
                                                              child: Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  w * 0.02),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                              selected2 == null ? translateString(LocalKeys
                                                                        .CITY
                                                                        .tr(), 'المحافظة') : translateString(CountryCubit.get(context).cityModel!.data![selected2!].nameEn!, CountryCubit.get(context).cityModel!.data![selected2!].nameAr!),
                                                                    style: TextStyle(
                                                                      fontFamily: (lang == 'en')
                                                                          ? 'Nunito'
                                                                          : 'Almarai',
                                                                      color:
                                                                      Colors.black45,fontSize: w * 0.04,),
                                                                  ),
                                                                  Icon(Icons.arrow_drop_down,color: mainColor,)
                                                                ],
                                                              ),
                                                            ),
                                                                                                                  ),
                                                                                                                ),
                                                          ), // your widget

                                                      fallback: (context) =>
                                                          Container());
                                                },
                                                listener: (context, state) {}),
                                            if (state.errorText != null)
                                              Text(
                                                state.errorText ?? translateString('select city', 'اختر المدينة'),
                                                style: TextStyle(
                                                  color:
                                                  Colors.red,fontSize: w*0.025
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                      validator: (val) {
                                        if (selected2 == null) {
                                          return translateString('select city', 'اختر المدينة');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:  w * 0.29,
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      controller: _listEd[4],
                                      focusNode: _listFocus[4],
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        focusedBorder: form(),
                                        enabledBorder: form2(),
                                        errorBorder: form2(),
                                        focusedErrorBorder: form2(),
                                        hintText: _hint[4],
                                        hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:  w * 0.29,
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      controller: _listEd[5],
                                      focusNode: _listFocus[5],
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (value) {
                                        setState(() {
                                          prefs.setString(
                                              "piece_add", _listEd[5].text);
                                        });
                                      },
                                      onEditingComplete: () {
                                        setState(() {
                                          prefs.setString(
                                              "piece_add", _listEd[5].text);
                                        });
                                        _listFocus[5].unfocus();

                                        if (5 < _listEd.length - 1) {
                                          FocusScope.of(context)
                                              .requestFocus(_listFocus[5 + 1]);
                                        }
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return LocalKeys.VALID.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        focusedBorder: form(),
                                        enabledBorder: form2(),
                                        errorBorder: form2(),
                                        focusedErrorBorder: form2(),
                                        suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                                        hintText: _hint[5],
                                        hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:  w * 0.44,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: _listEd[7],
                                    focusNode: _listFocus[7],
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setState(() {
                                        prefs.setString(
                                            "building_add", _listEd[7].text);
                                      });
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        prefs.setString(
                                            "building_add", _listEd[7].text);
                                      });
                                      _listFocus[7].unfocus();

                                      if (7 < _listEd.length - 1) {
                                        FocusScope.of(context)
                                            .requestFocus(_listFocus[7 + 1]);
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return LocalKeys.VALID.tr();
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: form(),
                                      enabledBorder: form2(),
                                      errorBorder: form2(),
                                      focusedErrorBorder: form2(),
                                      suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                                      hintText: _hint[7],
                                      hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:  w * 0.44,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: _listEd[6],
                                    focusNode: _listFocus[6],
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setState(() {
                                        prefs.setString(
                                            "street_add", _listEd[6].text);
                                      });
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        prefs.setString(
                                            "street_add", _listEd[6].text);
                                      });
                                      _listFocus[6].unfocus();

                                      if (6 < _listEd.length - 1) {
                                        FocusScope.of(context)
                                            .requestFocus(_listFocus[6 + 1]);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: form(),
                                      enabledBorder: form2(),
                                      errorBorder: form2(),
                                      focusedErrorBorder: form2(),
                                      suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                                      hintText: _hint[6],
                                      hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:  w * 0.44,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: _listEd[8],
                                    focusNode: _listFocus[8],
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setState(() {
                                        prefs.setString(
                                            "floor_add", _listEd[8].text);
                                      });
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        prefs.setString(
                                            "floor_add", _listEd[8].text);
                                      });
                                      _listFocus[8].unfocus();

                                      if (8 < _listEd.length - 1) {
                                        FocusScope.of(context)
                                            .requestFocus(_listFocus[8 + 1]);
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return LocalKeys.VALID.tr();
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: form(),
                                      enabledBorder: form2(),
                                      errorBorder: form2(),
                                      focusedErrorBorder: form2(),
                                      suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                                      hintText: _hint[8],
                                      hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:  w * 0.44,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: _listEd[9],
                                    focusNode: _listFocus[9],
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setState(() {
                                        prefs.setString(
                                            "flat_add", _listEd[9].text);
                                      });
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        prefs.setString(
                                            "flat_add", _listEd[9].text);
                                      });
                                      _listFocus[9].unfocus();

                                      if (9 < _listEd.length - 1) {
                                        FocusScope.of(context)
                                            .requestFocus(_listFocus[9 + 1]);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: form(),
                                      enabledBorder: form2(),
                                      errorBorder: form2(),
                                      focusedErrorBorder: form2(),
                                      hintText: _hint[9],
                                      hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            ConditionalBuilder(
                                condition: BlocProvider.of<AppCubit>(context).availableTimes != null,
                                builder:
                                    (context) => InkWell(
                                      onTap: () => showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15.0),
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          constraints: BoxConstraints(
                                              minHeight: 0.45*h
                                          ),
                                          builder: (BuildContext bc){
                                            return BlocConsumer<AppCubit, AppCubitStates>(listener: (context, state) {},
                                              builder: (context, state) {
                                              return SizedBox(
                                              height: 0.5*h,
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 0.04*w),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(height: h*0.01,),
                                                      Center(child: Container(width: 0.15*w,height: 0.005*h,color: Colors.grey[300],)),
                                                      SizedBox(height: h*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          InkWell(
                                                            onTap: ()=> Navigator.pop(context),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                              child: Container(
                                                                height: h*0.05,
                                                                decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: mainColor)),
                                                                child: Icon(Icons.close_rounded,color: mainColor,),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Center(child: Text(translateString('Appointments available', 'المواعيد المتاحة'),style: TextStyle(color: mainColor,fontSize: w*0.04,fontWeight: FontWeight.bold,),)),
                                                      SizedBox(height: h*0.01,),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 0.03*w),
                                                        child: GridView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              mainAxisExtent: 0.08*h,
                                                              crossAxisCount:2),
                                                          itemBuilder: ( context, index) {
                                                            return Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 0.02*w,vertical: 0.01*h),
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  setState(() {
                                                                    selected3 = index;
                                                                  });
                                                                  prefs.setInt('delivery_time_id', BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[index].id);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  width: 0.42*w,
                                                                  height: 0.07*h,
                                                                  decoration: BoxDecoration(
                                                                      color: const Color(0xffE9E9E9),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      border: Border.all(color: Colors.transparent)
                                                                  ),
                                                                  child: Center(child: Text('${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[index].beginTime} : ${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[index].endTime}',style: TextStyle(color: Colors.black,fontSize: w*0.04,fontWeight: FontWeight.w100,),)),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          itemCount: BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes.length,
                                                        ),
                                                      ),
                                                      SizedBox(height: h*0.01,),
                                                      Center(child: Text(BlocProvider.of<AppCubit>(context).availableTimes!.data.note.note,style: TextStyle(color: Colors.black,fontSize: w*0.035,fontWeight: FontWeight.bold,),)),
                                                      SizedBox(height: h*0.01,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );},);
                                          }
                                      ),
                                      child: Container(
                                        width: w * 0.9,
                                        height: h * 0.076,
                                        decoration:
                                        BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey[400]!,),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                w * 0.02),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  selected3 == null ? translateString('Suitable time for delivery', 'الموعد المناسب للتوصيل') : '${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[selected3!].beginTime} : ${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[selected3!].endTime}',
                                                  style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    color:
                                                    Colors.black45,fontSize: w * 0.03,),
                                                ),
                                                Icon(Icons.arrow_drop_down,color: mainColor,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),// your widget
                                fallback: (context) =>
                                    Container()),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: _listEd[11],
                              focusNode: _listFocus[11],
                              textInputAction: TextInputAction.next,
                              keyboardType:  TextInputType.text,
                              maxLines: 4,
                              decoration: InputDecoration(
                                focusedBorder: form(),
                                enabledBorder: form2(),
                                errorBorder: form2(),
                                focusedErrorBorder: form2(),
                                hintText: _hint[11],
                                hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        BlocConsumer<CartCubit, CartState>(
                          builder: (context, state) {
                            return RoundedLoadingButton(
                              controller: _btnController,
                              successColor: mainColor,
                              color: mainColor,
                              borderRadius: 15,
                              disabledColor: mainColor,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  CartCubit.get(context).saveOrder(
                                    cartLength: widget.cartLength,
                                    name: _listEd[0].text,
                                    phone: _listEd[2].text,
                                    email: _listEd[1].text,
                                    address: prefs.getString('user_address') ?? "",
                                    note: _listEd[11].text,
                                    context: context,
                                    controller: _btnController,
                                    apartmentNum: _listEd[10].text.toString(),
                                    buildingNum: _listEd[8].text.toString(),
                                    floor: _listEd[9].text.toString(),
                                    region: _listEd[4].text.toString(),
                                    streetnam: _listEd[7].text.toString(),
                                    theavenue: _listEd[6].text.toString(),
                                    theplot: _listEd[5].text.toString(),
                                    deliveredBy: 'address'
                                  );
                                } else {
                                  _btnController.error();
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));
                                  _btnController.stop();
                                }
                              },
                              child: Container(
                                height: h * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: mainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    LocalKeys.CONTINUE.tr(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily:
                                            (lang == 'en') ? 'Nunito' : 'Almarai',
                                        fontSize: w * 0.045,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                          listener: (context, state) {},
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Text(
                          translateString("Don't know the address? Add the recipient's number and we will receive it", 'لا تعرف العنوان ؟ أضف رقم المتسلم وسنحصل عليه'),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily:
                              (lang == 'en') ? 'Nunito' : 'Almarai',
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: name,
                          maxLines: 1,
                          onChanged: (value) {
                            setState(() {
                              prefs.setString(
                                  "name_add", name.text);
                            });
                          },
                          onEditingComplete: () {
                            setState(() {
                              prefs.setString(
                                  "name_add", name.text);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocalKeys.VALID.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form2(),
                            errorBorder: form2(),
                            focusedErrorBorder: form2(),
                            suffixIcon:Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                            hintText: translateString("The recipient's name", 'اسم المستلم'),
                            hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: phone,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              prefs.setString(
                                  "phone_add", phone.text);
                            });
                          },
                          onEditingComplete: () {
                            setState(() {
                              prefs.setString(
                                  "phone_add", phone.text);
                            });
                          },
                          validator: (value) {
                            if (value!.length < 8) {
                              return LocalKeys.VALID_PHONE.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form2(),
                            errorBorder: form2(),
                            focusedErrorBorder: form2(),
                            suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                            hintText: translateString("The recipient's Phone", 'رقم المستلم'),
                            hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: phoneUser,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              prefs.setString(
                                  "phone_add", phone.text);
                            });
                          },
                          onEditingComplete: () {
                            setState(() {
                              prefs.setString(
                                  "phone_add", phone.text);
                            });
                          },
                          validator: (value) {
                            if (value!.length < 8) {
                              return LocalKeys.VALID_PHONE.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form2(),
                            errorBorder: form2(),
                            focusedErrorBorder: form2(),
                            suffixIcon: Text('*',style: TextStyle(color: mainColor,fontSize: w*0.07),),
                            hintText: translateString("Your Phone Number", 'رقم هاتفك'),
                            hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        ConditionalBuilder(
                            condition: BlocProvider.of<AppCubit>(context).availableTimes != null,
                            builder:
                                (context) => InkWell(
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.0),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  constraints: BoxConstraints(
                                      minHeight: 0.45*h
                                  ),
                                  builder: (BuildContext bc){
                                    return BlocConsumer<AppCubit, AppCubitStates>(listener: (context, state) {},
                                      builder: (context, state) {
                                        return SizedBox(
                                          height: 0.5*h,
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 0.04*w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(height: h*0.01,),
                                                  Center(child: Container(width: 0.15*w,height: 0.005*h,color: Colors.grey[300],)),
                                                  SizedBox(height: h*0.01,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: ()=> Navigator.pop(context),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: Container(
                                                            height: h*0.05,
                                                            decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: mainColor)),
                                                            child: Icon(Icons.close_rounded,color: mainColor,),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Center(child: Text(translateString('Appointments available', 'المواعيد المتاحة'),style: TextStyle(color: mainColor,fontSize: w*0.04,fontWeight: FontWeight.bold,),)),
                                                  SizedBox(height: h*0.01,),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 0.03*w),
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          mainAxisExtent: 0.08*h,
                                                          crossAxisCount:2),
                                                      itemBuilder: ( context, index) {
                                                        return Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 0.02*w,vertical: 0.01*h),
                                                          child: InkWell(
                                                            onTap: () async {
                                                              FocusScope.of(context).unfocus();
                                                              setState(() {
                                                                selected3 = index;
                                                              });
                                                              prefs.setInt('delivery_time_id', BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[index].id);
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              width: 0.42*w,
                                                              height: 0.07*h,
                                                              decoration: BoxDecoration(
                                                                  color: const Color(0xffE9E9E9),
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  border: Border.all(color: Colors.transparent)
                                                              ),
                                                              child: Center(child: Text('${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[index].beginTime} : ${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[index].endTime}',style: TextStyle(color: Colors.black,fontSize: w*0.04,fontWeight: FontWeight.w100,),)),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      itemCount: BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes.length,
                                                    ),
                                                  ),
                                                  SizedBox(height: h*0.01,),
                                                  Center(child: Text(BlocProvider.of<AppCubit>(context).availableTimes!.data.note.note,style: TextStyle(color: Colors.black,fontSize: w*0.035,fontWeight: FontWeight.bold,),)),
                                                  SizedBox(height: h*0.01,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );},);
                                  }
                              ),
                              child: Container(
                                width: w * 0.9,
                                height: h * 0.076,
                                decoration:
                                BoxDecoration(
                                  border: Border.all(
                                    color: Colors
                                        .grey[400]!,),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      15),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        w * 0.02),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selected3 == null ? translateString('Suitable time for delivery', 'الموعد المناسب للتوصيل') : '${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[selected3!].beginTime} : ${BlocProvider.of<AppCubit>(context).availableTimes!.data.deliveryTimes[selected3!].endTime}',
                                          style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color:
                                            Colors.black45,fontSize: w * 0.03,),
                                        ),
                                        Icon(Icons.arrow_drop_down,color: mainColor,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),// your widget
                            fallback: (context) =>
                                Container()),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Text(
                          translateString("Select City", 'اختر المحافظة'),
                          style: TextStyle(
                              color: mainColor,
                              fontFamily:
                              (lang == 'en') ? 'Nunito' : 'Almarai',
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        SizedBox(
                          width: w * 0.95,
                          child:  GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 0.08*h,
                                crossAxisCount:2),

                            itemBuilder: ( context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.02*w,vertical: 0.01*h),
                                child: InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      selected2 =index;
                                    });
                                    setState(
                                            () {
                                          areaName = (lang == 'en')
                                              ? CountryCubit.get(context).cityModel!.data![index].nameEn
                                              : CountryCubit.get(context).cityModel!.data![index].nameAr;
                                          areaId =
                                          CountryCubit.get(context).cityModel!.data![index].id!;
                                        });
                                    SharedPreferences
                                    prefs =
                                    await SharedPreferences.getInstance();
                                    prefs.setString(
                                        "delivery_value",
                                        CountryCubit.get(context).cityModel!.data![index].delivery!);
                                    prefs
                                        .setString('city_id', CountryCubit.get(context).cityModel!.data![index].id!.toString())
                                        .then((value) {
                                      CartCubit.get(context).getDelivery(context: context);
                                    });
                                    prefs.setString('city', translateString(CountryCubit.get(context).cityModel!.data![index].nameEn.toString(), CountryCubit.get(context).cityModel!.data![index].nameAr.toString()));
                                  },
                                  child: Container(
                                    width: 0.42*w,
                                    height: 0.07*h,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE9E9E9),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: selected2 == index ? mainColor: Colors.transparent)
                                    ),
                                    child: Center(child: Text(translateString(CountryCubit.get(context).cityModel!.data![index].nameEn!, CountryCubit.get(context).cityModel!.data![index].nameAr!),style: selected2 == index ? TextStyle(color: mainColor,fontSize: w*0.04,fontWeight: FontWeight.w100,) : TextStyle(color: Colors.black,fontSize: w*0.04,fontWeight: FontWeight.w100,),)),
                                  ),
                                ),
                              );
                            },
                            itemCount: CountryCubit.get(context).cityModel!.data!.length,
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _listEd[11],
                          focusNode: _listFocus[11],
                          textInputAction: TextInputAction.next,
                          keyboardType:  TextInputType.text,
                          maxLines: 4,
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form2(),
                            errorBorder: form2(),
                            focusedErrorBorder: form2(),
                            hintText: _hint[11],
                            hintStyle: TextStyle(color: Colors.grey[400],fontSize: w * 0.03,),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        BlocConsumer<CartCubit, CartState>(
                          builder: (context, state) {
                            return RoundedLoadingButton(
                              controller: _btnController,
                              successColor: mainColor,
                              color: mainColor,
                              borderRadius: 15,
                              disabledColor: mainColor,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  CartCubit.get(context).saveOrder(
                                    cartLength: widget.cartLength,
                                    name: name.text,
                                    phone: phone.text,
                                    email: phoneUser.text,
                                    address: "",
                                    note: _listEd[11].text,
                                    context: context,
                                    controller: _btnController,
                                    apartmentNum: '',
                                    buildingNum: '',
                                    floor: '',
                                    region: '',
                                    streetnam: '',
                                    theavenue: '',
                                    theplot: '',
                                    deliveredBy: 'phone'
                                  );
                                } else {
                                  _btnController.error();
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));
                                  _btnController.stop();
                                }
                              },
                              child: Container(
                                height: h * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: mainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    LocalKeys.CONTINUE.tr(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily:
                                            (lang == 'en') ? 'Nunito' : 'Almarai',
                                        fontSize: w * 0.045,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                          listener: (context, state) {},
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: mainColor, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
  }

  InputBorder form2() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(15),
    );
  }

  int? selected2;
  int? selected3;
}
