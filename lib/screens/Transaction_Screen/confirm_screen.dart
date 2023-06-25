
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr/api_service/api_service.dart';
import 'dart:convert';
import '../../constant/CommonConstant.dart';
import '../TransactionInfo_Page/TransactionDetails_Page/QRPUSH_details.dart';
import '../TransactionInfo_Page/amount_input.dart';
import '../TransactionInfo_Page/recipient_info.dart';
import 'notification_screen.dart';

class ConfirmationScreen  extends StatefulWidget {
  final String customerId;
  final String bank;
  final String billNumber;
  final String amount;

  const ConfirmationScreen({
    Key? key,
    required this.customerId,
    required this.bank,
    required this.billNumber,
    required this.amount,
  }) : super(key: key);


  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}


class _ConfirmationScreenState extends State<ConfirmationScreen> {

  late String customerId;
  late String bank;
  late String billNumber;
  late String amount;
  APIService apiService = APIService();
  @override
  void initState() {
    super.initState();
        customerId = widget.customerId;
        bank = widget.bank;
        billNumber = widget.billNumber;
        amount = widget.amount;
  }

  void sendPayment() async {
    final List<String> userData = await apiService.loadUserData();
    final String fullName = userData[0];

    final url = Uri.parse(CommonConstant.apiUriSendPayment);

    // Define the headers for the HTTP request
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final json = jsonEncode({
      "header": {
        "bkCd": CommonConstant.BANK_CODE,
        "brCd": CommonConstant.CITY_CODE,
        "trnDt": CommonConstant.TRANSACTION_DATE,
        "direction": CommonConstant.DIRECTION_OUTBOUND,
        "reqResGb": CommonConstant.REQ_GB,
        "refNo": CommonConstant.REFERENCE_NUMBER,
        "errCode": null,
        "errDesc": null
      },
      "data": {
        "fundingReference": CommonConstant.REFERENCE_NUMBER,
        "payment": {
          "channel": "M",
          "location":"VietNam",
          "locationDateTime":CommonConstant.LOCAL_DATETIME,
          "interbankAmount": "999000",
          "interbankCurrency":CommonConstant.CURRENCY,
          "exchangeRate":"1",
          "deviceId":"IPOERF3123",
          "payRefNo":CommonConstant.REFERENCE_NUMBER,
          "trace":CommonConstant.REFERENCE_NUMBER
        },
        "participant": {
          "receivingInstitutionId": bank
        },
        "senderAccount": customerId,
        "sender": {
          "fullName": fullName,
          "address": {
            "line1":"Thuong Tin ",
            "line2":"Ha Noi"
          },
          "country":CommonConstant.COUNTRY_NAME,
          "phone": "0332067676"
        },
        "recipientAccount": customerId,
        "recipient": {
          "fullName": "NGUYEN VAN AN",
          "address": {
            "line1":"Quoc Oai",
            "line2":"Ha Noi"
          }
        },
        "amount": amount,
        "currency": CommonConstant.CURRENCY,
        "additionMessage": "THANH TOAN",
        "order": {
          "billNumber": billNumber
        }
      }
    });


    try {
      // Gửi request HTTP tới backend
      final response = await http.post(url, headers: headers, body: json);

      // Xử lý response từ backend
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        debugPrint('Success sending');
        debugPrint('jsonResponseQR: $jsonResponse');
      } else {
        print('Error sending QR data: ${response.statusCode}');
      }
    } catch(e) {

      debugPrint('error: $e ');
      // Xử lý exception ở đây
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xác nhận giao dịch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Thông tin người nhận

              SizedBox(height: 26),
              RecipientInfo(
                accountId:customerId,
                recipientName: 'Nguyễn Văn B',
                bankName: bank,
              ),

              // THông tin giao dịch
              SizedBox(height: 26),
              Text(
                'Thông tin giao dịch',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),


              SizedBox(height: 14),

              QRPUSHDetails(
                service: '',
                bill: billNumber,
                amount: formatCurrency(amount),
                currency: 'VNĐ',
                initialContent: 'THANH TOAN',
                onChanged: (value) {
                  setState(() {
                    amount = value.replaceAll(RegExp(r'[^0-9]'), '');
                  });
                },
              ),

              SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sendPayment();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  child: Text('Xác nhận'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}