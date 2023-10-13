import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/no_glow.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/EMPLOYEE/emp_bottombar.dart';
import 'package:hairgardenemployee/auth/Screens/login_page.dart';
class relaxnow_page extends StatefulWidget {
  const relaxnow_page({Key? key}) : super(key: key);

  @override
  State<relaxnow_page> createState() => _relaxnow_pageState();
}

class _relaxnow_pageState extends State<relaxnow_page> {
  @override
  Widget build(BuildContext context) {
    AppBar appbar=AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Image(image:AssetImage( "assets/images/HG_logo_small.png" )),
          SizedBox(width: SizeConfig.screenWidth*0.2,),
          Container(
              height: SizeConfig.screenHeight*0.015,
              width: SizeConfig.screenWidth*0.03,
              child: const Image(image:AssetImage( "assets/images/star.png" ),fit: BoxFit.fill,)),
        ],
      ),
    );
    return  WillPopScope(
      onWillPop: (){
        Get.to(const login_page());
        return Future.value(false);
        },
      child: Scaffold(
        backgroundColor: newLightColor,
        appBar: appbar,
        body: ScrollConfiguration(
          behavior: NoGlow(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              height:SizeConfig.screenHeight - (MediaQuery.of(context).padding.top + kToolbarHeight),
              width: SizeConfig.screenWidth,
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomLeft,
                  children:[
                    Positioned(
                      top: SizeConfig.screenHeight*0.5,
                      left:- SizeConfig.screenWidth*0.6 ,
                      child: Container(
                        height: SizeConfig.screenHeight*0.8,
                        width: SizeConfig.screenWidth*0.8,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color:yellow_col,width: 3)
                        ),
                      ),
                    ),
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: SizeConfig.screenHeight*0.1,),

                        //RELAX NOW
                        Center(
                            child:  Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topLeft,
                                children:[
                                  Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      color: common_color,
                                      child: const Text("",style: TextStyle(fontSize: 32,fontFamily: 'Lato',color: Colors.white,fontWeight: FontWeight.w600),
                                      )
                                  ),
                                  //LEFT STAR
                                  Positioned(
                                      top: -SizeConfig.screenHeight*0.02,
                                      left: -SizeConfig.screenWidth*0.23,
                                      child: Container(
                                          height: SizeConfig.screenHeight*0.015,
                                          width: SizeConfig.screenWidth*0.09,
                                          child: SvgPicture.asset("assets/images/lest_star.svg"))
                                  ),

                                  //BIG STAR
                                  Positioned(
                                      top: -SizeConfig.screenHeight*0.05,
                                      right: -SizeConfig.screenWidth*0.14,
                                      child: Container(
                                          height: SizeConfig.screenHeight*0.035,
                                          width: SizeConfig.screenWidth*0.08,
                                          child: SvgPicture.asset("assets/images/big_star_svg.svg"))
                                  ),

                                  //CIRCLE
                                  Positioned(
                                    top: -SizeConfig.screenHeight*0.04,
                                    left: -SizeConfig.screenWidth*0.1,
                                    child: Container(
                                      height: SizeConfig.screenHeight*0.08,
                                      width: SizeConfig.screenWidth*0.16,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color:yellow_col,width: 3)
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -SizeConfig.screenHeight*0.002,
                                    left: SizeConfig.screenWidth*0.008,
                                    child: Container(
                                      height: SizeConfig.screenHeight*0.04,
                                      width: SizeConfig.screenWidth*0.1,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      color: common_color,
                                      child: const Text("RELAX NOW",style: TextStyle(fontSize: 32,fontFamily: 'Lato',color: Colors.white,fontWeight: FontWeight.w600),
                                      )
                                  ),
                                ]
                            )
                        ),
                        const Spacer(),

                        //ALREADY ACCOUNT
                        Center(
                          child: Container(
                            width: SizeConfig.screenWidth*0.9,
                            child: GestureDetector(
                                onTap: (){
                                  Get.to(emp_bottombar(pasindx: 0));
                                },
                                child: Text("Sit Back & Relax now, We will revert back to you in 3-4 days till we Verify your Profile.",style: font_style.white_400_16,)),
                          ),
                        ),
                        const Spacer(),
                        const Spacer(),

                      ],
                    ),

                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
