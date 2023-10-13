import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';

class common_txtform_yllow extends StatefulWidget {
  String? hinttxt;
  String? Function(String?)? validator;
  TextEditingController? controller;
  List<TextInputFormatter> ? inputFormatters;
  TextInputType? keyboardType;
  bool readOnly;


  common_txtform_yllow(
      {required this.hinttxt, required this.controller, this.validator, this.inputFormatters, this.keyboardType, this.readOnly = false});

  @override
  State<common_txtform_yllow> createState() => _common_txtform_yllowState();
}

class _common_txtform_yllowState extends State<common_txtform_yllow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.9,
      child: TextFormField(
        readOnly:widget.readOnly,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        style: font_style.black_400_16,
        controller: widget.controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: yellow_col),
            ),
            focusedBorder: OutlineInputBorder(
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
