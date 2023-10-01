import 'package:flutter/material.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import '../../COMMON/common_color.dart';
import '../../COMMON/size_config.dart';

class comon_pofile_txtform extends StatefulWidget {
  String? hinttxt;
  TextEditingController? controller;
  bool isreadonly;

  comon_pofile_txtform({required this.hinttxt,required this.controller,required this.isreadonly});

  @override
  State<comon_pofile_txtform> createState() => _comon_pofile_txtformState();
}

class _comon_pofile_txtformState extends State<comon_pofile_txtform> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth*0.9,
      child: TextFormField(
        readOnly: widget.isreadonly,
        style:  font_style.black_400_16,
        controller: widget.controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: yellow_col),
            ),
            focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: yellow_col),
            ),
            hintText: widget.hinttxt.toString(),
            hintStyle: font_style.greyA1A1AA_400_16,
            contentPadding: EdgeInsets.only(left: 6)
        ),
      ),
    );
  }
}
