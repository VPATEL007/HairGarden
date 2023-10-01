import 'package:flutter/material.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import '../../COMMON/common_color.dart';
import '../../COMMON/size_config.dart';

class common_txtform_yllow extends StatefulWidget {
  String? hinttxt;
  TextEditingController? controller;
  String? Function(String?)? validator;
  InputBorder? focusedBorder;


  common_txtform_yllow({super.key, required this.hinttxt,required this.controller,this.validator,this.focusedBorder});

  @override
  State<common_txtform_yllow> createState() => _common_txtform_yllowState();
}

class _common_txtform_yllowState extends State<common_txtform_yllow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth*0.9,
      child: TextFormField(
        validator: widget.validator,
        style:  font_style.greyA1A1AA_400_16.copyWith(color: Colors.black),
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: widget.focusedBorder??OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: yellow_col),
          ),
          errorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: yellow_col),
          ),
          focusedBorder:widget.focusedBorder??OutlineInputBorder(
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
