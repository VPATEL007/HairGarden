import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:readmore/readmore.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:shimmer/shimmer.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../category/Controller/add_cart_controller.dart';
import '../../category/Controller/decrease_cart_controller.dart';
import '../../category/Controller/get_addons_controller.dart';
import '../../category/Controller/get_all_cat_products_controller.dart';
import '../../category/Controller/get_cart_controller.dart';
import '../../category/Controller/remove_fromcart_controller.dart';
import '../../category/Controller/view_prod_details_controller.dart';
import '../../category/Screens/view_details.dart';
import '../../common/common_cart_cont.dart';
import '../../common/common_txt_list.dart';

class searched_details extends StatefulWidget {
  String? searchedname;


  searched_details({required this.searchedname});

  @override
  State<searched_details> createState() => _searched_detailsState();
}

class _searched_detailsState extends State<searched_details> {

  final _view_det=Get.put(view_prod_details_controller());
  final _get_allprod=Get.put(get_all_cat_products_controller());
  final _add_cart=Get.put(add_cart_controller());
  final _decrease_cart=Get.put(decrease_cart_controller());
  final _get_cart=Get.put(get_cart_controller());
  final _remove_from_cart=Get.put(remove_fromcart_controller());

  List catlist=[
    "Packages",
    "Meni & Pedi",
    "Face",
    "Bridal Makeup",
  ];
  final _get_addons = Get.put(get_addons_controller());
  List prod_img=[
    "assets/images/product1_img.png",
    "assets/images/product2_img.png",
    "assets/images/product3_img.png",
    "assets/images/product4_img.png",
    "assets/images/product5_img.png",
  ];
  int? selected_cat;
  int prod_price=1149;
  @override
  void initState() {
    super.initState();
    getuserid();

    _get_allprod.get_all_cat_products_cont().then((value) {
      setState(() {
        compareid();
        initPlatformState().then((value) {
          print("${uid.toString()==""||uid==null?"":uid.toString()}${ _deviceId.toString()}");
          _get_cart.get_cart_cont(uid.toString()==""||uid==null?"":uid.toString(), _deviceId.toString()).then((value) => _get_cart.prodid);
        });
        _get_allprod.response.value.data![indexofid].serviceCategoryData!.isEmpty?null:
        selected_cat=int.parse(_get_allprod.response.value.data![indexofid].serviceCategoryData![0].subcatId.toString());
      });
    });
  }

