import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:qr/constant/CommonConstant.dart';
import 'package:qr/dto/Header/HeaderGW.dart';
import 'package:qr/screens/Transaction_Screen/payment_screen.dart';
import 'package:qr/screens/qr_image.dart';
import 'package:qr/screens/Transaction_Screen/IBFT_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:qr/api_service/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class QrCamera extends StatefulWidget {
  // final String username;
  // final String accountNumber;
  // final String fullName;

  // QrCamera({required this.username, required this.accountNumber, required this.fullName});

  @override
  _QrCameraState createState() => _QrCameraState();
}

class _QrCameraState extends State<QrCamera> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late String qrString = '';
  late Barcode result;
  late QRViewController controller;
  late String amount = '';
  late String accountNumber = '' ;
  late String bankName = '' ;
  late String shortName = '' ;
  late String bank = '';

  APIService apiService = new APIService();

  StreamController<String> qrTextController = StreamController<String>.broadcast();

  Future<void> sendQRData(String qrString) async {

    // Gọi tới API đọc chuỗi QrString
    final url = Uri.parse(CommonConstant.apiReadQR);


    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Define the body of the HTTP request as a JSON-encoded string
    final json = jsonEncode({
      'headerGW': {
        'bkCd': '970415',
        'brCd': CommonConstant.CURRENCY,
        'trnDt': CommonConstant.TRANSACTION_DATE,
        'direction': CommonConstant.DIRECTION_OUTBOUND,
        'reqResGb': CommonConstant.REQ_GB,
        'refNo': CommonConstant.REFERENCE_NUMBER,
        'errCode': null,
        'errDesc': null,
      },
      'data': {
        'qrString': qrString,
        'channel': 'M',
      },
    });

    try {
      // Gửi request HTTP tới backend
      final response = await http.post(url, headers: headers, body: json);

      // Xử lý response từ backend
      if (response.statusCode == 200) {

        //Lấy ra thông tin
        final jsonResponse = jsonDecode(response.body);
        String serviceCode = jsonResponse['data']['qrInfo']['serviceCode'];
        String bkCd = jsonResponse['headerGW']['bkCd'];


        // Lấy thông tin ngân hàng
        Map<String, dynamic> bankData = await apiService.getDataBank(bkCd);
        // bank = bankData['bank'];
        bank = bankData['shortName'];
        debugPrint('bank: $bank');
        debugPrint('jsonResponse: $jsonResponse');

        if (serviceCode == 'QRPUSH') {

          // Gọi api xử lý bản tin Lookup
          await apiService.callApiAndNavigate(qrString, (jsonResponse) {
            if (jsonResponse['data'] == null) {
              // Hiển thị thông báo System timeout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Máy chủ đang bảo trì'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Đóng thông báo
                          Navigator.pop(context); // Quay lại màn hình trước đó
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Nếu data không null, chuyển đến màn hình PaymentScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    bank: bank,
                    jsonResponse: jsonResponse,
                  ),
                ),
              );
            }
          });
        } else if (serviceCode == 'QRIBFTTA') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => IBFTScreen(
                jsonResponse: jsonResponse,
                bank: bank,
              ),
            ),
          );
        }
      } else {
        print('Error sending QR data: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text('Mã QR không đúng'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng dialog
                    // Chuyển đến màn hình tiếp tục quét
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrCamera(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    catch(e) {

      debugPrint('error: $e ');
      // Xử lý exception ở đây
    }
  }

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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => QrImageScreen(
                          // accountNumber: widget.accountNumber,
                          // username: widget.username,
                          // fullName : widget.fullName,
                        )),
                      );
                    },
                    child: Text(
                      "My Qr",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
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
      }
    });

  }
}


