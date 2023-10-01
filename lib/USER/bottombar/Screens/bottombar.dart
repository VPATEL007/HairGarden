import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hairgarden/USER/history/Screens/history_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../COMMON/common_color.dart';
import '../../address/Controller/get_address_controller.dart';
import '../../category/Screens/category.dart';
import '../../home/Controller/get_testimonials_controller.dart';
import '../../home/Screens/home_page.dart';
import '../../myprofile/Screens/myprofile_page.dart';

class BottomBar extends StatefulWidget {
  final int? pasindx;

  const BottomBar({super.key, required this.pasindx});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;

  // final _get_banner = Get.put(get_banner_controller());
  // final _get_profile_info = Get.put(get_profile_info_controller());
  // final _get_cart = Get.put(get_cart_controller());
  final _get_testimonials = Get.put(get_testimonials_controller());
  final _get_address = Get.put(get_address_controller());

  String? _deviceId;
  List<YoutubePlayerController> lYTC = [];

  Map<String, dynamic> cStates = {};
  fillYTlists() {
    for (var element in _get_testimonials.yturl) {
      String _id = YoutubePlayer.convertUrlToId(element)!;
      YoutubePlayerController _ytController = YoutubePlayerController(
        initialVideoId: _id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          enableCaption: true,
          captionLanguage: 'en',
          disableDragSeek: true,
        ),
      );

      _ytController.addListener(() {
        print('for $_id got isPlaying state ${_ytController.value.isPlaying}');
        if (cStates[_id] != _ytController.value.isPlaying) {
          if (mounted) {
            setState(() {
              cStates[_id] = _ytController.value.isPlaying;
            });
          }
        }
      });

      lYTC.add(_ytController);
    }
  }
  String? uid;
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

  getUserId() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
    });
  }

  var selectedadd;
  getSelectedAddress() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    getUserId();
    var getadd;
    setState(() {
      getadd = sf.getString("selectedaddressid");
      if (getadd == "" || getadd == null) {
        setState(() {
          selectedadd =
              _get_address.addsidlst.indexOf(_get_address.defaultaddid);
        });
      } else {
        setState(() {
          selectedadd = _get_address.addsidlst.indexOf(getadd);
        });
      }
    });
  }

  @override
  void initState() {
    // _get_banner.get_banner_cont();
    super.initState();
    currentIndex = widget.pasindx!;
    getUserId();
    // getselectedaddress();
    // getuserid().then((value) {
    //   _get_testimonials
    //       .get_testimonials_cont(uid.toString() == "" ? "" : uid.toString());
    //   // _get_profile_info.get_profile_info_cont(uid);
    //   initPlatformState().then((value) {
    //     fillYTlists();
    //     _get_cart.get_cart_cont(uid, _deviceId);
    //   });
    // });
  }

  List pages = [
    const home_page(),
    const HistoryPage(),
    const category(),
    const myprofile_page(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: common_color,
          unselectedLabelStyle: const TextStyle(color: Colors.white),
          onTap: (value) {
            getUserId();
            // _get_banner.get_banner_cont();
            // getselectedaddress();
            // getuserid().then((value) {
            //   getselectedaddress();
            //   _get_testimonials.get_testimonials_cont(
            //       uid.toString() == "" ? "" : uid.toString());
            //   _get_profile_info.get_profile_info_cont(uid);
            //   initPlatformState().then((value) {
            //     fillYTlists();
            //     _get_cart.get_cart_cont(uid, _deviceId);
            //   });
            // });
            setState(() {
              currentIndex = value;
            });
          },
          unselectedItemColor: const Color(0xffD4D4D8),
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "•"),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/bottom_calendar.svg",
                color: currentIndex == 1 ? common_color : const Color(0xffD4D4D8),
              ),
              label: "•",
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/bottom_third.svg",
                  color: currentIndex == 2 ? common_color : const Color(0xffD4D4D8),
                  fit: BoxFit.scaleDown,
                ),
                label: "•"),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: "•",
            ),
          ],
        ),
      ),
    );
  }
}