  String? uid;
  getuserid() async {
    SharedPreferences sf=await SharedPreferences.getInstance();
    setState(() {
      uid=sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }
  var indexofid;
  String? _deviceId;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;
    setState(() {
      _deviceId = deviceId;
    });
  }

  compareid(){
    setState(() {
      indexofid=_get_allprod.comparesearchid.indexOf(widget.searchedname);
      print("INDEX IS :$indexofid");
    });
  }
  int? selecedindx;
  @override
  Widget build(BuildContext context) {
    return  Obx(
            () {
          return Scaffold(
            backgroundColor: bg_col,
            appBar:  AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              leading: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios,color: common_color,size: 20,)),
              title: _get_allprod.loading.value?Center(child: CircularProgressIndicator(color: Colors.transparent,),):
              InkWell(
                  onTap: (){
                    setState(() {
                      initPlatformState();
                      print(_get_cart.prodid);
                    });
                  },
                  child: Text(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].name.toString(),style: font_style.green_600_16,)
              ),
              actions: [
                _get_cart.loading.value?Container():Container()
              ],
              bottom:
              PreferredSize(
                preferredSize: Size.fromHeight(SizeConfig.screenHeight*0.06),
                child: Padding(
                  padding:  EdgeInsets.only(left: SizeConfig.screenWidth*0.05,bottom: SizeConfig.screenHeight*0.015),
                  child: _get_allprod.loading.value?
                  Container(
                    height: SizeConfig.screenHeight*0.04,
                    width: SizeConfig.screenWidth,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, catindex) {
                        return Shimmer.fromColors(
                          baseColor: common_color.withOpacity(0.5),
                          highlightColor: Colors.white12.withOpacity(0.9),
                          child: Container(
                            width: SizeConfig.screenWidth*0.18,
                            alignment: Alignment.center,
                            height: SizeConfig.screenHeight*0.04,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: common_color),
                                borderRadius: BorderRadius.circular(50)
                            ),

                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: SizeConfig.screenWidth*0.03,);
                      },
                    ),
                  )
                      :
                  _get_allprod.response.value.data!.isEmpty?
                  Container(
                      height: SizeConfig.screenHeight*0.04,
                      width: SizeConfig.screenWidth,
                      child: Center(child: Text("No Subcategory found"),))

                      :

                  Container(
                    height: SizeConfig.screenHeight*0.04,
                    width: SizeConfig.screenWidth,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData!.length,
                      itemBuilder: (context, catindex) {
                        return InkWell(
                          onTap: (){
                            cart.clear();
                            setState(() {
                              if(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcateProduct!.isNotEmpty){
                                selected_cat=int.parse( _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcatId.toString());
                              }
                            });
                            itemScrollController.scrollTo(
                                index: catindex,
                                duration: Duration(seconds:1 ),
                                curve: Curves.easeInOutCubic);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            height: SizeConfig.screenHeight*0.04,
                            decoration: BoxDecoration(
                                color:    selected_cat==int.parse(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcatId.toString())?common_color:Colors.transparent,
                                border: Border.all(color:_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcateProduct!.isEmpty?
                                Colors.transparent: common_color),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Text(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcatName.toString(),
                              style: selected_cat==int.parse(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcatId.toString())&&
                                  _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcateProduct!.isNotEmpty?
                              font_style.white_400_14: _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![catindex].subcateProduct!.isEmpty?
                              TextStyle(color: Colors.transparent):
                              font_style.black_400_14,),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: SizeConfig.screenWidth*0.03,);
                      },
                    ),
                  ),
                ) ,
              ),
            ),
            body: _get_allprod.loading.value?CommonIndicator():

            _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData!.isEmpty?
            Center(child: Text("No Products found"),):
            ScrollablePositionedList.separated(
              // itemCount:  _get_sub_cat.response.value.data!.length,
              itemCount: _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData!.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, scrollindex) {
                return  _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct!.isEmpty? Center(child: Text(""),):
                Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct!.length,
                      itemBuilder: (context, prodindex) {
                        return Center(
                          child: Container(
                            width: SizeConfig.screenWidth*0.9,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //IMAGE
                                InkWell(
                                  onTap: (){
                                    print( _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                    print(prodindex+1);
                                  },
                                  child: Container(
                                    height: SizeConfig.screenHeight*0.11,
                                    width: SizeConfig.screenWidth*0.4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image:DecorationImage(
                                            image: NetworkImage(
                                                _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].image.toString()
                                            ),
                                            fit: BoxFit.fill
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.screenWidth*0.02,),

                                //DETAILS
                                Container(
                                  width: SizeConfig.screenWidth*0.48,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].title.toString(),style: font_style.black_500_15,),
                                      //Rs. DISCOUNT
                                      Row(
                                        children: [
                                          Text("₹${ _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].sellPrice.toString()}",style: font_style.yell_400_12,),
                                          SizedBox(width: SizeConfig.screenWidth*0.02,),
                                          Text( _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].price.toString(),style: font_style.greyA1A1AA_400_12,),
                                          Spacer(),
                                          Text("${ _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].percent.toString()}% OFF",style: font_style.black_400_12,),
                                        ],
                                      ),
                                      SizedBox(height: SizeConfig.screenHeight*0.01,),
                                      ReadMoreText(
                                        _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].description.toString(),
                                        trimLines: 2,
                                        colorClickableText: yellow_col,
                                        trimMode: TrimMode.Line,
                                        lessStyle: font_style.yellow_600_10,

                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: ' Show less',
                                        style: font_style.black_400_12,
                                        moreStyle: font_style.yellow_600_10,
                                      ),
                                      // Text(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].description.toString(),style: font_style.black_400_10,textAlign: TextAlign.justify,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          //VIEW DETAILS
                                          InkWell(
                                              onTap: (){
                                                _view_det.view_prod_details_cont(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());

                                                Get.to(view_details());

                                              },
                                              child: Text("View Details ",style: font_style.green_400_12,)
                                          ),

                                          selecedindx==_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())
                                              ?
                                          Container(
                                            width: SizeConfig.screenWidth*0.18,
                                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: yellow_col,
                                                borderRadius: BorderRadius.circular(44)
                                            ),
                                            child:  CupertinoActivityIndicator(color: Colors.white,),
                                          ) :
                                          _get_cart.prodid.contains(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())?

                                          //ADD REMOVE ROW
                                          Container(
                                            width: SizeConfig.screenWidth*0.18,
                                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: yellow_col,
                                                borderRadius: BorderRadius.circular(44)
                                            ),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                //SUBTRACT
                                                Flexible(
                                                  child: InkWell(
                                                      onTap: (){
                                                        print(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                        // print(_deviceId.toString());
                                                        setState(() {
                                                          selecedindx=_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                          // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = true;


                                                        });
                                                        setState(() {
                                                          if(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString()=='1'){
                                                            _remove_from_cart.remove_fromcart_cont(
                                                              // _get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(),
                                                                uid.toString()==""||uid==null?"":uid.toString(),
                                                                _deviceId.toString(),
                                                                _get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].id.toString()

                                                            ).then((value) {
                                                              setState(() {
                                                                selecedindx=null;
                                                                if(_get_cart.prodid.length==1){
                                                                  _get_cart.prodid.clear();
                                                                }
                                                                _get_cart.get_cart_cont(uid.toString()==""||uid==null?"":uid.toString(), _deviceId.toString());

                                                                // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                              });
                                                            });
                                                          }
                                                          else{
                                                            setState(() {
                                                              initPlatformState();
                                                              _decrease_cart.decrease_cart_cont(
                                                                  _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(),
                                                                  uid.toString()==""||uid==null?"":uid.toString(),
                                                                  _deviceId.toString(),
                                                                  "${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString())-1}"
                                                              ).then((value) {
                                                                setState(() {
                                                                  selecedindx=null;
                                                                  _get_cart.get_cart_cont(uid.toString()==""||uid==null?"":uid.toString(), _deviceId.toString());
                                                                  // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                                });
                                                              });
                                                            });

                                                          }
                                                        });
                                                      },
                                                      child: Icon(Icons.remove,color: Colors.white,size: 16,)
                                                  ),
                                                ),

                                                //TOTAL
                                                Text(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString(),style: font_style.white_400_10,),

                                                //ADD
                                                Flexible(
                                                  child: InkWell(
                                                      onTap: (){
                                                        print(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                        print("${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString())+1}");
                                                        setState(() {
                                                          selecedindx=_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                          // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = true;
                                                        });
                                                        initPlatformState();
                                                        _decrease_cart.decrease_cart_cont(
                                                            _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(),
                                                            uid.toString()==""||uid==null?"":uid.toString(),
                                                            _deviceId.toString(),
                                                            "${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString())+1}"
                                                        ).then((value) {
                                                          setState(() {
                                                            selecedindx=null;
                                                            _get_cart.get_cart_cont(uid.toString()==""||uid==null?"":uid.toString(), _deviceId.toString());
                                                            // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                          });
                                                        });

                                                      },
                                                      child: Icon(Icons.add,color: Colors.white,size: 16,)),
                                                ),
                                              ],
                                            ),
                                          ):

                                          //ADD BUTTON:
                                          InkWell(
                                            onTap: (){
                                              List getcartcatid=[];
                                              getcartcatid.clear();

                                              _get_cart.prodid.forEach((element) {
                                                getcartcatid.add(_get_allprod.allproductcatid[_get_allprod.checkprodid.indexOf(element)]);
                                              });
                                              if(_get_cart.response.value.data!.isEmpty || getcartcatid.contains(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].categoryId.toString())){
                                                setState(() {
                                                  selecedindx=_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                  // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = true;
                                                });
                                                print(_get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());

                                                initPlatformState();
                                                print(_get_cart.prodid);

                                                _add_cart.add_cart_cont(
                                                    _get_allprod.response.value.data![_get_allprod.comparesearchid.indexOf(widget.searchedname)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(),
                                                    "1",
                                                    uid.toString()==""||uid==null?"":uid.toString(),
                                                    _deviceId.toString(),
                                                    "service"
                                                ).then((value) {
                                                  setState(() {
                                                    selecedindx=null;
                                                    _get_cart.get_cart_cont(uid.toString()==""||uid==null?"":uid.toString(), _deviceId.toString());
                                                    // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                  });
                                                });
                                              }
                                              else{
                                                commontoas("You can't add other categories services");
                                              }



                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: SizeConfig.screenWidth*0.18,
                                              padding: EdgeInsets.symmetric(vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: yellow_col,
                                                  borderRadius: BorderRadius.circular(44)
                                              ),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("ADD",style: font_style.white_400_10,),
                                                  SizedBox(width: 5,),
                                                  Icon(Icons.add,color: Colors.white,size: 15,)
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      )

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ) /*: null*/;
                      },
                      separatorBuilder: (context, prodindex) {
                        return Container(
                          height: 1,
                          width: SizeConfig.screenWidth,
                          color: line_cont_col,
                          margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight*0.01),
                        );
                      },
                    ),
                  ],
                );
              },
              separatorBuilder: (context, scrollindex) {
                return  Container(
                  height: 1,
                  width: SizeConfig.screenWidth,
                  color: line_cont_col,
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight*0.01),
                );
              },
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
            ),


            bottomNavigationBar:_get_cart.response.value.data!.isEmpty?Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(),
              ],
            ):
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [

                common_cart_cont( uid: uid,
                    deviceId: _deviceId,
                    indexofid: _get_allprod.comparesearchid.indexOf(widget.searchedname).toString(),
                    selected_cat: selected_cat.toString(),
                    pagename: "allcat",
                    getslotid: "",
                    getbookdate: "",
                    getaddressid: "",
                    getstaffid: "",
                    getstafftype: ""
                )
              ],
            ),

          );
        }
    );
  }
}
