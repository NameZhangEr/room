import 'package:flutter/material.dart';

// import 'package:qrcode/qrcode.dart';
import 'package:barcode_scan/barcode_scan.dart';


class CaptureScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CaptureScanState();
  }
}

class CaptureScanState extends State<CaptureScan>
    with TickerProviderStateMixin {
  // QRCaptureController _captureController = QRCaptureController();
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    // _captureController.onCapture((data) {
    //   print('onCapture----$data');
    //   if (data.isNotEmpty) {
    //     Navigator.of(context).popUntil((route) => false);
    //     // Navigator.of(context).pop();
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // _captureController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫码'),
        actions: <Widget>[
          MaterialButton(
            child: Text(_isTorchOn ? '关闭手电筒' : '开启手电筒'),
            onPressed: () {
              setState(() {
                // _isTorchOn = !_isTorchOn;
                // if (_isTorchOn) {
                //   _captureController.torchMode = CaptureTorchMode.on;
                // } else {
                //   _captureController.torchMode = CaptureTorchMode.off;
                // }
              });
            },
          )
        ],
      ),
      body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
      // QRCaptureView(controller: _captureController),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 56),
      //   child: AspectRatio(
      //     aspectRatio: 264 / 258.0,
      //     child: Stack(
      //       alignment: _animation.value,
      //       children: <Widget>[
      //         Image.asset('images/sao@3x.png'),
      //         Image.asset('images/tiao@3x.png')
      //       ],
      //     ),
      //   ),
      // ),
      ],
    ),);
  }

  //扫描二维码
  static Future<String> getQrcodeState() async {
    try {
      const ScanOptions options = ScanOptions(
        strings: {
          'cancel': '取消',
          'flash_on': '开启闪光灯',
          'flash_off': '关闭闪光灯',
        },
      );
      final ScanResult result = await BarcodeScanner.scan(options: options);
      return result.rawContent;
    } catch (e) {

    }
    return null;
  }
}
