import 'package:flutter/material.dart';

import '../../services/usage_history_service.dart';



class UsageHistoryPage extends StatefulWidget {

  const UsageHistoryPage({super.key});


  @override
  State<UsageHistoryPage> createState() => _UsageHistoryPageState();
}

class _UsageHistoryPageState extends State<UsageHistoryPage> {

  final UsageHistoryService service =
  UsageHistoryService();

  List history = [];

  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadHistory();
  }
  Future<void> loadHistory() async {
    try {
      history = await service.getHistory();

      print("HISTORY = $history");
      print("COUNT = ${history.length}");

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print("ERROR = $e");

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Usage History"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// SUMMARY
            Text(
              "Today's Summary",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.7,
              children: [

                _summaryCard(
                  icon: Icons.bolt,
                  title: "Energy",
                  value: "3.2 kWh",
                  color: Colors.orange,
                ),

                _summaryCard(
                  icon: Icons.flash_on,
                  title: "Avg Power",
                  value: "82 W",
                  color: Colors.amber,
                ),

                _summaryCard(
                  icon: Icons.history,
                  title: "Readings",
                  value: "${history.length}",
                  color: Colors.blue,
                ),

                _summaryCard(
                  icon: Icons.warning_amber_rounded,
                  title: "Alerts",
                  value: history
                      .where((e) =>
                  e["aiPrediction"]?["status"] == "anomaly")
                      .length
                      .toString(),
                  color: Colors.red,
                ),

              ],
            ),

            const SizedBox(height: 25),

            _buildEnergyStatus(),

            const SizedBox(height: 20),

            _buildRecommendation(),

            const SizedBox(height: 25),

            Text(
              "History",
              style: theme.textTheme.titleLarge,
            ),

            Expanded(

              child: loading

                  ? const Center(
                child: CircularProgressIndicator(),
              )

                  : ListView.builder(

                itemCount: history.length,

                itemBuilder: (context, index) {

                  return Padding(

                    padding: const EdgeInsets.only(bottom: 15),

                    child: HistoryCard(

                      data: history[index],

                    ),

                  );

                },

              ),

            ),

          ],

        ),

      ),

    );
  }

  Widget _summaryItem(
      String value,
      String title,
      ) {
    return Column(

      children: [

        Text(

          value,

          style: const TextStyle(

            fontSize: 22,

            fontWeight: FontWeight.bold,

          ),

        ),

        const SizedBox(height: 6),

        Text(title),

      ],

    );
  }
  Widget _buildRecommendation() {

    String recommendation =
        "Everything is operating normally.";

    for (var item in history) {

      if (item["aiPrediction"] != null) {

        recommendation =
        item["aiPrediction"]["recommendation"];

        break;

      }

    }

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(20),

      ),

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          CircleAvatar(

            backgroundColor:
            Colors.blue.withOpacity(.15),

            child: const Icon(

              Icons.psychology,

              color: Colors.blue,

            ),

          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  "AI Recommendation",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                const SizedBox(height: 8),

                Text(recommendation),

              ],

            ),

          ),

        ],

      ),

    );

  }
  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(.4),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: color,
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),

        ],
      ),
    );
  }
  Widget _buildEnergyStatus() {

    int alerts = history.where(
          (e) => e["aiPrediction"]?["status"] == "anomaly",
    ).length;

    Color color = Colors.green;
    IconData icon = Icons.check_circle;
    String title = "Excellent";
    String message = "Your energy consumption is normal.";

    if (alerts > 0) {

      color = Colors.orange;

      icon = Icons.warning_amber_rounded;

      title = "Attention";

      message =
      "$alerts abnormal reading(s) detected today.";

    }

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(20),

      ),

      child: Row(

        children: [

          CircleAvatar(

            radius: 28,

            backgroundColor: color.withOpacity(.15),

            child: Icon(
              icon,
              color: color,
            ),

          ),

          const SizedBox(width: 18),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(

                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                const SizedBox(height: 5),

                Text(
                  message,
                ),

              ],

            ),

          ),

        ],

      ),

    );

  }
}

class HistoryCard extends StatelessWidget {

  final Map data;

  const HistoryCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    String status =
        data["aiPrediction"]?["status"] ?? "normal";

    Color statusColor =
    status == "anomaly"
        ? Colors.red
        : Colors.green;

    IconData statusIcon =
    status == "anomaly"
        ? Icons.warning_amber_rounded
        : Icons.check_circle;

    DateTime date =
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

            backgroundColor:
            statusColor.withOpacity(.15),

            child: Icon(
              statusIcon,
              color: statusColor,
            ),

          ),

          const SizedBox(width: 18),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    Expanded(

                      child: Text(

                        data["deviceName"],

                        style: const TextStyle(

                          fontSize: 18,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                    ),

                    Text(

                      "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",

                      style: TextStyle(

                        color: Colors.grey.shade500,

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 15),

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

                Row(

                  children: [

                    Chip(

                      avatar: Icon(

                        statusIcon,

                        size: 18,

                        color: Colors.white,

                      ),

                      label: Text(

                        status == "anomaly"
                            ? "Warning"
                            : "Normal",

                        style: const TextStyle(

                          color: Colors.white,

                        ),

                      ),

                      backgroundColor:
                      statusColor,

                    ),

                    const Spacer(),

                    if (data["temperature"] != null)

                      Row(

                        children: [

                          const Icon(
                            Icons.thermostat,
                            color: Colors.red,
                          ),

                          Text(
                              "${data["temperature"]}°"),

                          const SizedBox(width: 12),

                          const Icon(
                            Icons.water_drop,
                            color: Colors.blue,
                          ),

                          Text(
                              "${data["humidity"]}%"),

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

  Widget _infoTile(

      IconData icon,

      String title,

      String value,

      Color color,

      ) {

    return Column(

      children: [

        Icon(
          icon,
          color: color,
        ),

        const SizedBox(height: 5),

        Text(

          value,

          style: const TextStyle(

            fontWeight: FontWeight.bold,

          ),

        ),

        Text(

          title,

          style: const TextStyle(

            fontSize: 12,

          ),

        ),

      ],

    );

  }

}