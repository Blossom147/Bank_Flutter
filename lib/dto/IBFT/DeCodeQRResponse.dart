import 'package:json_annotation/json_annotation.dart';
import 'package:qr/dto/Header/HeaderGW.dart';

part 'DeCodeQRResponse.g.dart';

@JsonSerializable()
class DeCodeQRResponse {
  HeaderGW headerGW;
  Data data;

  DeCodeQRResponse({
    required this.headerGW,
    required this.data,
  });

  factory DeCodeQRResponse.fromJson(Map<String, dynamic> json) => _$DeCodeQRResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeCodeQRResponseToJson(this);
}

@JsonSerializable()
class Data {
  QRInfo qrInfo;
  String responseCode;
  String responseDesc;

  Data(
    this.qrInfo,
    this.responseCode,
    this.responseDesc,
  );

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class QRInfo {
  String serviceCode;
  String customerId;
  String transCurrency;
  String transAmount;
  String countryCode;
  String merchantCode;
  String merchantName;
  String merchantCity;
  String additionInfo;
  String crc;

  QRInfo(
    this.serviceCode,
    this.customerId,
    this.transCurrency,
    this.transAmount,
    this.countryCode,
    this.merchantCode,
    this.merchantName,
    this.merchantCity,
    this.additionInfo,
    this.crc,
  );

  factory QRInfo.fromJson(Map<String, dynamic> json) => _$QRInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QRInfoToJson(this);
}
