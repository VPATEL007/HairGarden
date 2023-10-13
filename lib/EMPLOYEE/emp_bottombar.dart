import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/Screens/appointments_page.dart';
import 'package:hairgardenemployee/EMPLOYEE/my%20earnings/Screens/my_earnings_page.dart';
import 'package:hairgardenemployee/EMPLOYEE/profile/Screens/myprofile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../COMMON/common_color.dart';
import 'home/Screens/employee_home.dart';

class emp_bottombar extends StatefulWidget {
  int? pasindx;

  emp_bottombar({required this.pasindx});

  @override
  State<emp_bottombar> createState() => _emp_bottombarState();
}

class _emp_bottombarState extends State<emp_bottombar> {
  int curr_indx = 0;

  setbottom() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setDouble("bottomPadding", MediaQuery.of(context).padding.bottom);
  }

  @override
  void initState() {
    super.initState();
    curr_indx = widget.pasindx!;
    setbottom();
  }

  List pages = [
    const employee_home(),
    const appointments_page(),
    const my_earnings_page(),
    const myprofile_page(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: pages[curr_indx],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: curr_indx,
          selectedItemColor: yellow_col,
          unselectedLabelStyle: const TextStyle(color: Colors.white),
          onTap: (value) {
            setState(() {
              setbottom();
              curr_indx = value;
            });
          },
          unselectedItemColor: const Color(0xffD4D4D8),
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: "•"),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/bottom_calendar.svg",
                color: curr_indx == 1 ? yellow_col : const Color(0xffD4D4D8),
              ),
              label: "•",
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/bottom_payment.svg",
                  color: curr_indx == 2 ? yellow_col : const Color(0xffD4D4D8),
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
