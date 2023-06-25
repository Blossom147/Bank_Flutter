// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LookupIssuerResponseGW.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupIssuerResponseGW _$LookupIssuerResponseGWFromJson(
        Map<String, dynamic> json) =>
    LookupIssuerResponseGW(
      headerGW: HeaderGW.fromJson(json['headerGW'] as Map<String, dynamic>),
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LookupIssuerResponseGWToJson(
        LookupIssuerResponseGW instance) =>
    <String, dynamic>{
      'headerGW': instance.headerGW,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      responseCode: json['responseCode'] as String,
      responseDesc: json['responseDesc'] as String,
      fundingReference: json['fundingReference'] as String?,
      payment: json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
      amount: json['amount'] as String?,
      currency: json['currency'] as String?,
      participant: json['participant'] == null
          ? null
          : Participant.fromJson(json['participant'] as Map<String, dynamic>),
      recipientAccount: json['recipientAccount'] as String?,
      recipient: json['recipient'] == null
          ? null
          : Recipient.fromJson(json['recipient'] as Map<String, dynamic>),
      order: json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'responseCode': instance.responseCode,
      'responseDesc': instance.responseDesc,
      'fundingReference': instance.fundingReference,
      'payment': instance.payment,
      'amount': instance.amount,
      'currency': instance.currency,
      'participant': instance.participant,
      'recipientAccount': instance.recipientAccount,
      'recipient': instance.recipient,
      'order': instance.order,
    };

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      merchantId: json['merchantId'] as String,
      receivingInstitutionId: json['receivingInstitutionId'] as String? ?? '',
      merchantCategoryCode: json['merchantCategoryCode'] as String? ?? '',
      cardAcceptorId: json['cardAcceptorId'] as String? ?? '',
      cardAcceptorCountry: json['cardAcceptorCountry'] as String? ?? '',
      cardAcceptorName: json['cardAcceptorName'] as String? ?? '',
      cardAcceptorCity: json['cardAcceptorCity'] as String? ?? '',
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'merchantId': instance.merchantId,
      'receivingInstitutionId': instance.receivingInstitutionId,
      'merchantCategoryCode': instance.merchantCategoryCode,
      'cardAcceptorId': instance.cardAcceptorId,
      'cardAcceptorCountry': instance.cardAcceptorCountry,
      'cardAcceptorName': instance.cardAcceptorName,
      'cardAcceptorCity': instance.cardAcceptorCity,
    };

Recipient _$RecipientFromJson(Map<String, dynamic> json) => Recipient(
      fullName: json['fullName'] as String,
      dob: json['dob'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecipientToJson(Recipient instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'dob': instance.dob,
      'address': instance.address,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      line1: json['line1'] as String?,
      line2: json['line2'] as String?,
      country: json['country'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'line1': instance.line1,
      'line2': instance.line2,
      'country': instance.country,
      'phone': instance.phone,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      billNumber: json['billNumber'] as String,
      mobileNumber: json['mobileNumber'] as String?,
      storeLable: json['storeLable'] as String?,
      loyaltyNumber: json['loyaltyNumber'] as String?,
      referenceLabel: json['referenceLabel'] as String?,
      customerLabel: json['customerLabel'] as String?,
      terminalLabel: json['terminalLabel'] as String?,
      purposeOfTrans: json['purposeOfTrans'] as String?,
      additionCosumerData: json['additionCosumerData'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'billNumber': instance.billNumber,
      'mobileNumber': instance.mobileNumber,
      'storeLable': instance.storeLable,
      'loyaltyNumber': instance.loyaltyNumber,
      'referenceLabel': instance.referenceLabel,
      'customerLabel': instance.customerLabel,
      'terminalLabel': instance.terminalLabel,
      'purposeOfTrans': instance.purposeOfTrans,
      'additionCosumerData': instance.additionCosumerData,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      generationMethod: json['generationMethod'] as String? ?? '',
      indicator: json['indicator'] as String? ?? '',
      trace: json['trace'] as String? ?? '',
      exchangeRate: json['exchangeRate'] as String? ?? '',
      feeFixed: json['feeFixed'] as String? ?? '',
      feePercentage: json['feePercentage'] as String? ?? '',
      payRefNo: json['payRefNo'] as String? ?? '',
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'generationMethod': instance.generationMethod,
      'indicator': instance.indicator,
      'trace': instance.trace,
      'exchangeRate': instance.exchangeRate,
      'feeFixed': instance.feeFixed,
      'feePercentage': instance.feePercentage,
      'payRefNo': instance.payRefNo,
    };
