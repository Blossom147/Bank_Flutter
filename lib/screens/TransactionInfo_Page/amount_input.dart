import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../Transaction_Screen/IBFT_screen.dart';

class AmountInput extends StatelessWidget {
  final String? amount;
  final ValueChanged<String> onChanged;

  AmountInput({this.amount, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

    Row(
      children: [
        Expanded(
          child: Text(
            'Số tiền:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 14),
        Expanded(
          child: TextFormField(
            initialValue: amount,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            ),

            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsSeparatorInputFormatter(),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
        ),
      ],
    );
  }
}
String formatCurrency(String? value) {
  if (value == null) {
    return '';
  }
  final formatter = NumberFormat('#,###');
  return formatter.format(int.parse(value));
}