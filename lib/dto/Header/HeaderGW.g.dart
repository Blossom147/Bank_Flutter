// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HeaderGW.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaderGW _$HeaderGWFromJson(Map<String, dynamic> json) => HeaderGW(
      json['bkCd'] as String,
      json['brCd'] as String,
      json['trnDt'] as String,
      json['direction'] as String,
      json['reqResGb'] as String,
      json['refNo'] as String,
      json['errCode']  as String? ?? '',
      json['errDesc']  as String? ?? '',
    );

Map<String, dynamic> _$HeaderGWToJson(HeaderGW instance) => <String, dynamic>{
      'bkCd': instance.bkCd,
      'brCd': instance.brCd,
      'trnDt': instance.trnDt,
      'direction': instance.direction,
      'reqResGb': instance.reqResGb,
      'refNo': instance.refNo,
      'errCode': instance.errCode,
      'errDesc': instance.errDesc,
    };
