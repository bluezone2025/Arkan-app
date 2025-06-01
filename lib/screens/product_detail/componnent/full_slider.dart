// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../tabone_screen/cubit/home_cubit.dart';
import '../model/singleproduct_model.dart';
import 'add_to_cart.dart';

class FullSliderScreen extends StatefulWidget {
  final List<Images> image;
  final String productId;
  final bool login;
  final String? productImage;
  FullSliderScreen(
      {Key? key,
      required this.image,
      required this.productId,
      this.productImage, required this.login})
      : super(key: key);

  @override
  _FullSliderScreenState createState() => _FullSliderScreenState();
}

class _FullSliderScreenState extends State<FullSliderScreen>
    with SingleTickerProviderStateMixin {
  TransformationController? transformationController;

  AnimationController? animationController;
  TapDownDetails? tapDownDetails;
  Animation<Matrix4>? animation;
  @override
  void initState() {
    transformationController = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 200))
      ..addListener(() => transformationController!.value = animation!.value);
    super.initState();
  }

  @override
  void dispose() {
    transformationController!.dispose();
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          (widget.image.isNotEmpty)
              ? SizedBox(
                  width: w,
                  height: h,
                  child: GestureDetector(
                    onDoubleTap: () {
                      final position = tapDownDetails!.localPosition;
                      const double scale = 3.0;
                      final x = -position.dx * (scale - 1);
                      final y = -position.dy * (scale - 1);
                      final zoomed = Matrix4.identity()
                        ..translate(x, y)
                        ..scale(scale);
                      final end = transformationController!.value.isIdentity()
                          ? zoomed
                          : Matrix4.identity();
                      animation = Matrix4Tween(
                        begin: transformationController!.value,
                        end: end,
                      ).animate(
                        CurveTween(curve: Curves.easeOut)
                            .animate(animationController!),
                      );
                      animationController!.forward(from: 0);
                    },
                    onDoubleTapDown: (details) => tapDownDetails = details,
                    child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      panEnabled: false,
                      transformationController: transformationController,
                      child: Swiper(
                        pagination: const SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                                color: Colors.white38,
                                activeColor: Colors.white),
                            alignment: Alignment.bottomCenter),
                        itemBuilder: (BuildContext context, int i) {
                          return Container(
                            color: Colors.black,
                            child: customCachedNetworkImage(
                                url:
                                    EndPoints.IMAGEURL + widget.image[i].img!,
                                context: context,
                                fit: BoxFit.contain),
                          );
                        },
                        itemCount: widget.image.length,
                        autoplay: true,
                        autoplayDelay: 5000,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: w,
                  height: h,
                  color: Colors.white,
                  child: GestureDetector(
                    onDoubleTap: () {
                      final position = tapDownDetails!.localPosition;
                      const double scale = 3.0;
                      final x = -position.dx * (scale - 1);
                      final y = -position.dy * (scale - 1);
                      final zoomed = Matrix4.identity()
                        ..translate(x, y)
                        ..scale(scale);
                      final end = transformationController!.value.isIdentity()
                          ? zoomed
                          : Matrix4.identity();
                      animation = Matrix4Tween(
                        begin: transformationController!.value,
                        end: end,
                      ).animate(
                        CurveTween(curve: Curves.easeOut)
                            .animate(animationController!),
                      );
                      animationController!.forward(from: 0);
                    },
                    onDoubleTapDown: (details) => tapDownDetails = details,
                    child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      panEnabled: false,
                      transformationController: transformationController,
                      child: customCachedNetworkImage(
                          url: EndPoints.IMAGEURL2 + widget.productImage!,
                          context: context,
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: w * 0.02, vertical: h * 0.02),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: w * 0.08,
                  ),
                ),
                favouriteButton(
                    context: context,
                    login: widget.login,
                    productId: HomeCubit
                        .get(context)
                        .singleProductModel!
                        .data!
                        .id
                        .toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
