import 'package:flutter/material.dart';

import '../pages/Aipage.dart';
import '../pages/DashboardChartsPage.dart';
import '../../services/ai_service.dart';
class DeviceCard extends StatefulWidget {


  final String iconPath;
  final String name;
  final bool isOn;
  final String deviceId;
  final Function(bool) onToggle;

  final VoidCallback onDelete;

  const DeviceCard({

    Key? key,

    required this.deviceId,
    required this.iconPath,
    required this.name,
    required this.isOn,
    required this.onToggle,
    required this.onDelete,

  }) : super(key: key);

  @override
  State<DeviceCard> createState() =>
      _DeviceCardState();

}

class _DeviceCardState
    extends State<DeviceCard> {

  late bool isOn;

  String aiStatus = "loading";
  final AIService aiService = AIService();

  Future loadAIStatus() async {

    String status =
    await aiService.getStatus(
      widget.deviceId,
    );

    if (!mounted) return;

    setState(() {

      aiStatus = status;

    });

  }

  @override
  void initState() {

    super.initState();

    isOn = widget.isOn;

    loadAIStatus();

  }

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: isOn
            ? const Color(0xFFCE672C)
            : const Color(0xFF1E1E1E),

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(0.25),

            blurRadius: 15,

            offset: const Offset(0, 6),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        mainAxisSize: MainAxisSize.min,

        children: [

          /// ================= TOP =================

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              /// DELETE

              GestureDetector(

                onTap: widget.onDelete,

                child: Container(

                  padding:
                  const EdgeInsets.all(6),

                  decoration: BoxDecoration(

                    color:
                    Colors.red.withOpacity(0.15),

                    shape: BoxShape.circle,

                  ),

                  child: const Icon(

                    Icons.delete,

                    color: Colors.red,

                    size: 18,

                  ),

                ),

              ),

              /// SWITCH

              Switch(

                value: isOn,

                activeColor: Colors.white,

                activeTrackColor: Colors.black,

                inactiveThumbColor: Colors.orange,

                onChanged: (val) {

                  setState(() {

                    isOn = val;

                  });

                  widget.onToggle(val);

                },

              ),

            ],

          ),

          const SizedBox(height: 10),

          /// ================= ICON =================

          Center(

            child: Image.asset(

              widget.iconPath,

              height: 45,

            ),

          ),

          const SizedBox(height: 12),

          /// ================= NAME =================

          Text(

            widget.name,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 16,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 4),

          /// ================= STATUS =================

          Text(

            isOn ? "On" : "Off",

            style: TextStyle(

              color:

              aiStatus == "anomaly"

                  ? Colors.red

                  : Colors.green,

              fontSize: 13,

            ),

          ),

          const SizedBox(height: 14),

          /// ================= ACTIONS =================

          Row(

            children: [

              /// ================= STATS =================

              Expanded(

                child: GestureDetector(

                  onTap: () {

                    print("OPEN DASHBOARD");
                    print("DEVICE ID = ${widget.deviceId}");

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => DashboardChartsPage(
                          deviceId: widget.deviceId,
                        ),

                      ),

                    );

                  },

                  child: Container(

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(

                      color:
                      Colors.white.withOpacity(0.1),

                      borderRadius:
                      BorderRadius.circular(12),

                    ),

                    child: const Center(

                      child: Text(

                        "Stats",

                        style: TextStyle(
                          color: Colors.white,
                        ),

                      ),

                    ),

                  ),

                ),

              ),

              const SizedBox(width: 10),

              /// ================= AI =================

              GestureDetector(

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => AIPage(

                        deviceId: widget.deviceId,

                      ),

                    ),

                  );

                },

                child: Container(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(

                    color:

                    aiStatus == "anomaly"
                        ? Colors.red
                        : aiStatus == "warning"
                        ? Colors.orange
                        : Colors.green,

                    borderRadius:
                    BorderRadius.circular(20),

                  ),

                  child: Row(

                    children: [

                      Icon(

                        aiStatus == "anomaly"

                            ? Icons.warning

                            : Icons.check_circle,
                        color: Colors.white,
                        size: 16,

                      ),

                      const SizedBox(width: 5),

                      Text(
                        aiStatus == "anomaly"

                            ? "Warning"

                            : "Normal",
                        style: const TextStyle(
                          color: Colors.white,
                        ),

                      ),

                    ],

                  ),

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}