import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ✅ Glass Effect (شفاف)
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🗑 زر الحذف
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: widget.onDelete,
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 18,
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// 💡 الأيقونة
          Center(
            child: Image.asset(
              widget.iconPath,
              height: 36,
              color: isOn ? Colors.orange : Colors.white70,
            ),
          ),

          const Spacer(),

          /// 📛 اسم الجهاز
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          /// 🔄 الحالة
          Text(
            isOn ? "On" : "Off",
            style: TextStyle(
              color: isOn ? Colors.greenAccent : Colors.white70,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          /// 🔘 السويتش
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.scale(
              scale: 0.85,
              child: Switch(
                value: isOn,
                activeColor: Colors.orange,
                activeTrackColor: Colors.orange.withOpacity(0.4),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.white24,
                onChanged: (val) {
                  setState(() {
                    isOn = val;
                  });
                  widget.onToggle(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}