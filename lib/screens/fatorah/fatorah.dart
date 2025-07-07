import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_cubit/app_cubit.dart';
import '../../componnent/constants.dart';
import '../../componnent/http_services.dart';
import '../../generated/local_keys.dart';
import '../bottomnav/homeScreen.dart';
import '../cart/cart_product/body.dart';
import '../cart/cubit/cart_cubit.dart';
import '../orders/cubit/order_cubit.dart';
import '../tabone_screen/cubit/home_cubit.dart';

class FatorahScreen extends StatefulWidget {
  const FatorahScreen({Key? key}) : super(key: key);

  @override
  State<FatorahScreen> createState() => _FatorahScreenState();
}

class _FatorahScreenState extends State<FatorahScreen> {
  String currency = '';
  String lang = '';
  GlobalKey? imageKey;

  ScreenshotController screenshotController = ScreenshotController();

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    DateTime date = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(translateString('Invoice', 'الفاتورة'),style: TextStyle(
            color: mainColor,fontSize: w*0.045,fontWeight: FontWeight.bold
          ),),
          leading: BackButton(
            color: Colors.black,onPressed: (){
            BlocProvider.of<AppCubit>(context)
                .notifyCount();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(index: 0)),
                    (route) => false);
          },
          ),
        ),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return ConditionalBuilder(
                condition: state is SaveOrderSuccessState,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.02*h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              translateString('Order', "طلب"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: h * 0.01,
                            ),
                            Text(
                              '#${CartCubit.get(context).fatorrahModel!.order!.id.toString()}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              translateString('Placed on', "تم فى"),
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: h * 0.01,
                            ),
                            Text(
                              DateFormat('EEEE hh:mm aa').format(date),
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        GridView.builder(
                            itemBuilder: (context, i) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      EndPoints.IMAGEURL2 +
                                          CartCubit.get(context).fatorrahModel!.order!.orderItems![i].product!.img!,
                                      width: w * 0.2,
                                      height: h * 0.08,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 0.7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          translateString(CartCubit.get(context).fatorrahModel!.order!.orderItems![i].product!.titleEn!, CartCubit.get(context).fatorrahModel!.order!.orderItems![i].product!.titleAR!),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14),maxLines: 1,
                                        ),
                                        Text(
                                          '${translateString('Quantity:', 'كمية:')} ${CartCubit.get(context).fatorrahModel!.order!.orderItems![i].quantity}',
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: h * 0.001,
                                mainAxisExtent: h * 0.09,
                                crossAxisCount: 1),
                            itemCount: CartCubit.get(context).fatorrahModel!.order!.orderItems!.length),
                        SizedBox(
                          height: h * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translateString('Subtotal', "المجموع الفرعي"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            Text(
                              (HomeCubit.get(context)
                                  .settingModel!
                                  .data!
                                  .isFreeShop ==
                                  0)
                                  ?
                              getProductprice(
                            currency: currency,
                            productPrice: num.parse(CartCubit.get(context).fatorrahModel!.order!.totalPrice.toString())- num.parse( prefs
                                .getString(
                                "delivery_value")
                                .toString())) : getProductprice(
                                  currency: currency,
                                  productPrice: num.parse(CartCubit.get(context).fatorrahModel!.order!.totalPrice.toString())),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily:
                                (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                fontSize: w * 0.04,
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
                            Text(
                              LocalKeys.SHIPPING.tr(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              width: h * 0.01,
                            ),
                            (HomeCubit.get(context)
                                .settingModel!
                                .data!
                                .isFreeShop ==
                                0)
                                ? Text(
                              getShippingprice(
                                currency: currency,
                                shippingPrice:
                                num.parse(
                                  prefs
                                      .getString(
                                      "delivery_value")
                                      .toString(),
                                ),
                                cartLength:
                                1,
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily:
                                  (lang == 'en')
                                      ? 'Nunito'
                                      : 'Almarai',
                                  fontSize: w * 0.04),
                            )
                                : Text(
                              LocalKeys.FREE_SHIPPING
                                  .tr(),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily:
                                (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                fontSize: w * 0.04,
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
                            Text(
                              translateString('Total', 'الاجمالى'),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              width: h * 0.01,
                            ),
                            Text(
                              getProductprice(
                                  currency: currency,
                                  productPrice: num.parse(CartCubit.get(context).fatorrahModel!.order!.totalPrice.toString())),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily:
                                (lang == 'en')
                                    ? 'Nunito'
                                    : 'Almarai',
                                fontSize: w * 0.04,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.04,
                        ),
                        Text(
                          translateString('Shipping Address', 'عنوان الشحن'),
                          style: const TextStyle(
                              color: Colors.black,fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          width: h * 0.01,
                        ),
                        Text(
                          "${CartCubit.get(context).fatorrahModel!.order!.country!.nameAr ?? ''} ${CartCubit.get(context).fatorrahModel!.order!.city!.nameAr ?? ''} ${CartCubit.get(context).fatorrahModel!.order!.region ?? ''} ${CartCubit.get(context).fatorrahModel!.order!.theStreet ?? ''}",
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: h * 0.04,
                        ),
                        Text(
                          translateString('Payment Method', 'طريقة الدفع'),
                          style: const TextStyle(
                              color: Colors.black,fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          width: h * 0.01,
                        ),
                        Text(
                          prefs.getString('paymentMethod') ?? '',
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () async {
                            screenshotController.capture().then((image) async {
                              //Capture Done
                              await [Permission.storage].request();
                              final time = DateTime.now().toIso8601String().replaceAll('.', '_').replaceAll(':', '_');
                              final name = 'screenshot_$time';
                              final result = ImageGallerySaver.saveImage(image!,name: name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(translateString('saved in gallery', 'تم الحفظ فى الصور')),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }).catchError((onError) {
                              print(onError);
                            });
                          },
                          child: Center(
                            child: Container(
                              width: w*0.85,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 7),
                                child: Center(
                                  child: Text(
                                    translateString(
                                        'Download', 'تحميل'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.05,
                        ),
                      ],
                    ),
                  );
                },
                fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    ));
          },
        ),
      ),
    );
  }
}
