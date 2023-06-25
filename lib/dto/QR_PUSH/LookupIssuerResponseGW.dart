import 'package:json_annotation/json_annotation.dart';
import 'package:qr/dto/Header/HeaderGW.dart';


part 'LookupIssuerResponseGW.g.dart';

@JsonSerializable()
class LookupIssuerResponseGW {
  final HeaderGW headerGW;

  final Data data;

  LookupIssuerResponseGW({
    required this.headerGW,
    required this.data,});

  factory LookupIssuerResponseGW.fromJson(Map<String, dynamic> json) =>
      _$LookupIssuerResponseGWFromJson(json);

  Map<String, dynamic> toJson() => _$LookupIssuerResponseGWToJson(this);
}

@JsonSerializable()
class Data {
  final String responseCode;

  final String responseDesc;

  final String? fundingReference;

  final Payment? payment;

  final String? amount;

  final String? currency;

  final Participant? participant;

  final String? recipientAccount;

  final Recipient? recipient;

  final Order? order;

  Data({
    required this.responseCode,
    required this.responseDesc,
    this.fundingReference,
    this.payment,
    this.amount,
    this.currency,
    this.participant,
    this.recipientAccount,
    this.recipient,
    this.order,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Participant {
  final String merchantId;

  final String? receivingInstitutionId;

  final String? merchantCategoryCode;

  final String cardAcceptorId;

  final String cardAcceptorCountry;

  final String cardAcceptorName;

  final String cardAcceptorCity;

  Participant({
    required this.merchantId,
    this.receivingInstitutionId,
    this.merchantCategoryCode,
    required this.cardAcceptorId,
    required this.cardAcceptorCountry,
    required this.cardAcceptorName,
    required this.cardAcceptorCity,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}

@JsonSerializable()
class Recipient {
  final String fullName;

  final String? dob;

  final Address? address;

  Recipient({
    required this.fullName,
    this.dob,
    this.address,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}

@JsonSerializable()
class Address {
  final String? line1;

  final String? line2;

  final String country;

  final String phone;

  Address({
    this.line1,
    this.line2,
    required this.country,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Order {
  final String billNumber;

  final String? mobileNumber;

  final String? storeLable;

  final String? loyaltyNumber;

  final String? referenceLabel;

  final String? customerLabel;

  final String? terminalLabel;

  final String? purposeOfTrans;

  final String? additionCosumerData;

  Order({
    required this.billNumber,
    this.mobileNumber,
    this.storeLable,
    this.loyaltyNumber,
    this.referenceLabel,
    this.customerLabel,
    this.terminalLabel,
    this.purposeOfTrans,
    this.additionCosumerData,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class Payment {
  final String? generationMethod;

  final String? indicator;

  final String trace;

  final String? exchangeRate;

  final String? feeFixed;

  final String? feePercentage;

  final String payRefNo;

  Payment({
    this.generationMethod,
    this.indicator,
    required this.trace,
    this.exchangeRate,
    this.feeFixed,
    this.feePercentage,
    required this.payRefNo,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
