import 'package:intl/intl.dart';
import 'dart:math';

class CommonConstant {
  static String ipv4 = '192.168.1.243';
  //10.100.104.240
  //192.168.1.243
  static final String apiUrlSendLoginReq = "http://"+ ipv4 +":8080/infogw/qr/v1/oauth/token";
  static final String apiUrlGetDataUser = "http://"+ ipv4 +":8080/infogw/qr/v1/getUser/";
  static final String apiUrlGenQR = "http://"+ ipv4 +":8080/infogw/qr/v1/genQR";
  static final String apiReadQR = "http://"+ ipv4 +":8080/infogw/qr/v1/readQR";
  static final String apiGetBankName = "http://"+ ipv4 +":8080/infogw/qr/v1/getBank/";
  static final String apiUriReadQRLookUp = "http://"+ ipv4 +":8080/infogw/qr/v1/issuer/lookup";
  static final String apiUriSendPayment = "http://"+ ipv4 +":8080/infogw/qr/v1/issuer/payment";

  static final List<String> listServiceCode = ['QRPUSH', 'QRCASH', 'QRIBFTTC', 'QRIBFTTA', 'QRADVERTISE'];
  static final String DIRECTION_OUTBOUND = "O";
  static final String DIRECTION_INBOUND = "I";
  static final String TRANS_CURRENCY = "704";
  static final String BANK_CODE = "970467";
  static final String COUNTRY_CODE = "VN";
  static final String COUNTRY_NAME = "VietNam";
  static final String CURRENCY = "VND";
  static final String CITY_CODE = "HN";
  static late String TRANSACTION_DATE = genTrnDt();
  static late String REFERENCE_NUMBER = genRefNo(TRANSACTION_DATE);
  static late String LOCAL_DATETIME = getCurrentDateTime();
  static final String RES_GB = "RES";
  static final String REQ_GB = "REQ";
  static final String BANK_NAME = "KEBHANABANK";

  CommonConstant() {
    TRANSACTION_DATE = genTrnDt();
    REFERENCE_NUMBER = genRefNo(genTrnDt());
  }

  static String genTrnDt() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    return formattedDate;
  }
  static String genRefNo(String date) {

    BigInt randomNumber = BigInt.parse(Random().nextInt(1000000000).toString());
    String formattedNumber = randomNumber.toString().padLeft(11, '0');

    return date + formattedNumber;
  }
  static String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now);
    return formattedDateTime;
  }
}

