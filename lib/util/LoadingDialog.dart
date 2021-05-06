import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return LoadingDialogState();
  }

}

class LoadingDialogState extends State<LoadingDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
