import 'package:flutter/material.dart';

class DeviceCard extends StatefulWidget {
  final String iconPath;
  final String name;
  final bool isOn;
  final Function(bool)? onToggle;
  final VoidCallback? onDelete;

  const DeviceCard({
    super.key,
    required this.iconPath,
    required this.name,
    required this.isOn,
    this.onToggle,
    this.onDelete,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool toggle;

  @override
  void initState() {
    super.initState();
    toggle = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor
            ,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  widget.iconPath,
                  height: 50,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                toggle ? "On" : "Off",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Switch(
                  value: toggle,
                  activeColor: const Color(0xFFF55E5E),
                  inactiveThumbColor: const Color(0xFF4A80F0),
                  onChanged: (val) {
                    setState(() {
                      toggle = val;
                    });

                    if (widget.onToggle != null) {
                      widget.onToggle!(val);
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // زر حذف الجهاز
        Positioned(
          right: 4,
          top: 4,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onDelete,
          ),
        ),
      ],
    );
  }
}

