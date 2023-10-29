import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common_color.dart';

class commonindicator extends StatefulWidget {
  final Color? color;
  const commonindicator({Key? key, this.color}) : super(key: key);

  @override
  State<commonindicator> createState() => _commonindicatorState();
}

class _commonindicatorState extends State<commonindicator> {
  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(color: widget.color??yellow_col));
  }
}