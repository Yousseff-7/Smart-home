class UsageHistoryModel {
  final String id;
  final String deviceId;
  final double voltage;
  final double current;
  final double power;
  final double temperature;
  final double humidity;
  final String status;
  final DateTime createdAt;

  UsageHistoryModel({
    required this.id,
    required this.deviceId,
    required this.voltage,
    required this.current,
    required this.power,
    required this.temperature,
    required this.humidity,
    required this.status,
    required this.createdAt,
  });

  factory UsageHistoryModel.fromJson(Map<String, dynamic> json) {
    return UsageHistoryModel(
      id: json["_id"] ?? "",
      deviceId: json["deviceId"] ?? "",
      voltage: (json["voltage"] ?? 0).toDouble(),
      current: (json["current"] ?? 0).toDouble(),
      power: (json["power"] ?? 0).toDouble(),
      temperature: (json["temperature"] ?? 0).toDouble(),
      humidity: (json["humidity"] ?? 0).toDouble(),
      status:
      json["aiPrediction"]?["status"] ??
          json["status"] ??
          "normal",
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}