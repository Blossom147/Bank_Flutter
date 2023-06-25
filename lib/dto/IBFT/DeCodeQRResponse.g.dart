// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DeCodeQRResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeCodeQRResponse _$DeCodeQRResponseFromJson(Map<String, dynamic> json) =>
    DeCodeQRResponse(
      headerGW: HeaderGW.fromJson(json['headerGW'] as Map<String, dynamic>),
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeCodeQRResponseToJson(DeCodeQRResponse instance) =>
    <String, dynamic>{
      'headerGW': instance.headerGW,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      QRInfo.fromJson(json['qrInfo'] as Map<String, dynamic>),
      json['responseCode'] as String,
      json['responseDesc'] as String,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'qrInfo': instance.qrInfo,
      'responseCode': instance.responseCode,
      'responseDesc': instance.responseDesc,
    };

QRInfo _$QRInfoFromJson(Map<String, dynamic> json) => QRInfo(
      json['serviceCode'] as String? ?? '',
      json['customerId'] as String? ?? '',
      json['transCurrency'] as String? ?? '',
      json['transAmount'] as String? ?? '',
      json['countryCode'] as String? ?? '',
      json['merchantCode'] as String? ?? '',
      json['merchantName'] as String? ?? '',
      json['merchantCity'] as String? ?? '',
      json['additionInfo'] as String? ?? '',
      json['crc'] as String,
    );

Map<String, dynamic> _$QRInfoToJson(QRInfo instance) => <String, dynamic>{
      'serviceCode': instance.serviceCode,
      'customerId': instance.customerId,
      'transCurrency': instance.transCurrency,
      'transAmount': instance.transAmount,
      'countryCode': instance.countryCode,
      'merchantCode': instance.merchantCode,
      'merchantName': instance.merchantName,
      'merchantCity': instance.merchantCity,
      'additionInfo': instance.additionInfo,
      'crc': instance.crc,
    };
