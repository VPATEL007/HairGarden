import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../COMMON/size_config.dart';
import '../address/Controller/delete_address_controller.dart';
import '../address/Controller/get_address_controller.dart';
import '../home/Controller/get_testimonials_controller.dart';
import '../newmap1.dart';
import '../updatemap.dart';


Future<void> appModalBottomSheet(BuildContext context,selectedindx)  async {
  final _get_address=Get.put(get_address_controller());
  final _del_address=Get.put(delete_address_controller());
  final _get_testimonials=Get.put(get_testimonials_controller());
  String? uid;

  String? selectedadd;
  int bottomseladd=selectedindx;
  var selcindx=null;
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: bg_col,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18))
        ),
        child: StatefulBuilder(
          builder: (context, seState) {


            return Obx(
              () {
                return Padding(
                  padding:  EdgeInsets.only(top:SizeConfig.screenHeight*0.02 ,left: SizeConfig.screenWidth*0.025,right:  SizeConfig.screenWidth*0.025),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //GREEN COLOR CONT
                      Center(
                        child: Container(
                          height: 4,
                          width: SizeConfig.screenWidth*0.2,

                          decoration: BoxDecoration(
                              color: common_color,
                            borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight*0.015,),

                      Center(child: Text("SELECT LOCATION",style: font_style.black_600_20,)),
                      SizedBox(height: SizeConfig.screenHeight*0.03,),

                      //ADD ADDRESSES ROW
                      InkWell(
                        onTap: (){
                          Get.to(newmaps(pname: "home",));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add,color: common_color,),
                            SizedBox(width: 10,),
                            Text("Add Address",style: font_style.green_600_15,),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: common_color,size: SizeConfig.screenHeight*0.02,)
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight*0.01,),

                      //LINE
                      Container(
                        height: 1,
                        width: SizeConfig.screenWidth,
                        color: line_cont_col,
                      ),
                      SizedBox(height: SizeConfig.screenHeight*0.01,),

                      //SAVED ADDRESS TEXT
                      Text("Saved Addresses ",style:TextStyle(
                        fontSize: 18,
                        fontFamily: 'Lato',
                        color: common_color,
                        fontWeight: FontWeight.w500,
                        // foreground: Paint()..shader = linear_600_16
                      ),),
                      SizedBox(height: SizeConfig.screenHeight*0.01,),

                      SizedBox(height: SizeConfig.screenHeight*0.01,),

                      //LISTVIEW ADRESS
                      _get_address.response.value.data!.isEmpty?Center(child: Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Text("No Addresses Found"),
                      )):
                      Container(
                        height: SizeConfig.screenHeight*0.6,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _get_address.response.value.data!.length,
                          itemBuilder: (context, index) {
                            return  Obx(
                               () {
                                return Slidable(
                                  key:  ValueKey(0),
                                  endActionPane:  ActionPane(
                                    motion: DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          var locations = await locationFromAddress(_get_address.response.value.data![index].location.toString().replaceAll("\n", ""));
                                          Get.to(updateaddress(passlat: double.parse(locations.toString().replaceAll("\n", "").substring(locations.toString().replaceAll("\n", "").indexOf("Latitude:")+9,locations.toString().indexOf(",")).trim()),
                                            passlong: double.parse(locations.toString().replaceAll("\n", "").toString().substring(locations.toString().replaceAll("\n", "").indexOf("Longitude:")+10,locations.toString().replaceAll("\n", "").indexOf("Ti")).replaceAll(",", "").trim()),
                                            addid:_get_address.response.value.data![index].id,
                                            buildname:_get_address.response.value.data![index].buildingName ,
                                            locname: _get_address.response.value.data![index].locality, pagename: 'common' ,));
                                        },
                                        backgroundColor: common_color.withOpacity(0.7),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {

                                          SharedPreferences sf=await SharedPreferences.getInstance();
                                          seState(() {
                                            selcindx=index;
                                            uid=sf.getString("stored_uid");
                                            print("USER ID ID ${uid.toString()}");
                                          });
                                          _del_address.delete_address_cont( _get_address.response.value.data![index].id).then((value){
                                            _get_address.get_address_cont(uid).then((value){
                                                seState((){
                                                  selcindx=null;
                                                });
                                            });
                                          });
                                        },
                                        backgroundColor: Colors.red.withOpacity(0.7),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child:  selcindx==index && _get_address.loading.value?CommonIndicator():
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences sf=await SharedPreferences.getInstance();
                                      seState(()  {
                                        sf.setString("selectedaddressid", _get_address.response.value.data![index].id.toString());
                                        bottomseladd=index;
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: bottomseladd==index?common_color.withOpacity(0.3):Colors.transparent,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: SizeConfig.screenWidth*0.9,
                                              child: Text(_get_address.response.value.data![index].location.toString(),style:TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Lato',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                // foreground: Paint()..shader = linear_600_16
                                              ),)
                                          ),
                                          SizedBox(height: SizeConfig.screenHeight*0.01,),
                                          Row(
                                            children: [
                                              Text("Building Name: ",style:TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Lato',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                // foreground: Paint()..shader = linear_600_16
                                              ),),
                                              Container(
                                                  width: SizeConfig.screenWidth*0.6,
                                                  child: Text(_get_address.response.value.data![index].buildingName.toString(),style:TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Lato',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    // foreground: Paint()..shader = linear_600_16
                                                  ))
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Locality Name: ",style: font_style.black_600_12,),
                                              Container(
                                                  width: SizeConfig.screenWidth*0.6,
                                                  child: Text(_get_address.response.value.data![index].buildingName.toString(),style:TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Lato',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    // foreground: Paint()..shader = linear_600_16
                                                  ))
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight*0.01),
                              height: 1,
                              width: SizeConfig.screenWidth,
                              color: line_cont_col,
                            );
                          },
                        ),
                      ),

                      //NOTE
                      Padding(
                        padding:  EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_note_rounded,color: yellow_col,),
                            SizedBox(width: 5,),
                            Text("Note: For Edit/Delete your Address Swipe Left..",style:TextStyle(
                              fontSize: 14,
                              fontFamily: 'Lato',
                              color: yellow_col,
                              fontWeight: FontWeight.w500,
                              // foreground: Paint()..shader = linear_600_16
                            ),),
                          ],
                        ),
                      ),
                      // ListView.separated(
                      //   shrinkWrap: true,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   itemCount: _get_address.response.value.data!.length,
                      //   itemBuilder: (context, index) {
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.end,
                      //           children: [
                      //             InkWell(
                      //                 onTap: () async {
                      //                   var locations = await locationFromAddress(_get_address.response.value.data![index].location.toString().replaceAll("\n", ""));
                      //                   Get.to(updateaddress(passlat: double.parse(locations.toString().replaceAll("\n", "").substring(locations.toString().replaceAll("\n", "").indexOf("Latitude:")+9,locations.toString().indexOf(",")).trim()),
                      //                     passlong: double.parse(locations.toString().replaceAll("\n", "").toString().substring(locations.toString().replaceAll("\n", "").indexOf("Longitude:")+10,locations.toString().replaceAll("\n", "").indexOf("Ti")).replaceAll(",", "").trim()),
                      //                     addid:_get_address.response.value.data![index].id,
                      //                     buildname:_get_address.response.value.data![index].buildingName ,
                      //                     locname: _get_address.response.value.data![index].locality ,));
                      //                 },
                      //                 child: Icon(Icons.edit,color: common_color,)),
                      //             SizedBox(width: SizeConfig.screenHeight*0.02,),
                      //             Icon(Icons.delete,color:common_color,),
                      //           ],
                      //         ),
                      //         Container(
                      //             width: SizeConfig.screenWidth*0.8,
                      //             child: Text(_get_address.response.value.data![index].location.toString(),style:TextStyle(
                      //               fontSize: 15,
                      //               fontFamily: 'Lato',
                      //               color: Colors.black,
                      //               fontWeight: FontWeight.w400,
                      //               // foreground: Paint()..shader = linear_600_16
                      //             ),)
                      //         ),
                      //         SizedBox(height: SizeConfig.screenHeight*0.01,),
                      //         Row(
                      //           children: [
                      //             Text("Building Name: ",style:TextStyle(
                      //               fontSize: 13,
                      //               fontFamily: 'Lato',
                      //               color: Colors.black,
                      //               fontWeight: FontWeight.w500,
                      //               // foreground: Paint()..shader = linear_600_16
                      //             ),),
                      //             Container(
                      //                 width: SizeConfig.screenWidth*0.5,
                      //                 child: Text(_get_address.response.value.data![index].buildingName.toString(),style:TextStyle(
                      //                   fontSize: 13,
                      //                   fontFamily: 'Lato',
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w400,
                      //                   // foreground: Paint()..shader = linear_600_16
                      //                 ))
                      //             ),
                      //           ],
                      //         ),
                      //         Row(
                      //           children: [
                      //             Text("Locality Name: ",style: font_style.black_600_12,),
                      //             Container(
                      //                 width: SizeConfig.screenWidth*0.5,
                      //                 child: Text(_get_address.response.value.data![index].buildingName.toString(),style:TextStyle(
                      //                   fontSize: 13,
                      //                   fontFamily: 'Lato',
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w400,
                      //                   // foreground: Paint()..shader = linear_600_16
                      //                 ))
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     );
                      //   },
                      //   separatorBuilder: (context, index) {
                      //     return Container(
                      //       margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight*0.01),
                      //       height: 1,
                      //       width: SizeConfig.screenWidth,
                      //       color: line_cont_col,
                      //     );
                      //   },
                      // )
                    ],
                  ),
                );
              }
            );
          },
        ),
      );
    },
  );
}
