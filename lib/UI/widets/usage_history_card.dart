import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final Map data;

  const HistoryCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String status = data["aiPrediction"]?["status"] ?? "normal";

    final Color statusColor =
    status == "anomaly" ? Colors.red : Colors.green;

    final IconData statusIcon =
    status == "anomaly"
        ? Icons.warning_amber_rounded
        : Icons.check_circle;

    final DateTime date =
    DateTime.parse(data["createdAt"]).toLocal();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: statusColor.withOpacity(.15),
            child: Icon(
              statusIcon,
              color: statusColor,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Device name + time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data["deviceName"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// Voltage / Current / Power
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        Icons.bolt,
                        "Voltage",
                        "${data["voltage"]} V",
                        Colors.orange,
                      ),
                    ),
                    Expanded(
                      child: _infoTile(
                        Icons.electric_meter,
                        "Current",
                        "${data["current"]} A",
                        Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: _infoTile(
                        Icons.flash_on,
                        "Power",
                        "${data["power"]} W",
                        Colors.amber,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// Status + Temperature + Humidity
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      avatar: Icon(
                        statusIcon,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        status == "anomaly"
                            ? "Warning"
                            : "Normal",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: statusColor,
                    ),

                    if (data["temperature"] != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.thermostat,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text("${data["temperature"]}°"),
                        ],
                      ),

                    if (data["humidity"] != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text("${data["humidity"]}%"),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Widget _infoTile(
    IconData icon,
    String title,
    String value,
    Color color,
    ) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}