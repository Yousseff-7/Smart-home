class AlertModel {
  final String deviceType;
  final String status;
  final String recommendation;

  final double power;
  final double energy;
  final int duration;

  AlertModel({
    required this.deviceType,
    required this.status,
    required this.recommendation,
    required this.power,
    required this.energy,
    required this.duration,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      deviceType: json['device_type'] ?? "",
      status: json['status'] ?? "",
      recommendation: json['recommendation'] ?? "",
      power: (json['power_w'] ?? 0).toDouble(),
      energy: (json['energy_kwh'] ?? 0).toDouble(),
      duration: json['duration_min'] ?? 0,
    );
  }
}