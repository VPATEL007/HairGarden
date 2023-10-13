import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common_color.dart';

class commonindicator extends StatefulWidget {
  const commonindicator({Key? key}) : super(key: key);

  @override
  State<commonindicator> createState() => _commonindicatorState();
}

class _commonindicatorState extends State<commonindicator> {
  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(color: yellow_col,));
  }
}