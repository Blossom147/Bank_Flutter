import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr/screens/transfer_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dto/DeCodeQRResponse.dart';
class QrCamera extends StatefulWidget {
  const QrCamera({Key? key}) : super(key: key);

  @override
  _QrCameraState createState() => _QrCameraState();
}

class _QrCameraState extends State<QrCamera> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late String qrString = '';
  late Barcode result;
  late QRViewController controller;

  StreamController<String> qrTextController = StreamController<String>.broadcast();

  @override
  void dispose() {
    qrTextController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildQrView(context),
          _buildTopOverlay(),
          _buildBottomOverlay(),
          _buildLeftOverlay(),
          _buildRightOverlay(),
        ],
      ),
    );
  }
  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "My Qr",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.qr_code,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
              Text(
                "Scan your QR code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildBottomOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildLeftOverlay() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      bottom: MediaQuery.of(context).size.height * 0.3,
      left: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightOverlay() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      bottom: MediaQuery.of(context).size.height * 0.3,
      right: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
  Future<DeCodeQRResponse> sendQRData(String qrString) async {
    final rawURL = "http://10.100.105.54:8080/infogw/qr/v1/readQR";
    final url = Uri.parse('http://192.168.137.1:8080/infogw/qr/v1/readQR');
    final json = {
      'header': {
        'bkCd': 'KEBHANABANK',
        'brCd': 'HN',
        'trnDt': '20230101',
        'direction': 'O',
        'reqResGb': 'REQ',
        'refNo': '2023010109000000001',
        'errCode': null,
        'errDesc': null
      },
      'data': {'qrString': qrString   , 'channel': 'M'}
    };

    Map<String, String> headers = {'Content-Type': 'application/json'};
    // final json = {
    //   'data': {'qrString': qrString},
    // };
    // final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: jsonEncode(json));
    print(response);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return DeCodeQRResponse.fromJson(result);
    } else {
      throw Exception('Failed to send QR data.');
    }
  }
  void _onQRViewCreated(QRViewController controller) {

    bool isScanned = false;
    setState(() {
      this.controller = controller;

    });
    controller.scannedDataStream.listen((scanData) {
      // Xử lý dữ liệu quét được
      if (!isScanned) {
        print(scanData.code);
        isScanned = true;
        controller.pauseCamera();
        setState(() {
          qrString = scanData.code!;
        });
        sendQRData(qrString);
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => TransferScreen(qrString: qrString, senderName: '', senderAccount: '', receiverName: '', receiverAccount: '', receiverBank: '', amount: '', currency: '', note: '',),
        ),
        );
      }
    });

  }
}
