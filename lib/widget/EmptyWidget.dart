
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 130),
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/empty.png',
              width: 160,
              height: 160,
            ),
            SizedBox(
              height: 8,
            ),
            Text('空空如也~'),
          ],
        ),
      ),
    );
  }

}