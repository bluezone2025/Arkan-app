// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_cubit/app_cubit.dart';
import '../../app_cubit/appstate.dart';
import '../../componnent/constants.dart';
import '../product_detail/product_detail.dart';
import '../tabone_screen/cubit/home_cubit.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool switch1 = true;
  bool switch2 = false;
  bool click = false;

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).getNotify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<AppCubit, AppCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[150],
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                translateString('Notifications', 'الأشعارات'),
                style: TextStyle(
                    fontSize: w * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              leading: const BackButton(
                color: Colors.black,
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    right: w * .03, left: w * 0.03, top: h * 0.01),
                child: SizedBox(
                  height: h,
                  child: ConditionalBuilder(
                      condition: BlocProvider.of<AppCubit>(context)
                              .notificationsModel !=
                          null,
                      builder: (context) {
                        var model = BlocProvider.of<AppCubit>(context)
                            .notificationsModel;
                        return model!.notify.isNotEmpty ? ListView.separated(
                            //controller: _controller,
                            itemBuilder: (context, i) {
                              return  InkWell(
                                onTap: () async {
                                  if(model.notify[i].type == 'Product'){
                                    if (!click) {
                                      setState(() {
                                        click = true;
                                      });
                                      //await getItem(model.notify[i].typeId);
                                      HomeCubit.get(context).getProductdata(
                                          productId: model.notify[i].typeId);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProductDetail()));
                                      await Future.delayed(
                                          const Duration(milliseconds: 2500));
                                      setState(() {
                                        click = false;
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (model.notify[i].image != null)
                                          Center(
                                            child: Container(
                                              width: w * 0.9,
                                              height: h * 0.35,
                                              color: Colors.white,
                                              child: customCachedNetworkImage(
                                                  url: model.notify[i].image,
                                                  context: context,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: h * 0.01,
                                            ),
                                            Text(
                                                translateString(
                                                    model.notify[i].titleEn,
                                                    model.notify[i].titleAr),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: w * 0.04,fontWeight: FontWeight.bold),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            SizedBox(
                                              height: h * 0.005,
                                            ),
                                            Text(
                                                parseHtmlString(translateString(
                                                    model.notify[i].bodyEn ?? '',
                                                    model.notify[i].bodyAr ?? '')),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: w * 0.025),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: h * 0.03,
                              );
                            },
                            itemCount: model.notify.length) : Center(child: Text(translateString('Notifications is empty', 'لا توجد اشعارات'),style: TextStyle(color: mainColor),),);
                      },
                      fallback: (context) => Center(
                            child: CircularProgressIndicator(
                              color: mainColor,
                            ),
                          )),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: (Colors.grey[200]!), width: 1),
        borderRadius: BorderRadius.circular(5));
  }
}
