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
import '../bottomnav/homeScreen.dart';
import '../cart/cart_product/body.dart';
import '../cart/cubit/cart_cubit.dart';
import '../orders/cubit/order_cubit.dart';

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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: mainColor),
                  shape: BoxShape.circle),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    BlocProvider.of<AppCubit>(context)
                        .notifyCount();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(index: 0)),
                            (route) => false);
                  },
                  icon: Icon(
                    Icons.close,color: mainColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return ConditionalBuilder(
                condition: state is SaveOrderSuccessState,
                builder: (context) {
                  return Column(
                    children: [
                      Text(
                        'شكرا لتسوقك من تطبيق اركان',
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        'رقـم الفــاتــورة',
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        CartCubit.get(context).fatorrahModel!.order!.id.toString(),
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        height: h * 0.73,
                        width: w,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0,right: 10,left: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      color: mainColor,
                                      width: w * 0.3,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'إجمالي الطلب',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getProductprice(
                                              currency: currency,
                                              productPrice: num.parse(CartCubit.get(context).fatorrahModel!.order!.totalPrice.toString())),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: w * 0.3,
                                      color: mainColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'الكمية',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          CartCubit.get(context).fatorrahModel!.order!.totalQuantity.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: w * 0.3,
                                      color: mainColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'تاريخ  الطلب',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          date.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: w * 0.3,
                                      color: mainColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'الاسم',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          CartCubit.get(context).fatorrahModel!.order!.name.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: w * 0.3,
                                      color: mainColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'العنوان',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${CartCubit.get(context).fatorrahModel!.order!.country!.nameAr} ${CartCubit.get(context).fatorrahModel!.order!.city!.nameAr} ${CartCubit.get(context).fatorrahModel!.order!.region} ${CartCubit.get(context).fatorrahModel!.order!.theStreet}",
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: w * 0.3,
                                      color: mainColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'رقم الهاتف',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          CartCubit.get(context).fatorrahModel!.order!.phone.toString(),
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: w * 0.3,
                                      color: mainColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'بريد الكتروني',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          CartCubit.get(context).fatorrahModel!.order!.email ?? '',
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Text(
                                  translateString(
                                      'Your Products', 'منتجـــاتـــك'),
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                SizedBox(
                                  height: h * 0.12,
                                  width: w,
                                  child: GridView.builder(
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              width: w * 0.3,
                                              child: Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: mainColor)),
                                                  child: Image.network(
                                                    EndPoints.IMAGEURL2 +
                                                        CartCubit.get(context).fatorrahModel!.order!.orderItems![i].product!.img!,
                                                    width: w * 0.2,
                                                    height: h * 0.1,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              CartCubit.get(context).fatorrahModel!.order!.orderItems![i].quantity ?? '',
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        );
                                      },
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: h * 0.001,
                                          mainAxisSpacing: w * 0.02,
                                          crossAxisCount: 4,
                                          childAspectRatio: 0.8),
                                      itemCount: CartCubit.get(context).fatorrahModel!.order!.orderItems!.length),
                                ),
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
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius: BorderRadius.circular(25)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0, vertical: 7),
                                        child: Text(
                                          translateString(
                                              'Download invoice', 'حمل الفاتورة'),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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
