import 'package:json_annotation/json_annotation.dart';

part 'HeaderGW.g.dart';


@JsonSerializable()
class HeaderGW {
  String bkCd;
  String brCd;
  String trnDt;
  String direction;
  String reqResGb;
  String refNo;
  String errCode;
  String errDesc;

  HeaderGW(
    this.bkCd,
    this.brCd,
    this.trnDt,
    this.direction,
    this.reqResGb,
    this.refNo,
    this.errCode,
    this.errDesc,
  );

  factory HeaderGW.fromJson(Map<String, dynamic> json) => _$HeaderGWFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderGWToJson(this);
}
