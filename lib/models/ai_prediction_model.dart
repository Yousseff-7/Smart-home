class AIPredictionModel {

  final String status;
  final String state;
  final String recommendation;

  AIPredictionModel({

    required this.status,
    required this.state,
    required this.recommendation,

  });

  factory AIPredictionModel.fromJson(
      Map<String, dynamic> json) {

    return AIPredictionModel(

      status:
      json["status"] ?? "",

      state:
      json["state"] ?? "",

      recommendation:
      json["recommendation"] ?? "",

    );

  }

}