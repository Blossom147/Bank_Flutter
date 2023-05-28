import 'package:flutter/material.dart';


class RecipientInfo extends StatelessWidget {
  final String accountId;
  final String recipientName;
  final String bankName;

  RecipientInfo({required this.accountId, required this.recipientName, required this.bankName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin người nhận',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tài khoản thụ hưởng:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Expanded(
                child: TextFormField(
                  initialValue: accountId,
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
                  onChanged: (value) {
                    // Handle value change here
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 14),
        Row( children: [
          Expanded(
            child: Text(
              'Tên người thụ hưởng:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 14),
          Expanded(
            child: TextFormField(
              initialValue: recipientName,
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
              onChanged: (value) {
                // Handle value change here
              },
              enabled: false,
            ),
          ),
        ],
        ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ngân hàng thụ hưởng:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Expanded(
                child: TextFormField(
                  initialValue: bankName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0),
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
                  onChanged: (value) {
// Handle value change here
                  },
                  enabled: false,
                ),
              ),
            ],
          ),
        ],
    );
  }
}