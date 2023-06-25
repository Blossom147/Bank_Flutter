import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/CommonConstant.dart';

class APIService {

  // API lấy ra thông tin ngân hàng
  Future<Map<String, dynamic>> getDataBank(String bin) async {

    // URL của API login

    final url = Uri.parse(CommonConstant.apiGetBankName+'$bin');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final String bankName =
      utf8.decode(jsonResponse['bankName'].toString().codeUnits);
      final String shortName = jsonResponse['shortName'];
      String bank;

      // Xử lí thông tin về Bank
      final tmcpIndex = bankName.indexOf('TMCP');
      if (tmcpIndex != -1) {
        final substring = bankName.substring(tmcpIndex + 'TMCP'.length).trim();
        // bank = '$substring ($shortName)';
        bank = '$substring';
      } else {
        bank = bankName;
      }// Kết quả: "Tiên Phong (TPB)"

      return {'bankName': bankName, 'shortName': shortName,'bank' : bank};
    } else {
      throw Exception('Failed to load data');
    }
  }

  // API đọc mã QR Lookup
  Future<void> callApiAndNavigate(String qrString,Function(Map<String, dynamic>) callback) async {

    final url = Uri.parse(CommonConstant.apiUriReadQRLookUp);

    // Define the headers for the HTTP request
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Define the body of the HTTP request as a JSON-encoded string
    final json = jsonEncode({
      'headerGW': {
        'bkCd': CommonConstant.BANK_CODE,
        'brCd': CommonConstant.CITY_CODE,
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
        final jsonResponse = jsonDecode(response.body);
        debugPrint('jsonResponseQR: $jsonResponse');

        // Gọi callback function và truyền chuỗi JSON response
        callback(jsonResponse);
      } else {
        print('Error sending QR data: ${response.statusCode}');
      }
    } catch(e) {

      debugPrint('error: $e ');
      // Xử lý exception ở đây
    }
  }

  // Hàm lấy ra các giá trị
  Future<List<String>> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String fullName = prefs.getString('fullName') ?? '';
    final String accountNumber = prefs.getString('accountNumber') ?? '';
    final String username = prefs.getString('username') ?? '';

    return [fullName, accountNumber, username];
  }


  // API tạo mã QR của bản thân

}