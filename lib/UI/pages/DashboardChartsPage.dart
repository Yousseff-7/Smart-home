import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardChartsPage extends StatefulWidget {

  final String deviceId;

  const DashboardChartsPage({
    super.key,
    required this.deviceId,
  });

  @override
  State<DashboardChartsPage> createState() =>
      _DashboardChartsPageState();
}

class _DashboardChartsPageState
    extends State<DashboardChartsPage> {

  int selectedTab = 0;
  int selectedTime = 2;

  bool isLoading = true;

  List<double> currentValues = [];
  List<double> voltageValues = [];
  List<double> powerValues = [];

  double currentNow = 0;
  double voltageNow = 0;
  double powerNow = 0;

  List<double> monthlyPower = [];
  List<double> yearlyPower = [];

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://64.225.101.222:5000/api",
    ),
  );

  @override
  void initState() {
    super.initState();

    loadData();

    print("DEVICE ID = ${widget.deviceId}");
  }

  Future<String> getToken() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";

  }

  Future loadData() async {

    try {

      String token = await getToken();

      /// ================= READINGS =================

      Response readingsResponse =
      await dio.get(

        "/readings/device/${widget.deviceId}",

        options: Options(
          headers: {
            "Authorization":
            "bearer $token",
          },
        ),

      );
      print("DEVICE ID = ${widget.deviceId}");
      print("READINGS = ${readingsResponse.data}");

      Map<String, dynamic> readingsData =
          readingsResponse.data;

      List readings =
          readingsData["readings"] ?? [];
      currentValues =
          readings
              .map<double>(
                (e) =>
                ((e["current"] ?? 0) as num)
                    .toDouble(),
          )
              .toList();

      voltageValues =
          readings
              .map<double>(
                (e) =>
                ((e["voltage"] ?? 0) as num)
                    .toDouble(),
          )
              .toList();

      powerValues =
          readings
              .map<double>(
                (e) =>
                ((e["power"] ?? 0) as num)
                    .toDouble(),
          )
              .toList();

      if(readings.isNotEmpty){

        currentNow =
            ((readings.last["current"] ?? 0)
            as num)
                .toDouble();

        voltageNow =
            ((readings.last["voltage"] ?? 0)
            as num)
                .toDouble();

        powerNow =
            ((readings.last["power"] ?? 0)
            as num)
                .toDouble();

      }

      /// ================= MONTHLY =================

      Response monthlyResponse =
      await dio.get(

        "/stats/monthly?deviceId=${widget.deviceId}&month=2&year=2026",

        options: Options(
          headers: {
            "Authorization":
            "bearer $token",
          },
        ),

      );

      print("MONTHLY = ${monthlyResponse.data}");

      Map<String, dynamic> monthlyData =
          monthlyResponse.data;

      List monthly =
          monthlyData["daily"] ?? [];

      monthlyPower =
          monthly
              .map<double>(
                (e) =>
                ((e["totalPower"] ?? 0)
                as num)
                    .toDouble(),
          )
              .toList();

      /// ================= YEARLY =================

      Response yearlyResponse =
      await dio.get(

        "/stats/yearly?deviceId=${widget.deviceId}&year=2026",

        options: Options(
          headers: {
            "Authorization":
            "bearer $token",
          },
        ),

      );

      print("YEARLY = ${yearlyResponse.data}");

      Map<String, dynamic> yearlyData =
          yearlyResponse.data;

      List yearly =
          yearlyData["monthly"] ?? [];

      yearlyPower =
          yearly
              .map<double>(
                (e) =>
                ((e["totalPower"] ?? 0)
                as num)
                    .toDouble(),
          )
              .toList();

      setState(() {
        isLoading = false;
      });

    } catch (e) {

      print("ERROR = $e");

      setState(() {
        isLoading = false;
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    final tabs = [
      "Current",
      "Voltage",
      "Power",
    ];

    final dataSets = [

      currentValues,
      voltageValues,
      powerValues,

    ];

    final colors = [

      Colors.cyan,
      Colors.orange,
      Colors.pinkAccent,

    ];

    return Scaffold(

      backgroundColor:
      const Color(0xFF121212),

      appBar: AppBar(

        backgroundColor:
        Colors.black,

        elevation: 0,

        leading: IconButton(

          onPressed: () =>
              Navigator.pop(context),

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),

        ),

        title: const Text(
          "Live Sensors Dashboard",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        centerTitle: true,

      ),

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : SingleChildScrollView(

        child: Column(

          children: [

            const SizedBox(height: 15),

            /// ================= LIVE VALUES =================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(

                children: [

                  Expanded(
                    child: _buildLiveCard(
                      "Current",
                      "$currentNow A",
                      Colors.cyan,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildLiveCard(
                      "Voltage",
                      "$voltageNow V",
                      Colors.orange,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildLiveCard(
                      "Power",
                      "$powerNow W",
                      Colors.pinkAccent,
                    ),
                  ),

                ],

              ),

            ),

            const SizedBox(height: 25),

            /// ================= FILTER =================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children:
                List.generate(4, (index) {

                  final names = [

                    "Today",
                    "Week",
                    "Month",
                    "Year",

                  ];

                  bool active =
                      selectedTime ==
                          index;

                  return GestureDetector(

                    onTap: () {

                      setState(() {
                        selectedTime =
                            index;
                      });

                    },

                    child: Container(

                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      decoration:
                      BoxDecoration(

                        color: active
                            ? const Color(
                          0xFFF59E0B,
                        )
                            : Colors.black26,

                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),

                      ),

                      child: Text(

                        names[index],

                        style: TextStyle(

                          color: active
                              ? Colors.black
                              : Colors.white,

                          fontWeight:
                          FontWeight
                              .bold,

                        ),

                      ),

                    ),

                  );

                }),

              ),

            ),

            const SizedBox(height: 20),

            /// ================= MAIN CHART =================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Container(

                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color:
                  const Color(
                    0xFF1E1E1E,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),

                ),

                child: SizedBox(

                  height: 220,

                  child: LineChartWidget(

                    values:
                    selectedTime == 3
                        ? yearlyPower
                        : monthlyPower,

                    color:
                    Colors.cyan,

                  ),

                ),

              ),

            ),

            const SizedBox(height: 25),

            /// ================= TABS =================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children:
                List.generate(3, (index) {

                  bool active =
                      selectedTab ==
                          index;

                  return GestureDetector(

                    onTap: () {

                      setState(() {
                        selectedTab =
                            index;
                      });

                    },

                    child: Container(

                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      decoration:
                      BoxDecoration(

                        color: active
                            ? colors[index]
                            .withOpacity(
                          0.2,
                        )
                            : Colors.black26,

                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),

                        border: Border.all(
                          color: active
                              ? colors[index]
                              : Colors.white12,
                        ),

                      ),

                      child: Text(

                        tabs[index],

                        style: TextStyle(

                          color: active
                              ? colors[index]
                              : Colors.white70,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                    ),

                  );

                }),

              ),

            ),

            const SizedBox(height: 20),

            /// ================= SENSOR CHART =================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Container(

                padding:
                const EdgeInsets.all(18),

                decoration:
                BoxDecoration(

                  color:
                  const Color(
                    0xFF1A1A1A,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),

                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      "${tabs[selectedTab]} Chart",

                      style: const TextStyle(

                        color: Colors.white,

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 15),

                    SizedBox(

                      height: 220,

                      child: LineChartWidget(

                        values:
                        dataSets[selectedTab],

                        color:
                        colors[selectedTab],

                      ),

                    ),

                  ],

                ),

              ),

            ),

            const SizedBox(height: 30),

          ],

        ),

      ),

    );

  }

  Widget _buildLiveCard(

      String title,
      String value,
      Color color,

      ) {

    return Container(

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color:
        const Color(0xFF1E1E1E),

        borderRadius:
        BorderRadius.circular(18),

      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: TextStyle(
              color: color,
              fontWeight:
              FontWeight.bold,
            ),

          ),

          const SizedBox(height: 10),

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 22,

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }

}

