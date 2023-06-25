import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountInput extends TextInputFormatter{
  String formatCurrency(String? value) {
    if (value == null) {
      return '';
    }
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(value));
  }

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