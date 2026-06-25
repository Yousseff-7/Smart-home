class AIPredictionModel {

  final String deviceType;
  final String status;
  final String state;
  final String recommendation;

  AIPredictionModel({
    required this.deviceType,
    required this.status,
    required this.state,
    required this.recommendation,
  });

  factory AIPredictionModel.fromJson(
      Map<String,dynamic> json){

    return AIPredictionModel(

      deviceType:
      json["device_type"] ?? "",

      status:
      json["status"] ?? "",

      state:
      json["state"] ?? "",

      recommendation:
      json["recommendation"] ?? "",
    );
  }
}