class LineChartWidget
    extends StatelessWidget {

  final List<double> values;
  final Color color;

  const LineChartWidget({

    super.key,

    required this.values,
    required this.color,

  });

  @override
  Widget build(BuildContext context) {

    if(values.isEmpty){

      return const Center(
        child: Text(
          "No Data",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

    }

    double maxY =
        values.reduce(
              (a, b) =>
          a > b ? a : b,
        ) +
            10;

    return LineChart(

      LineChartData(

        minX: 0,

        maxX:
        (values.length - 1)
            .toDouble(),

        minY: 0,

        maxY: maxY,

        gridData:
        FlGridData(show: true),

        titlesData: FlTitlesData(

          bottomTitles: AxisTitles(

            sideTitles:
            SideTitles(

              showTitles: true,

              getTitlesWidget:
                  (value, meta) {

                return Text(

                  value
                      .toInt()
                      .toString(),

                  style:
                  const TextStyle(
                    color:
                    Colors.white70,
                    fontSize: 10,
                  ),

                );

              },

            ),

          ),

          leftTitles: AxisTitles(
            sideTitles:
            SideTitles(
              showTitles: false,
            ),
          ),

          topTitles: AxisTitles(
            sideTitles:
            SideTitles(
              showTitles: false,
            ),
          ),

          rightTitles: AxisTitles(
            sideTitles:
            SideTitles(
              showTitles: false,
            ),
          ),

        ),

        lineBarsData: [

          LineChartBarData(

            spots:
            values.asMap().entries.map(

                  (e) {

                return FlSpot(

                  e.key.toDouble(),
                  e.value,

                );

              },

            ).toList(),

            isCurved: true,

            color: color,

            barWidth: 3,

            dotData:
            FlDotData(show: true),

          ),

        ],

      ),

    );

  }

}