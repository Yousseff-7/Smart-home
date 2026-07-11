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
  double temperatureNow = 0;
  double humidityNow = 0;
  double monthlyAverage = 0;
  double yearlyAverage = 0;
  double monthlyTotal = 0;
  double yearlyTotal = 0;

  List<double> monthlyPower = [];
  List<double> yearlyPower = [];
  final Dio dio = Dio(

    BaseOptions(

      baseUrl:
      "http://64.225.101.222:5000/api",

    ),

  );

  Future<String> getToken() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";

  }

  @override
  void initState() {
    super.initState();

    print("================================");
    print("DEVICE ID => ${widget.deviceId}");
    print("================================");

    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      String token = await getToken();

      print("DEVICE ID => ${widget.deviceId}");

      /// ================= READINGS =================

      Response readingsResponse = await dio.get(
        "/readings/device/${widget.deviceId}",
        options: Options(
          headers: {
            "Authorization": "bearer $token",
          },
        ),
      );

      print("READINGS TYPE => ${readingsResponse.data.runtimeType}");
      print("READINGS DATA => ${readingsResponse.data}");

      List readings = [];

      if (readingsResponse.data is List) {
        readings = List.from(readingsResponse.data);
      } else if (readingsResponse.data is Map &&
          readingsResponse.data["readings"] != null) {
        readings = List.from(
          readingsResponse.data["readings"],
        );
      }

      print("READINGS COUNT => ${readings.length}");

      currentValues = readings
          .map<double>((e) =>
      (e["current"] as num?)?.toDouble() ?? 0)
          .toList();

      voltageValues = readings
          .map<double>((e) =>
      (e["voltage"] as num?)?.toDouble() ?? 0)
          .toList();

      powerValues = readings
          .map<double>((e) =>
      (e["power"] as num?)?.toDouble() ?? 0)
          .toList();

      /// قلل عدد النقاط المرسومة

      currentValues = currentValues.reversed.take(50).toList().reversed.toList();
      voltageValues = voltageValues.reversed.take(50).toList().reversed.toList();
      powerValues = powerValues.reversed.take(50).toList().reversed.toList();

      if (readings.isNotEmpty) {

        final latest = readings.firstWhere(
              (e) =>
          ((e["current"] ?? 0) as num) > 0 ||
              ((e["power"] ?? 0) as num) > 0,
          orElse: () => readings.first,
        );

        currentNow =
            (latest["current"] as num?)
                ?.toDouble() ?? 0;

        voltageNow =
            (latest["voltage"] as num?)
                ?.toDouble() ?? 0;

        powerNow =
            (latest["power"] as num?)
                ?.toDouble() ?? 0;
        temperatureNow =
            (latest["temperature"] as num?)?.toDouble() ?? 0;

        humidityNow =
            (latest["humidity"] as num?)?.toDouble() ?? 0;
      }
      print("FIRST => ${readings.first}");
      print("LAST => ${readings.last}");

      print("CURRENT VALUES => ${currentValues.length}");
      print("VOLTAGE VALUES => ${voltageValues.length}");
      print("POWER VALUES => ${powerValues.length}");

      print("CURRENT NOW => $currentNow");
      print("VOLTAGE NOW => $voltageNow");
      print("POWER NOW => $powerNow");

      /// ================= MONTHLY =================

      final now = DateTime.now();

      Response monthlyResponse = await dio.get(
        "/stats/monthly?deviceId=${widget.deviceId}&month=${now.month}&year=${now.year}",
        options: Options(
          headers: {
            "Authorization": "bearer $token",
          },
        ),
      );

      print("MONTHLY => ${monthlyResponse.data}");

      Map<String, dynamic> monthlyData =
      Map<String, dynamic>.from(
        monthlyResponse.data,
      );

      monthlyAverage =
          ((monthlyData["monthlyAverage"] ?? 0) as num)
              .toDouble();

      monthlyTotal =
          ((monthlyData["monthlyTotal"] ?? 0) as num)
              .toDouble();

      List monthly =
          monthlyData["daily"] ?? [];

      monthlyPower = monthly
          .map<double>(
            (e) =>
            ((e["totalPower"] ?? 0) as num)
                .toDouble(),
      )
          .toList();

      print("MONTHLY POWER => ${monthlyPower.length}");

      /// ================= YEARLY =================

      Response yearlyResponse = await dio.get(
        "/stats/yearly?deviceId=${widget.deviceId}&year=${now.year}",
        options: Options(
          headers: {
            "Authorization": "bearer $token",
          },
        ),
      );

      print("YEARLY => ${yearlyResponse.data}");

      Map<String, dynamic> yearlyData =
      Map<String, dynamic>.from(
        yearlyResponse.data,
      );

      yearlyAverage =
          ((yearlyData["yearlyAverage"] ?? 0) as num)
              .toDouble();

      yearlyTotal =
          ((yearlyData["yearlyTotal"] ?? 0) as num)
              .toDouble();

      List yearly =
          yearlyData["monthly"] ?? [];

      yearlyPower = yearly
          .map<double>(
            (e) =>
            ((e["totalPower"] ?? 0) as num)
                .toDouble(),
      )
          .toList();

      print("YEARLY POWER => ${yearlyPower.length}");

      setState(() {
        isLoading = false;
      });
    } catch (e, s) {
      print("ERROR => $e");
      print(s);

      setState(() {
        isLoading = false;
      });
    }
  }

  List<double> getChartValues() {

    switch(selectedTime){

      case 0:
        return powerValues;

      case 1:
        return powerValues.reversed.take(50).toList().reversed.toList();

      case 2:
        return monthlyPower;

      case 3:
        return yearlyPower;

      default:
        return powerValues;

    }

  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

    final liveValues = [

      "${currentNow.toStringAsFixed(1)} A",
      "${voltageNow.toStringAsFixed(1)} V",
      "${powerNow.toStringAsFixed(1)} W",

    ];

    return Scaffold(

      backgroundColor: theme.scaffoldBackgroundColor,

    appBar: AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,

    elevation: 0,

      title: Text(
        "Live Sensors Dashboard",
        style: TextStyle(
          color: theme.textTheme.titleLarge?.color,
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

    child: Padding(

    padding:
    const EdgeInsets.all(16),

    child: Column(

    children: [

    /// LIVE VALUES

    Row(

    children: [

    Expanded(

    child: _buildLiveCard(

    "Current",
    liveValues[0],
    Colors.cyan,

    ),

    ),

    const SizedBox(width: 10),

    Expanded(

    child: _buildLiveCard(

    "Voltage",
    liveValues[1],
    Colors.orange,

    ),

    ),

    const SizedBox(width: 10),

    Expanded(

    child: _buildLiveCard(

    "Power",
    liveValues[2],
    Colors.pinkAccent,

    ),

    ),

    ],

    ),

    const SizedBox(height: 20),

            /// ================= FILTER =================
    Row(

    mainAxisAlignment:
    MainAxisAlignment.spaceBetween,

    children:

    List.generate(4, (index) {

    final names = [

    "Today",
    "Week",
    "Month",
    "Year",

    ];

    bool active =
    selectedTime == index;

    return GestureDetector(

    onTap: () {

    setState(() {

    selectedTime =
    index;

    });

    },

    child: Container(

    padding:
    const EdgeInsets.symmetric(

    horizontal: 18,
    vertical: 10,

    ),

    decoration:
    BoxDecoration(

      color: active
          ? theme.colorScheme.primary
          : theme.canvasColor,

    borderRadius:
    BorderRadius.circular(
    12,
    ),

    ),

    child: Text(

    names[index],

    style: TextStyle(

    color: active
        ? theme.colorScheme.onPrimary
        : theme.textTheme.bodyMedium?.color,
    fontWeight:
    FontWeight.bold,

    ),

    ),

    ),

    );

    }),

    ),

    const SizedBox(height: 20),
      Row(
        children: [

          Expanded(
            child: _buildLiveCard(
              "Temperature",
              "${temperatureNow.toStringAsFixed(1)} °C",
              Colors.redAccent,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _buildLiveCard(
              "Humidity",
              "${humidityNow.toStringAsFixed(1)} %",
              Colors.lightBlue,
            ),
          ),

        ],
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
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
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

      /// MONTHLY / YEARLY CHART

      Container(

        padding:
        const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: theme.cardColor,

          borderRadius:
          BorderRadius.circular(20),

        ),

        child: SizedBox(

          height: 220,

          child: LineChartWidget(
            values: getSelectedValues(),

            color: colors[selectedTab],

          ),

        ),

      ),

      const SizedBox(height: 25),

      /// SENSOR TABS

      Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children:

        List.generate(3, (index) {

          bool active =
              selectedTab == index;

          return GestureDetector(

            onTap: () {

              setState(() {

                selectedTab =
                    index;

              });

            },

            child: Container(

              padding:
              const EdgeInsets.symmetric(

                horizontal: 20,
                vertical: 10,

              ),

              decoration:
              BoxDecoration(

                color: active

                    ? colors[index]
                    .withOpacity(0.2)

                    : Colors.black26,

                borderRadius:
                BorderRadius.circular(
                  14,
                ),

                border: Border.all(

                  color: active

                      ? colors[index]

                      : Colors.white12,

                ),

              ),



            ),

          );

        }),

      ),



      /// SENSOR CHART


      const SizedBox(height: 25),

      /// STATS

      Row(

        children: [

          Expanded(

            child: _buildLiveCard(

              "Monthly Avg",
              monthlyAverage
                  .toStringAsFixed(1),

              Colors.green,

            ),

          ),

          const SizedBox(width: 10),

          Expanded(

            child: _buildLiveCard(

              "Yearly Avg",
              yearlyAverage
                  .toStringAsFixed(1),

              Colors.deepPurple,

            ),

          ),

        ],

      ),

      const SizedBox(height: 10),

      Row(

        children: [

          Expanded(

            child: _buildLiveCard(

              "Monthly Total",
              monthlyTotal
                  .toStringAsFixed(1),

              Colors.orange,

            ),

          ),

          const SizedBox(width: 10),

          Expanded(

            child: _buildLiveCard(

              "Yearly Total",
              yearlyTotal
                  .toStringAsFixed(1),

              Colors.redAccent,

            ),

          ),

        ],

      ),

    ],

    ),

    ),

    ),

    );

  }
  Widget _buildLiveCard(

      String title,
      String value,
      Color color,

      ) {
    final theme = Theme.of(context);
    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: theme.cardColor,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: color.withOpacity(0.3),
        ),

        boxShadow: [

          BoxShadow(

            color: theme.shadowColor,

            blurRadius: 10,

            offset: const Offset(0, 3),

          ),

        ],

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

              fontSize: 14,

            ),

          ),

          const SizedBox(height: 12),

          Text(

            value,

            maxLines: 1,

            overflow: TextOverflow.visible,

            style: TextStyle(

              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,

              fontSize: 24,

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }
  List<double> getSelectedValues() {

    if (selectedTab == 0) {

      switch (selectedTime) {

        case 0:
          return currentValues;

        case 1:
          return currentValues.reversed.take(50).toList().reversed.toList();

        case 2:
          return monthlyPower;

        case 3:
          return yearlyPower;

      }

    }

    if (selectedTab == 1) {

      return voltageValues;

    }

    return powerValues;

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
    final theme = Theme.of(context);
    if (values.isEmpty) {

      return Center(

        child: Text(

          "No Data Available",

          style: TextStyle(

            color: theme.textTheme.bodyMedium?.color,

            fontSize: 16,

          ),

        ),

      );

    }

    double maxValue =
    values.reduce((a,b)=>a>b?a:b);

    double minValue =
    values.reduce((a,b)=>a<b?a:b);

    double maxY = maxValue * 1.1;

    double minY = minValue * 0.9;

    if(minY < 0){
      minY = 0;
    }
    return LineChart(

      LineChartData(

        minX: 0,

        maxX:
        (values.length - 1)
            .toDouble(),

        minY: 0,

        maxY: maxY,

        gridData: FlGridData(

          show: true,

          drawVerticalLine: true,

          horizontalInterval:
          maxY / 5,

          getDrawingHorizontalLine:
              (value) {

            return FlLine(

              color: theme.dividerColor,

              strokeWidth: 1,

            );

          },

          getDrawingVerticalLine:
              (value) {

            return FlLine(

              color: theme.dividerColor.withOpacity(.6),

              strokeWidth: 1,

            );

          },

        ),

        borderData: FlBorderData(

          show: true,

          border: Border.all(
            color: theme.dividerColor,
          ),

        ),

        titlesData: FlTitlesData(

          leftTitles: AxisTitles(

            sideTitles:
            SideTitles(

              showTitles: true,

              reservedSize: 40,

              getTitlesWidget:
                  (value, meta) {

                return Text(

                  value
                      .toInt()
                      .toString(),

                  style:
                  TextStyle(

                    color: theme.textTheme.bodyMedium?.color,

                    fontSize: 10,

                  ),

                );

              },

            ),

          ),

          bottomTitles: AxisTitles(

            sideTitles:
            SideTitles(

              showTitles: true,

              reservedSize: 24,

              getTitlesWidget:
                  (value, meta) {

                return Text(

                  value
                      .toInt()
                      .toString(),

                  style:
                  const TextStyle(

                    color:
                    Colors.white54,

                    fontSize: 10,

                  ),

                );

              },

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
            values
                .asMap()
                .entries
                .map(

                  (e) => FlSpot(

                e.key.toDouble(),
                e.value,

              ),

            )
                .toList(),

            isCurved: false,

            color: color,

            barWidth: 2.5,
            isStrokeCapRound:
            true,

            belowBarData:
            BarAreaData(

              show: true,

              color:
              color.withOpacity(
                0.2,
              ),

            ),

            dotData: FlDotData(
              show: true,
            ),
          ),

        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  spot.y.toStringAsFixed(2),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),

      ),


    );

  }

}