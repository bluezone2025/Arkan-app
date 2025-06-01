// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import '../../DBhelper/appState.dart';
import '../../DBhelper/cubit.dart';
import '../../app_cubit/app_cubit.dart';
import '../../app_cubit/appstate.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../../mock.dart';
import '../cart/cart.dart';
import '../cart/cubit/cart_cubit.dart';
import '../tabone_screen/cubit/home_cubit.dart';
import 'componnent/add_to_cart.dart';
import 'componnent/full_slider.dart';
import 'componnent/similar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String lang = '';
  int count = 1;
  int count2 = 1;
  String currency = '';
  bool login = false;
  bool click = false;
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;
  bool flag = true;
  List<String> number = [
    '1',
    '2',
    '3',
    '4',
  ];
  String? selectedNum;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      login = preferences.getBool('login') ?? false;
    });
  }

  size() {
    count = 1;
    AppCubit.get(context).sizeselected = null;
    AppCubit.get(context).sizeSelection(selected: null, title: null);
    AppCubit.get(context).colorselected = null;
    AppCubit.get(context).colorSelection(selected: null, title: null);
  }

  @override
  void initState() {
    getLang();
    size();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final config = CalendarDatePicker2Config(
      disableMonthPicker: true,
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.indigo,
    );
    return BlocConsumer<HomeCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: ConditionalBuilder(
                condition: state is! SingleProductLoaedingState,
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                if(HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .images!.isEmpty)
                                  InkWell(
                                    focusColor:
                                    Colors.transparent,
                                    splashColor:
                                    Colors.transparent,
                                    highlightColor:
                                    Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullSliderScreen(
                                                  image: HomeCubit
                                                      .get(
                                                      context)
                                                      .singleProductModel!
                                                      .data!
                                                      .images!,
                                                  login: login,
                                                  productId: HomeCubit
                                                      .get(
                                                      context)
                                                      .singleProductModel!
                                                      .data!
                                                      .id
                                                      .toString(),
                                                  productImage: HomeCubit
                                                      .get(
                                                      context)
                                                      .singleProductModel!
                                                      .data!
                                                      .img!)));
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      height: 0.5*h,
                                      child: customCachedNetworkImage(
                                        url: EndPoints.IMAGEURL2 +
                                            HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .img!,
                                        fit: BoxFit.cover,
                                        context: context,
                                      ),
                                    ),
                                  ),
                                if(HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .images!.isNotEmpty)
                                CarouselSlider.builder(
                                    carouselController: _controller,
                                    itemCount: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .images!.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return InkWell(
                                        focusColor:
                                        Colors.transparent,
                                        splashColor:
                                        Colors.transparent,
                                        highlightColor:
                                        Colors.transparent,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => FullSliderScreen(
                                                      login: login,
                                                      productId: HomeCubit
                                                          .get(
                                                          context)
                                                          .singleProductModel!
                                                          .data!
                                                          .id
                                                          .toString(),
                                                      image: HomeCubit
                                                          .get(
                                                          context)
                                                          .singleProductModel!
                                                          .data!
                                                          .images!)));
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          child:
                                          customCachedNetworkImage(
                                            url: EndPoints.IMAGEURL +
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .images![index]
                                                    .img!,
                                            fit: BoxFit.cover,
                                            context: context,
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        autoPlay: true,
                                        autoPlayAnimationDuration: const Duration(seconds: 1),
                                        autoPlayCurve: Curves.easeIn,

                                        //   enlargeCenterPage: true,

                                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                                        initialPage: 0,

                                        //  pageSnapping: false,

                                        viewportFraction: 1,
                                        height: 0.5*h,
                                        autoPlayInterval: const Duration(seconds: 5)
                                    )),
                                Positioned(
                                  top: h*0.05,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: SizedBox(
                                      width: w,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: h * 0.06,
                                              width: w*0.2,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle
                                              ),
                                              child: const Center(child: Icon(Icons.arrow_back)),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: h * 0.06,
                                                width: w*0.2,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle
                                                ),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (!click) {
                                                      setState(() {
                                                        click = true;
                                                      });
                                                      Share.share(
                                                          "https://arkan-q8.com/$lang/product/${HomeCubit.get(context).singleProductModel!.data!.id!}",
                                                          subject: "");
                                                      await Future.delayed(
                                                          const Duration(milliseconds: 2500));
                                                      setState(() {
                                                        click = false;
                                                      });
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.share,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.01,
                                              ),
                                              Container(
                                                height: h * 0.06,
                                                width: w*0.2,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle
                                                ),
                                                child: favouriteButton(
                                                    context: context,
                                                    login: login,
                                                    productId:
                                                    HomeCubit.get(context)
                                                        .singleProductModel!
                                                        .data!
                                                        .id
                                                        .toString()),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Center(
                              child: DotsIndicator(
                                dotsCount: (HomeCubit.get(context)
                                    .singleProductModel!
                                    .data!
                                    .images!.isNotEmpty) ? HomeCubit.get(context)
                                    .singleProductModel!
                                    .data!
                                    .images!.length : 1,
                                position: _current.toDouble(),
                                mainAxisSize: MainAxisSize.min,
                                decorator: DotsDecorator(
                                  color: Colors.grey, // Inactive color
                                  activeColor: mainColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: h * 0.01, horizontal: w * 0.04),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          //vertical: h * 0.01,
                                            horizontal: w * 0.01),
                                        child: Text(
                                          (lang == 'en')
                                              ? HomeCubit.get(context)
                                              .singleProductModel!
                                              .data!
                                              .titleEn! :HomeCubit.get(context)
                                              .singleProductModel!
                                              .data!
                                              .titleAr!,
                                          style: TextStyle(
                                              fontFamily:
                                              (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontSize: w * 0.055,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getProductprice(
                                                  currency: currency,
                                                  productPrice:
                                                  HomeCubit.get(context)
                                                      .singleProductModel!
                                                      .data!
                                                      .price!),
                                              style: TextStyle(
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: w * 0.05,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: w * 0.05,
                                            ),
                                            (HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .hasOffer ==
                                                1)
                                                ? Text(
                                              getProductprice(
                                                  currency: currency,
                                                  productPrice: HomeCubit
                                                      .get(context)
                                                      .singleProductModel!
                                                      .data!
                                                      .beforePrice),
                                              style: TextStyle(
                                                fontSize: w * 0.04,
                                                decoration:
                                                TextDecoration
                                                    .lineThrough,
                                                decorationColor:
                                                mainColor,
                                                color: mainColor,
                                                fontFamily:
                                                (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                              ),
                                            )
                                                : Container(),
                                          ]
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if(HomeCubit.get(context)
                                              .singleProductModel!
                                              .data!
                                              .brandEn != null)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: h * 0.015),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: '${translateString('Brand', 'ماركة')} : ',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: mainColor,
                                                            fontSize: w * 0.035)),
                                                    TextSpan(
                                                        text:
                                                        translateString(HomeCubit.get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .brandEn!, HomeCubit.get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .brandAr!),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: mainColor,
                                                            fontSize: w * 0.035)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          (HomeCubit.get(context)
                                              .singleProductModel!
                                              .data!
                                              .quantity! == 0)
                                              ? Text(
                                            LocalKeys.PRODUCT_UNAVAILABLE.tr(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontSize: w * 0.035,
                                                fontWeight: FontWeight.w100,
                                                color: mainColor),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      if(HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!.hasReception == 1)
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: ()=> _buildMultiDatePickerWithValue(),
                                            child: Container(
                                              height: 0.07*h,
                                              width: 0.95*w,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: mainColor)
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 0.04*w),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      constraints: BoxConstraints(
                                                          maxHeight: h * 0.07, maxWidth: w * 0.75),
                                                      child: Text(_getValueText(config.calendarType, _multiDatePickerValueWithDefaultValue,) == 'null' ? translateString('Select Reservation Days', 'اختر ايام الحجز') : _getValueText(
                                                        config.calendarType,
                                                        _multiDatePickerValueWithDefaultValue,
                                                      ),style: TextStyle(
                                                          fontFamily: (lang == 'en')
                                                              ? 'Nunito'
                                                              : 'Almarai',
                                                          fontSize: w * 0.035,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black),maxLines: 1,overflow: TextOverflow.fade,),
                                                    ),
                                                    Icon(Icons.calendar_month,color: mainColor,)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: h * 0.02,
                                          ),
                                          if(_getValueText(
                                            config.calendarType,
                                            _multiDatePickerValueWithDefaultValue,
                                          ) != 'null')
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(translateString('Select Number', 'اختر عدد الدزات'),style: TextStyle(
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  fontSize: w * 0.04,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black),),
                                              Container(
                                                width: w * 0.3,
                                                height: h * 0.045,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.015),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(color: mainColor)
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    BlocConsumer<CartCubit,
                                                        CartState>(
                                                        builder:
                                                            (context, state) {
                                                          return SizedBox(
                                                            width: 40,
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if(count2 < HomeCubit.get(context).checkQuantityModel!.quantity){
                                                                  setState(() {
                                                                    count2++;
                                                                  });
                                                                }
                                                              },
                                                              child:
                                                              const Icon(Icons.add),
                                                            ),
                                                          );
                                                        }, listener:
                                                        (context, state) {}),
                                                    Text(
                                                      HomeCubit.get(context).checkQuantityModel!.quantity != 0 ? count2.toString() : HomeCubit.get(context).checkQuantityModel!.quantity.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                          (lang == 'en')
                                                              ? 'Nunito'
                                                              : 'Almarai',
                                                          fontSize: w * 0.04,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                      child: InkWell(
                                                          onTap: () async {
                                                            if(count2 > 1){
                                                              setState(() {
                                                                count2--;
                                                              });
                                                            }
                                                          },
                                                          child: const Icon(
                                                              Icons.remove)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: h * 0.02,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: w*0.1),
                                        child: Divider(
                                          color: Colors.grey[350],
                                          height: 3,
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      Text(
                                        translateString('description', 'الوصــف'),
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.045,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: mainColor),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.025),
                                        child: Column(
                                          children: [
                                            Text(
                                              parseHtmlString(translateString(
                                                  HomeCubit.get(context)
                                                      .singleProductModel!
                                                      .data!
                                                      .descriptionEn!,
                                                  HomeCubit.get(context)
                                                      .singleProductModel!
                                                      .data!
                                                      .descriptionAr!)),
                                              maxLines: flag ? 3 : 15,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  height: 2,
                                                  fontSize: w * 0.033),
                                            ),
                                            if('\n'.allMatches(translateString(
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionEn!,
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionAr!)).length > 3 || ' '.allMatches(parseHtmlString(translateString(
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionEn!,
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionAr!))).length > 50)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        flag = !flag;
                                                      });
                                                    },
                                                    child:  Container(
                                                      padding: const EdgeInsets.only(
                                                        bottom: 5, // Space between underline and text
                                                      ),
                                                      decoration: BoxDecoration(
                                                          border: Border(bottom: BorderSide(
                                                            color: mainColor,
                                                            width: 1.0, // Underline thickness
                                                          ))
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            translateString('more', 'المزيد'),
                                                            style: TextStyle(
                                                                color: mainColor,
                                                                fontSize: w * 0.03),
                                                          ),
                                                          Icon(Icons.arrow_drop_down_sharp,color: mainColor,)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: w*0.1),
                                        child: Divider(
                                          color: Colors.grey[350],
                                          height: 3,
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  (HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .sizes!
                                      .isNotEmpty)
                                      ? sizeColorSelection(
                                      context: context,
                                      w: w,
                                      h: h,
                                      lang: lang,
                                      size: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .sizes!,
                                      productId: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .id
                                          .toString())
                                      : Container(),
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  if(HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .sizes!
                                      .isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: w*0.1),
                                    child: Divider(
                                      color: Colors.grey[350],
                                      height: 3,
                                    ),
                                  ),
                                  if(HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .sizes!
                                      .isNotEmpty)
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  if(currency != 'OMR')
                                    TabbyPresentationSnippet(
                                      price: getProductPriceTabby(currency: currency, productPrice: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .price!),
                                      currency: currency == 'BHD' ? Currency.bhd : currency == 'QAR' ? Currency.qar : currency == 'AED' ? Currency.aed : currency == 'SAR' ? Currency.sar : Currency.kwd,
                                      lang: lang == 'en' ? Lang.en :Lang.ar,
                                    ),
                                  if(prefs.getInt('is_tabby_active') == 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Align(
                                        alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                                        child: Text(
                                          translateString('7% tax will be added', 'سيتم اضافة 7% ضريبة'),
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                          ),
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  (HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .relatedProducts!
                                      .isNotEmpty)
                                      ? SimilarProduct(
                                    similar: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .relatedProducts!,
                                  )
                                      : Container(),
                                  SizedBox(
                                    height: h * 0.1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocConsumer<DataBaseCubit, DatabaseStates>(
                        builder: (context, state) => InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                            await SharedPreferences
                                .getInstance();
                              if(HomeCubit.get(context)
                                  .singleProductModel!
                                  .data!.hasReception == 1){
                                if (HomeCubit.get(context).checkQuantityModel!.quantity != 0){
                                  if(count2 != 0 && _getValueText(
                                    config.calendarType,
                                    _multiDatePickerValueWithDefaultValue,
                                  ) != 'null'){
                                    if (DataBaseCubit.get(context)
                                        .isexist[HomeCubit
                                        .get(context)
                                        .singleProductModel!
                                        .data!
                                        .id] ==
                                        true) {
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => const Cart()));
                                    } else {
                                      if ((AppCubit.get(context)
                                          .colorselected ==
                                          null ||
                                          AppCubit.get(context)
                                              .sizeselected ==
                                              null) && HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .sizes!
                                          .isNotEmpty) {
                                        Fluttertoast.showToast(
                                            backgroundColor:
                                            Colors.black,
                                            gravity:
                                            ToastGravity.TOP,
                                            toastLength:
                                            Toast.LENGTH_LONG,
                                            msg: LocalKeys
                                                .ATTRIBUTES
                                                .tr());
                                      } else if (AppCubit.get(
                                          context)
                                          .colorselected ==
                                          null && HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .sizes!
                                          .isNotEmpty) {
                                        Fluttertoast.showToast(
                                            backgroundColor:
                                            Colors.black,
                                            gravity:
                                            ToastGravity.TOP,
                                            toastLength:
                                            Toast.LENGTH_LONG,
                                            msg:
                                            "you should select color");
                                      } else {
                                        DataBaseCubit.get(context).inserttoDatabase(
                                            sizeOption: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .sizes!
                                                .isNotEmpty ? int.parse(prefs
                                                .getString(
                                                'sizeOption')
                                                .toString()) : 0,
                                            colorOption: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .sizes!
                                                .isNotEmpty ? int.parse(prefs
                                                .getString(
                                                'colorOption')
                                                .toString()) : 0,
                                            productId: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .id!,
                                            productNameEn: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .titleEn!,
                                            productNameAr:
                                            HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .titleAr!,
                                            productDescEn: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!.hasReception == 1 ? _getValueText(
                                              config.calendarType,
                                              _multiDatePickerValueWithDefaultValue,
                                            ) : HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .descriptionEn!,
                                            productDescAr: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!.hasReception == 1 ? 'daza': HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .descriptionAr!,
                                            productQty: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!.hasReception == 1 ? count2*_getValueText(
                                              config.calendarType,
                                              _multiDatePickerValueWithDefaultValue,
                                            ).split(',').length : count2,
                                            productPrice: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .price,
                                            productImg: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .img!,
                                            sizeId: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .sizes!
                                                .isNotEmpty ? int.parse(prefs.getString('size_id').toString()) : 0,
                                            colorId: HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .sizes!
                                                .isNotEmpty ? int.parse(prefs.getString('color_id').toString()): 0);
                                        Fluttertoast.showToast(
                                            backgroundColor:
                                            Colors.black,
                                            gravity:
                                            ToastGravity.TOP,
                                            toastLength:
                                            Toast.LENGTH_LONG,
                                            msg: LocalKeys.ADD_CAR
                                                .tr());
                                      }
                                    }
                                  }else{
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                        Colors.red,
                                        gravity: ToastGravity.TOP,
                                        toastLength:
                                        Toast.LENGTH_LONG,
                                        msg: translateString('select days first ', 'اختر الايام اولا'));
                                  }
                                }else{
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                      Colors.red,
                                      gravity: ToastGravity.TOP,
                                      toastLength:
                                      Toast.LENGTH_LONG,
                                      msg: LocalKeys
                                          .PRODUCT_UNAVAILABLE
                                          .tr());
                                }
                              }else{
                                if (DataBaseCubit.get(context)
                                    .isexist[HomeCubit
                                    .get(context)
                                    .singleProductModel!
                                    .data!
                                    .id] ==
                                    true) {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const Cart()));
                                } else {
                                  if ((AppCubit.get(context)
                                      .colorselected ==
                                      null ||
                                      AppCubit.get(context)
                                          .sizeselected ==
                                          null) && HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .sizes!
                                      .isNotEmpty) {
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                        Colors.black,
                                        gravity:
                                        ToastGravity.TOP,
                                        toastLength:
                                        Toast.LENGTH_LONG,
                                        msg: LocalKeys
                                            .ATTRIBUTES
                                            .tr());
                                  } else if (AppCubit.get(
                                      context)
                                      .colorselected ==
                                      null && HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .sizes!
                                      .isNotEmpty) {
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                        Colors.black,
                                        gravity:
                                        ToastGravity.TOP,
                                        toastLength:
                                        Toast.LENGTH_LONG,
                                        msg:
                                        "you should select color");
                                  } else {
                                    DataBaseCubit.get(context).inserttoDatabase(
                                        sizeOption: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!.hasReception == 1 ? count2 : HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .sizes!
                                            .isNotEmpty ? int.parse(prefs
                                            .getString(
                                            'sizeOption')
                                            .toString()) : 0,
                                        colorOption: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .sizes!
                                            .isNotEmpty ? int.parse(prefs
                                            .getString(
                                            'colorOption')
                                            .toString()) : 0,
                                        productId: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .id!,
                                        productNameEn: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .titleEn!,
                                        productNameAr:
                                        HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .titleAr!,
                                        productDescEn: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!.hasReception == 1 ? _getValueText(
                                          config.calendarType,
                                          _multiDatePickerValueWithDefaultValue,
                                        ) : HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .descriptionEn!,
                                        productDescAr: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!.hasReception == 1 ? 'daza': HomeCubit.get(context)
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
                                        sizeId: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .sizes!
                                            .isNotEmpty ? int.parse(prefs.getString('size_id').toString()) : 0,
                                        colorId: HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .sizes!
                                            .isNotEmpty ? int.parse(prefs.getString('color_id').toString()): 0);
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                        Colors.black,
                                        gravity:
                                        ToastGravity.TOP,
                                        toastLength:
                                        Toast.LENGTH_LONG,
                                        msg: LocalKeys.ADD_CAR
                                            .tr());
                                  }
                                }
                              }
                          },
                          child: Container(
                            width: w,
                            height: h * 0.1,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(h*0.015),
                              child: Container(
                                width: w*0.9,
                                height: h * 0.05,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: HomeCubit.get(context)
                                    .singleProductModel!
                                    .data!.hasReception  == 0 ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    BlocConsumer<DataBaseCubit,
                                        DatabaseStates>(
                                        builder: (context, state) {
                                          return Container(
                                            width: w * 0.3,
                                            height: h * 0.045,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: w * 0.015),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(7)
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                BlocConsumer<CartCubit,
                                                    CartState>(
                                                    builder:
                                                        (context, state) {
                                                      return SizedBox(
                                                        width: 40,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                            if (AppCubit.get(
                                                                context)
                                                                .sizeselected !=
                                                                null &&
                                                                AppCubit.get(
                                                                    context)
                                                                    .colorselected !=
                                                                    null) {
                                                              CartCubit.get(context).checkProductQty(
                                                                  context:
                                                                  context,
                                                                  productId: HomeCubit
                                                                      .get(
                                                                      context)
                                                                      .singleProductModel!
                                                                      .data!
                                                                      .id
                                                                      .toString(),
                                                                  productQty: count
                                                                      .toString(),
                                                                  sizeId: prefs
                                                                      .getString(
                                                                      'size_id')
                                                                      .toString(),
                                                                  colorId: prefs
                                                                      .getString(
                                                                      'color_id')
                                                                      .toString());
                                                            } else if (HomeCubit.get(context)
                                                                .singleProductModel!
                                                                .data!
                                                                .sizes!
                                                                .isEmpty && HomeCubit.get(context)
                                                                .singleProductModel!
                                                                .data!
                                                                .quantity != 0 ){
                                                              CartCubit.get(context).checkProductQty(
                                                                  context:
                                                                  context,
                                                                  productId: HomeCubit
                                                                      .get(
                                                                      context)
                                                                      .singleProductModel!
                                                                      .data!
                                                                      .id
                                                                      .toString(),
                                                                  productQty: count
                                                                      .toString(),
                                                                  sizeId: '0',
                                                                  colorId: '0');
                                                          }else {
                                                              Fluttertoast.showToast(
                                                                  textColor:
                                                                  Colors
                                                                      .white,
                                                                  backgroundColor:
                                                                  Colors
                                                                      .red,
                                                                  gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  msg: LocalKeys
                                                                      .ATTRIBUTES
                                                                      .tr());
                                                            }
                                                          },
                                                          child:
                                                          Icon(Icons.add),
                                                        ),
                                                      );
                                                    }, listener:
                                                    (context, state) {
                                                  if (state
                                                  is CheckProductAddcartSuccessState &&
                                                      count <
                                                          CartCubit.get(
                                                              context)
                                                              .totalQuantity) {
                                                    setState(() {
                                                      count++;
                                                      print(count);
                                                    });
                                                  } else if (state
                                                  is CheckProductAddcartErroState) {
                                                    setState(() {
                                                      count = count;
                                                    });
                                                  }
                                                }),
                                                Text(
                                                  count.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                      (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                  child: InkWell(
                                                      onTap: () async {
                                                        if (count == 1) {
                                                          setState(() {
                                                            count = 1;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            count--;
                                                          });
                                                        }
                                                      },
                                                      child: const Icon(
                                                          Icons.remove)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        listener: (context, state) {}),
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/icons/cart.svg'),
                                        Center(
                                          child: (DataBaseCubit.get(
                                              context)
                                              .isexist[HomeCubit
                                              .get(context)
                                              .singleProductModel!
                                              .data!
                                              .id!] ==
                                              true)
                                              ? Text(
                                            translateString('Show cart', 'مشاهدة السلة'),
                                            style: TextStyle(
                                                color:
                                                Colors.white,
                                                fontFamily:
                                                (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                fontSize:
                                                w * 0.045),
                                          )
                                              : Text(
                                            translateString(LocalKeys.ADD_CART
                                                .tr(), 'اضف للسلة'),
                                            style: TextStyle(
                                                color:
                                                Colors.white,
                                                fontFamily:
                                                (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                fontSize:
                                                w * 0.05),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ) : Center(
                                  child: (DataBaseCubit.get(
                                      context)
                                      .isexist[HomeCubit
                                      .get(context)
                                      .singleProductModel!
                                      .data!
                                      .id!] ==
                                      true)
                                      ? Text(
                                    translateString('Show cart', 'مشاهدة السلة'),
                                    style: TextStyle(
                                        color:
                                        Colors.white,
                                        fontFamily:
                                        (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        fontSize:
                                        w * 0.045),
                                  ) : Text(
                                    translateString('Book Now', 'احجز الان'),
                                    style: TextStyle(
                                        color:
                                        Colors.white,
                                        fontFamily:
                                        (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        fontSize:
                                        w * 0.06),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        listener: (context, state) {}),
                  ],
                ),
                fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    )));
      },
    );
  }

  List<DateTime?> _multiDatePickerValueWithDefaultValue = [
  ];

  final today = DateUtils.dateOnly(DateTime.now());

  void _buildMultiDatePickerWithValue() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final config = CalendarDatePicker2Config(
      disableMonthPicker: true,
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.indigo,
        firstDate: DateTime(today.year, today.month, today.day + 1),
    );
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        constraints: BoxConstraints(
          minHeight: 0.65*h
        ),
        builder: (BuildContext bc){
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter set){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker2(
                    config: config,
                    value: _multiDatePickerValueWithDefaultValue,
                    onValueChanged: (dates) => set(() => _multiDatePickerValueWithDefaultValue = dates),
                  ),
                  const Text('الايام المختارة'),
                  const SizedBox(width: 10),
                  Text(
                    _getValueText(
                      config.calendarType,
                      _multiDatePickerValueWithDefaultValue,
                    ) == 'null' ? '' : _getValueText(
                      config.calendarType,
                      _multiDatePickerValueWithDefaultValue,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  SizedBox(height: 0.02*h),
                  InkWell(
                    onTap: (){
                      if(_getValueText(
                        config.calendarType,
                        _multiDatePickerValueWithDefaultValue,
                      ) != 'null' ){
                        HomeCubit.get(context).checkQuantity( _getValueText(
                          config.calendarType,
                          _multiDatePickerValueWithDefaultValue,
                        ), HomeCubit.get(context)
                            .singleProductModel!
                            .data!.id.toString());
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: w*0.8,
                      height: h * 0.05,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Center(
                        child: Text(
                          translateString('Confirm', 'تأكيد'),
                          style: TextStyle(
                              color:
                              Colors.white,
                              fontFamily:
                              (lang == 'en')
                                  ? 'Nunito'
                                  : 'Almarai',
                              fontWeight:
                              FontWeight
                                  .bold,
                              fontSize:
                              w * 0.06),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
    );
  }
  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}
