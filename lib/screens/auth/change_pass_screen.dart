import 'package:arkan/screens/auth/sendcode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../componnent/constants.dart';
import 'login.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key, required this.forget});

  final bool forget;

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04*w),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0.03*h),
                Center(
                  child: Image.asset(
                    'assets/icons/code_send.png',
                    height: 0.35*h,
                  ),
                ),
                SizedBox(height: 0.02*h),
                Text('كلمه المرور الجديده',style: TextStyle(
                    fontFamily: 'Almarai',
                    color: Colors.black,
                    fontWeight:
                    FontWeight.w700,
                    fontSize: w * 0.03),),
                SizedBox(height: 0.02*h),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(25)),
                  width: 0.95*w,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      prefixIcon: SvgPicture.asset('assets/icons/lock.svg'),
                      prefixIconConstraints: BoxConstraints(maxHeight: 0.05*h,minWidth: 0.1*w),
                      contentPadding: EdgeInsets.only(top:0.02*h),
                      suffixIcon: SizedBox(
                        width: 0.18*w,
                        child: const Icon(
                          Icons.remove_red_eye_outlined,color: Colors.grey,
                        ),
                      ),
                      hintText: 'كلمة المرور',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: w*0.02,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color:  Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                    //textDirection: appLanguage.isEn ? TextDirection.ltr : TextDirection.rtl,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: w*0.03,
                    ),
                  ),
                ),
                SizedBox(height: 0.02*h),
                Text('تأكيد كلمة المرور',style: TextStyle(
                    fontFamily: 'Almarai',
                    color: Colors.black,
                    fontWeight:
                    FontWeight.w700,
                    fontSize: w * 0.03)),
                SizedBox(height: 0.02*h),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(25)),
                  width: 0.95*w,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset('assets/icons/lock.svg'),
                        prefixIconConstraints: BoxConstraints(maxHeight: 0.05*h,minWidth: 0.1*w),
                        contentPadding: EdgeInsets.only(top:0.02*h),
                        suffixIcon: SizedBox(
                          width: 0.18*w,
                          child: const Icon(
                            Icons.remove_red_eye_outlined,color: Colors.grey,
                          ),
                        ),
                        hintText: 'كلمة المرور',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: w*0.02,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color:  Colors.white,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
                      //textDirection: appLanguage.isEn ? TextDirection.ltr : TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: w*0.03,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.07*h),
                InkWell(
                  onTap: (){
                    if(widget.forget){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: const EdgeInsets.all(15),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              title: SvgPicture.asset('assets/icons/change_pass.svg'),
                              content: Text('تم تغيير كلمة المرور بنجاح اذهب لتسجيل الدخول',style: TextStyle(
                                  fontFamily: 'Almarai',
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w700,
                                  fontSize: w * 0.035),textAlign: TextAlign.center,),
                              actions: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Container(
                                      width: 0.8*w,
                                      decoration: BoxDecoration(color: mainColor,borderRadius: BorderRadius.circular(15)),
                                      child: TextButton(
                                        child: Text('تسجيل دخول',style: TextStyle(
                                            fontFamily: 'Almarai',
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.w700,
                                            fontSize: w * 0.035),),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder: (BuildContext context) => const Login()));
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const SendCodeScreen(forget: true)));
                    }
                    },
                  child: Center(
                    child: Container(
                      height: 0.06*h,
                      width: 0.7*w,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                            'حفظ',
                            style: TextStyle(
                                fontFamily: 'Almarai',
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: w * 0.04),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
