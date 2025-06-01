import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_cubit/appstate.dart';
import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../category/category.dart';
import '../../tabone_screen/cubit/home_cubit.dart';

class SearchCatergory extends StatefulWidget {
  const SearchCatergory({Key? key}) : super(key: key);

  @override
  State<SearchCatergory> createState() => _SearchCatergoryState();
}

class _SearchCatergoryState extends State<SearchCatergory> {
  String lang = '';

  getLang() async {
    setState(() {
      lang = prefs.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return BlocConsumer<HomeCubit, AppCubitStates>(
        builder: (context, state) {
          return ConditionalBuilder(
              condition: state is! HomeitemsLoaedingState,
              builder: (context) => ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoriesSection(
                                    mainCat: lang == 'en' ?  HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .categories![index].nameEn.toString() : HomeCubit.get(context)
                                        .homeitemsModel!
                                        .data!
                                        .categories![index].nameAr.toString(),
                                        mainCatId: HomeCubit.get(context)
                                            .homeitemsModel!
                                            .data!
                                            .categories![index]
                                            .id
                                            .toString(),
                                        subCategory: HomeCubit.get(context)
                                            .homeitemsModel!
                                            .data!
                                            .categories![index]
                                            .categoriesSub!,
                                      )));
                        },
                        child: Row(
                          children: [
                            Container(
                              width: w * 0.3,
                              height: h * 0.09,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(EndPoints.IMAGEURL2 +
                                          HomeCubit.get(context)
                                              .homeitemsModel!
                                              .data!
                                              .categories![index]
                                              .imageUrl!),
                                      fit: BoxFit.fitHeight)),
                            ),
                            SizedBox(
                              width: w * 0.03,
                            ),
                            Center(
                              child: (lang == 'en')
                                  ? Text(
                                      HomeCubit.get(context)
                                          .homeitemsModel!
                                          .data!
                                          .categories![index]
                                          .nameEn!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.04),
                                    )
                                  : Text(
                                      HomeCubit.get(context)
                                          .homeitemsModel!
                                          .data!
                                          .categories![index]
                                          .nameAr!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Almarai',
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.035),
                                    ),
                            )
                          ],
                        ),
                      ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: HomeCubit.get(context)
                      .homeitemsModel!
                      .data!
                      .categories!
                      .length),
              fallback: (context) => Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ));
        },
        listener: (context, state) {});
  }
}
