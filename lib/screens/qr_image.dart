import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:qr/constant/CommonConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service/api_service.dart';
class QrImageScreen extends StatefulWidget {


  @override
  _QrImageScreenState createState() => _QrImageScreenState();
}

class _QrImageScreenState extends State<QrImageScreen> {
  String qrImageUrl = '';
  late String fullName = '';
  late String accountNumber;
  late String username = '';
  APIService apiService = APIService();

  @override
  void initState() {
    super.initState();
    getData();
  }
  void getData() async {
    final List<String> userData = await apiService.loadUserData();
    fullName = userData[0];
    accountNumber = userData[1];
    username = userData[2];
    sendDataGenQR(fullName, username, accountNumber);
  }

  Future<void> sendDataGenQR(String fullName,String username, String accountNumber) async {

    // Define the URL of the backend API endpoint
    final url = Uri.parse(CommonConstant.apiUrlGenQR);

    // Define the headers for the HTTP request
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Define the body of the HTTP request as a JSON-encoded string
    final json = jsonEncode({
      "headerGW":
      {
        "bkCd": "970467",
        "brCd": CommonConstant.CITY_CODE,
        "trnDt": "20230101",
        "direction":CommonConstant.DIRECTION_OUTBOUND,
        "reqResGb": CommonConstant.REQ_GB,
        "refNo":"2023010109000000001",
        "errCode":null,
        "errDesc":null
      },
      "data":
      {
        "qrInfo":
        {
          "serviceCode": CommonConstant.listServiceCode[3],
          "customerId": accountNumber,
          "transCurrency": CommonConstant.TRANS_CURRENCY,
          "customerName" : fullName,
          "countryCode": CommonConstant.COUNTRY_CODE,
          "additionInfo" : "",
          "transAmount": ""
        },
        "createdUser":"long",
        "channel":"M"
      }
    }  );

    // Send the HTTP request to the backend API endpoint
    final response = await http.post(url, headers: headers, body: json);

    // Handle the response from the backend API endpoint
    if (response.statusCode == 200) {

      final jsonResponse = jsonDecode(response.body);
      qrImageUrl = jsonResponse['data']['qrImage'];
      print(qrImageUrl);
      setState(() {});
    } else {
      print('Error sending QR data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My QR'),
      ),
        body: Center(
          child: qrImageUrl.contains(',')
              ? Image.memory(base64.decode(qrImageUrl.split(',')[1]))
              : Text('QR image is not available'),
        )
    );
  }
}