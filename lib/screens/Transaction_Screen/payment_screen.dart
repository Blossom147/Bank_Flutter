import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr/constant/CommonConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_service/api_service.dart';
import '../../dto/QR_PUSH/LookupIssuerResponseGW.dart';
import '../TransactionInfo_Page/TransactionDetails_Page/QRPUSH_details.dart';
import '../TransactionInfo_Page/amount_input.dart';
import '../TransactionInfo_Page/recipient_info.dart';
import '../TransactionInfo_Page/sender_info.dart';
import 'confirm_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? jsonResponse;
  final String bank;
  const PaymentScreen({
    Key? key,
    required this.jsonResponse, required this.bank,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final LookupIssuerResponseGW? _decodedQR;
  late String fullName;
  late String accountNumber;
  late String customerId;
  late String billNumber;
  late String amount;
  late String bank;
  late String additionInfo;
  bool isAmountSet = false;

  APIService apiService = APIService();

  @override
  void initState() {
    super.initState();
    bank = widget.bank;
    if (widget.jsonResponse != null) {
      _decodedQR = LookupIssuerResponseGW.fromJson(widget.jsonResponse!);

      // Lấy các thông tin từ chuỗi Json
      if (widget.jsonResponse!['data'] != null ) {

        amount = widget.jsonResponse!['data']['amount'];
        customerId = widget.jsonResponse!['data']['participant']['cardAcceptorId'];
        billNumber = widget.jsonResponse!['data']['order']['billNumber'];
        // additionInfo = widget.jsonResponse!['data']['qrInfo']['additionInfo'];
      }
    }
    _loadCounter();
  }
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? fullName;
      accountNumber = prefs.getString('accountNumber') ?? accountNumber;
    });
  }

  String formatNumber(String number) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(int.parse(number));
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
                'Gửi tiền',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 36),

              // Thông tin người gửi

              SenderInfo(
                accountNumber: accountNumber,
                fullName: fullName,
              ),

              // Thông tin người nhận

              SizedBox(height: 26),
              RecipientInfo(
                accountId: customerId,
                recipientName: 'Nguyễn Văn B',
                bankName: widget.bank,
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


              SizedBox(height: 14),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(

                          customerId: customerId,
                          bank: bank,
                          billNumber: billNumber,
                          amount: amount,
                        ),
                      ),
                    );
                  },
                  child: Text('Chuyển khoản'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final intValue = int.parse(cleanText);

    final newValueWithSeparator =
    NumberFormat.decimalPattern().format(intValue);

    return newValue.copyWith(
      text: newValueWithSeparator,
      selection: TextSelection.collapsed(offset: newValueWithSeparator.length),
    );
  }
}

String formatCurrency(String? value) {
  if (value == null) {
    return '';
  }

  final cleanText = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (cleanText.isEmpty) {
    return '';
  }

  final intValue = int.parse(cleanText);

  final formatter = NumberFormat.decimalPattern();
  return formatter.format(intValue);
}
