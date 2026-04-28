import 'package:flutter/material.dart';

import '../pages/Aipage.dart';
import '../pages/DashboardChartsPage.dart';

class DeviceCard extends StatefulWidget {
  final String iconPath;
  final String name;
  final bool isOn;
  final Function(bool) onToggle;
  final VoidCallback onDelete;

  const DeviceCard({
    Key? key,
    required this.iconPath,
    required this.name,
    required this.isOn,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool isOn;
  bool isWarning = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),

      decoration: BoxDecoration(
        color: isOn
            ? const Color(0xFFCE672C)
            : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 👈 مهم جدًا
        children: [

          /// DELETE
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: widget.onDelete,
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),

          const SizedBox(height: 5),

          /// ICON
          Center(
            child: Image.asset(
              widget.iconPath,
              height: 50,
            ),
          ),

          const SizedBox(height: 12),

          /// NAME
          Text(
            widget.name,
            style: TextStyle(
              color: isOn ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          /// STATUS
          Text(
            isOn ? "On" : "Off",
            style: TextStyle(
              color: isOn ? Colors.white70 : Colors.black54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 10),
          Row(
            children: [

              /// 📊 Stats Button
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DashboardChartsPage(
                          currentValues: [1,2,3],
                          voltageValues: [220,221],
                          powerValues: [40,50],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bar_chart, size: 18),
                  label: const Text("Stats"),
                ),
              ),

              const SizedBox(width: 10),

              /// 🤖 AI Status (Chip Style)
              GestureDetector(
                onTap: () { Navigator.push( context, MaterialPageRoute( builder: (_) => const AiPage(), ), ); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isWarning ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isWarning ? Icons.warning : Icons.check_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isWarning ? "Warning" : "Normal",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          /// SWITCH
          Align(
            alignment: Alignment.bottomRight,
            child: Switch(
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
          ),
        ],
      ),
    );
  }
}