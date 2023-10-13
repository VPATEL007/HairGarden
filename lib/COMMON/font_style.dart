import 'package:flutter/material.dart';


import 'common_color.dart';

final Shader linearGradient = LinearGradient(
  colors: <Color>[ Color(0xffBF8D2C),Color(0xffDBE466),Color(0xffBF8D2C)],
).createShader(Rect.fromLTWH(75.0, 8000.0, 80.0, 200.0));

final Shader linearGradient2 = LinearGradient(
  colors: <Color>[ Color(0xff1F4B3E),Color(0xffC18F2C)],
).createShader(Rect.fromLTWH(10.0, 80.0, 80.0, 200.0));

final Shader linear_600_16 = LinearGradient(
  colors: <Color>[ Color(0xffBF8D2C),Color(0xffDBE466),Color(0xffBF8D2C)],
).createShader(Rect.fromLTWH(0.0, 0.0, 90.0, 70.0));

class font_style{
  static TextStyle  grad_600_20 =TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
      foreground: Paint()..shader = linearGradient
  );

  static TextStyle  grad2_600_16 =TextStyle(
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
  );

  static TextStyle  grad_600_16 =TextStyle(
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
  );

  static TextStyle  green_600_14 =TextStyle(
      fontSize: 14,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      color: common_color
  );
  static TextStyle  green_600_12 =TextStyle(
      fontSize: 12,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      color: common_color
  );
  static TextStyle  green_600_16 =TextStyle(
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: common_color
  );
  static TextStyle  green16A34A_600_16 =TextStyle(
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: Color(0xff16A34A)
  );
  static TextStyle  redDC2626_600_16 =TextStyle(
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: Color(0xffDC2626)
  );
  static TextStyle  yelEAB308_600_16 =TextStyle(
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: Color(0xffEAB308)
  );

  static TextStyle  red_600_16 =TextStyle(
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: Colors.red
  );
  static TextStyle  red_600_14 =TextStyle(
      fontSize: 14,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: Colors.red
  );
  static TextStyle  red_600_18 =TextStyle(
      fontSize: 18,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: Colors.red
  );
  static TextStyle  red_600_20 =TextStyle(
      fontSize: 20,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: Colors.red
  );
  static TextStyle  green_600_20 =TextStyle(
      fontSize: 20,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: common_color
  );

  static TextStyle  green_500_10 =TextStyle(
      fontSize: 10,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.underline,
      color: common_color
  );
  static TextStyle  g27272A_400_14 =TextStyle(
      fontSize: 14,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w400,
      color: Color(0xff27272A)
  );
  static TextStyle  white_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  transparent_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Colors.transparent,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  white_500_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w500,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  white_600_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  transpaent_600_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Colors.transparent,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  white_300_12 =TextStyle(
    fontSize: 8,
    fontFamily: 'Lato',
    color: Colors.white.withOpacity(0.6),
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_600_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  black_600_14 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    decoration: TextDecoration.underline,
    color: Colors.black,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_600_18 =TextStyle(
    fontSize: 18,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  darkgray_600_18 =TextStyle(
    fontSize: 18,
    fontFamily: 'Lato',
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  darkgray_500_15 =TextStyle(
    fontSize: 15,
    fontFamily: 'Lato',
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w500,

  );
  static TextStyle  darkgray_600_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w600,

  );
  static TextStyle  darkgray_600_20 =TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w600,

  );

  static TextStyle  darkgray_400_10 =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w400,

  );

  static TextStyle  darkgray_400_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w400,

  );

  static TextStyle  darkgray_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w600,

  );
  static TextStyle  darkgray_600_14_underline =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    decoration: TextDecoration.underline,
    color: Color(0xff18181B).withOpacity(0.9),
    fontWeight: FontWeight.w600,

  );

  static TextStyle  black_600_20 =TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );


  static TextStyle  black_600_14_nounderline =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_400_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  black_400_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  lightgeen_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff22C55E).withOpacity(0.5),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  blue_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff2563EB).withOpacity(0.6),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_400_20 =TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_500_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w500,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_500_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w500,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_500_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w500,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  white_400_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  white_400_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  B3B3B3_400_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Color(0xffB3B3B3),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_400_10 =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  Recoleta_black_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: "Recoleta",
    color: Colors.black,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  grey52525B_400_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Color(0xff52525B),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_400_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  black_600_28 =TextStyle(
    fontSize: 28,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  cal_black_400_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w700,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  yell_400_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: yellow_col,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  yell_400_10 =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: yellow_col,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  yell_500_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: yellow_col,
    fontWeight: FontWeight.w500,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  greyA1A1AA_400_10 =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Color(0xffA1A1AA),
    decoration: TextDecoration.lineThrough,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  greyA1A1AA_600_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Color(0xffA1A1AA),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  greyA1A1AA_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xffA1A1AA),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  greyA1A1AA_400_10_noline =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Color(0xffA1A1AA),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  FACC15_400_10_noline =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Color(0xffFACC15),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  red_400_10_noline =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Colors.red,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  blue2563EB_400_10_noline =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Color(0xff2563EB),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  grey52525B_400_10_noline =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Color(0xff52525B),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );


  static TextStyle  green16A34A_400_10_noline =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Color(0xff16A34A),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  greyA1A1AA_400_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Color(0xffA1A1AA),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  greyA1A1AA_400_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Color(0xffA1A1AA),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  greyA1A1AA_400_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xffA1A1AA),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );


  static TextStyle  white_400_10 =TextStyle(
    fontSize: 10,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  white_500_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w500,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  gr27272A_400_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff27272A),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  gr27272A_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff27272A),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  grD4D4D8_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xffD4D4D8),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  gr27272A_600_12 =TextStyle(
    fontSize: 12,
    fontFamily: 'Lato',
    color: Color(0xff27272A),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  gr27272A_600_16 =TextStyle(
    fontSize: 16,
    fontFamily: 'Lato',
    color: Color(0xff27272A),
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  gr808080_400_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff808080),
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  otp_txtstyl =TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    color: Colors.white,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  otp_txtstyl2 =TextStyle(
    fontSize: 20,
    fontFamily: 'Lato',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  yellow_400_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: yellow_col,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  yellow_400_14_underline =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: yellow_col,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w400,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  yellow_600_14 =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: yellow_col,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );

  static TextStyle  yellow_600_14_underline =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: yellow_col,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  grey18181B_600_14_underline =TextStyle(
    fontSize: 14,
    fontFamily: 'Lato',
    color: Color(0xff18181B),
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );
  static TextStyle  yellow_600_24 =TextStyle(
    fontSize: 24,
    fontFamily: 'Lato',
    color: yellow_col,
    fontWeight: FontWeight.w600,
    // foreground: Paint()..shader = linear_600_16
  );
}