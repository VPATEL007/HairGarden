import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairgarden/COMMON/common_color.dart';

class CommonIndicator extends StatefulWidget {
  final Color? color;
  const CommonIndicator({Key? key, this.color}) : super(key: key);

  @override
  State<CommonIndicator> createState() => _CommonIndicatorState();
}

class _CommonIndicatorState extends State<CommonIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(color: widget.color??common_color,radius: 15));
  }
}