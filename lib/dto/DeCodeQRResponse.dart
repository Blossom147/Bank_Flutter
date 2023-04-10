class DeCodeQRResponse {
  String qrString;
  String channel;

  DeCodeQRResponse({required this.qrString, required this.channel});

  factory DeCodeQRResponse.fromJson(Map<String, dynamic> json) {
    return DeCodeQRResponse(
      qrString: json['data']['qrString'],
      channel: json['data']['channel'],
    );
  }
}
