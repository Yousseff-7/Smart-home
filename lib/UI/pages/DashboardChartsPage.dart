import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChartsPage extends StatefulWidget {
  final List<double> currentValues;
  final List<double> voltageValues;
  final List<double> powerValues;

  const DashboardChartsPage({
    super.key,
    required this.currentValues,
    required this.voltageValues,
    required this.powerValues,
  });

  @override
  State<DashboardChartsPage> createState() => _DashboardChartsPageState();
}

class _DashboardChartsPageState extends State<DashboardChartsPage> {
  int selectedTab = 0;
  int selectedTime = 2; // 👈 Month default

  @override
  Widget build(BuildContext context) {
    final tabs = ["Current", "Voltage", "Power"];

    final dataSets = [
      widget.currentValues,
      widget.voltageValues,
      widget.powerValues,
    ];

    final colors = [
      Colors.cyan,
      Colors.orange,
      Colors.pinkAccent,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text(
          "Live Sensors Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 15),

            /// ================= CONSUMPTION HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Consumption",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 TIME FILTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      final tabs = ["Today", "Week", "Month", "Year"];
                      final isSelected = selectedTime == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF59E0B)
                                : Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFF59E0B)
                                  : Colors.white12,
                            ),
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// ================= CONSUMPTION CHART =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 300,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            const months = ["Jan", "Feb", "Mar", "Apr", "May"];
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.cyan,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        spots: const [
                          FlSpot(0, 120),
                          FlSpot(1, 150),
                          FlSpot(2, 218),
                          FlSpot(3, 200),
                          FlSpot(4, 170),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= TABS (UNCHANGED) =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  final bool isActive = selectedTab == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedTab = index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? colors[index].withOpacity(0.2)
                            : Colors.black26,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isActive
                              ? colors[index]
                              : Colors.white12,
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isActive
                              ? colors[index]
                              : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= ACTIVE CHART =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _buildChartCard(
                  title: tabs[selectedTab],
                  values: dataSets[selectedTab],
                  color: colors[selectedTab],
                  key: ValueKey(selectedTab),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required List<double> values,
    required Color color,
    required Key key,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title Chart",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: LineChartWidget(values: values, color: color),
          ),
        ],
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> values;
  final Color color;

  const LineChartWidget({
    super.key,
    required this.values,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final maxY = values.reduce((a, b) => a > b ? a : b) + 5;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (values.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) => Text(
                v.toInt().toString(),
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: values
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: color,
            barWidth: 3,
          ),
        ],
      ),
    );
  }
}