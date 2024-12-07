// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProgressBars extends StatelessWidget {
  const ProgressBars({
    Key? key,
    required this.label,
    required this.progress,
    required this.color,
  }) : super(key: key);

  final String label;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 12,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(2)),
        ),
        Container(
          height: 12,
          width: MediaQuery.of(context).size.width * progress,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
            ),
          ),
        ),
      ],
    );
  }
}
