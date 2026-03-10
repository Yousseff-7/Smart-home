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

class _DashboardChartsPageState extends State<DashboardChartsPage>
    with TickerProviderStateMixin {
  int selectedTab = 0;

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
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon( Icons.arrow_back_ios_new_rounded)),
        title: const Text(
          "Live Sensors Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),

      body: Expanded(
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// -----------  TABS (Current / Voltage / Power) -------------

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
                          color:
                          isActive ? colors[index] : Colors.white12,
                          width: isActive ? 1.4 : 0.7,
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isActive ? colors[index] : Colors.white70,
                          fontSize: 15,
                          fontWeight:
                          isActive ? FontWeight.bold : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),


            const SizedBox(height: 20),

            /// -----------  ACTIVE CHART  ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildChartCard(
                  title: tabs[selectedTab],
                  values: dataSets[selectedTab],
                  color: colors[selectedTab],
                  key: ValueKey(selectedTab),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --------------------- Chart Card -----------------------
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
        color: Colors.black26,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            "$title Chart",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          /// Chart
          SizedBox(
            height: 500,
            child: LineChartWidget(values: values, color: color),
          ),
        ],
      ),
    );
  }
}

//
// ================== LINE CHART WIDGET ======================
//
class LineChartWidget extends StatelessWidget {
  final List<double> values;
  final Color color;

  const LineChartWidget({super.key, required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    final maxY = values.reduce((a, b) => a > b ? a : b) + 5;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (values.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,

        gridData: FlGridData(
          show: true,
          horizontalInterval: maxY / 5,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white12,
            strokeWidth: 1,
          ),
        ),

        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (v, meta) => Text(
                v.toInt().toString(),
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5,
              getTitlesWidget: (v, meta) => Text(
                v.toInt().toString(),
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
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
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.4),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
