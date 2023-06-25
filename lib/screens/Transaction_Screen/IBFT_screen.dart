import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../../dto/IBFT/DeCodeQRResponse.dart';
import '../TransactionInfo_Page/TransactionDetails_Page/IBFT_details.dart';
import '../TransactionInfo_Page/amount_input.dart';
import '../TransactionInfo_Page/recipient_info.dart';
import '../TransactionInfo_Page/sender_info.dart';

class IBFTScreen extends StatefulWidget {
  final Map<String, dynamic>? jsonResponse;
  final String bank;

  const IBFTScreen({
    Key? key,
    required this.jsonResponse, required this.bank,
  }) : super(key: key);

  @override
  _IBFTScreenState createState() => _IBFTScreenState();
}

class _IBFTScreenState extends State<IBFTScreen> {
  late final DeCodeQRResponse? _decodedQR;
  late String fullName;
  late String accountNumber;
  late String customerId;
  late String amount;
  late String additionInfo;
  late String bank = widget.bank;

  bool isAmountSet = false;

  @override
  void initState() {
    super.initState();

    if (widget.jsonResponse != null) {
      _decodedQR = DeCodeQRResponse.fromJson(widget.jsonResponse!);

      // Kiểm tra trường 'customerId' có tồn tại không
      if (widget.jsonResponse!['data'] != null &&
          widget.jsonResponse!['data']['qrInfo'] != null) {
        final transAmount =
        widget.jsonResponse?['data']['qrInfo']['transAmount'];
        amount = transAmount != null ? transAmount.toString() : '';
        customerId = widget.jsonResponse!['data']['qrInfo']['customerId'];
        additionInfo = widget.jsonResponse!['data']['qrInfo']['additionInfo']?? '';
        if (amount == null) {
          isAmountSet = false;
        } else {
          isAmountSet = true;
        }
      } else {
        debugPrint('data null');
      }
    } else {
      debugPrint('json null');
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
              // Phần giao diện số tiền
              if (amount == null)
                AmountInput(
                  amount: null,
                  onChanged: (value) {
                    setState(() {
                      amount = value;
                    });
                  },
                )
              else
                AmountInput(
                  amount: formatCurrency(amount),
                  onChanged: (value) {
                    setState(() {
                      amount = value.replaceAll(RegExp(r'[^0-9]'), '');
                    });
                  },
                ),

              SizedBox(height: 14),

              IBFTDetails(
                currency: 'VNĐ',
                initialContent: additionInfo,
              ),


              SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Xác nhận'),
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
