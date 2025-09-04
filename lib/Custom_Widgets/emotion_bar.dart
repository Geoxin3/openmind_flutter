import 'package:flutter/material.dart';

class EmotionProgressBar extends StatelessWidget {
  final String label;
  final double percentage;

  const EmotionProgressBar({
    super.key,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emotion Label & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(), // Make labels uppercase for emphasis
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "${percentage.toStringAsFixed(2)}%", // Show percentage value
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: percentage / 100, // Normalize value between 0 and 1
                minHeight: 12,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(percentage)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to set bar color based on percentage intensity
  Color _getProgressColor(double percentage) {
    if (percentage >= 10) return Colors.green;  // High intensity - Green
    if (percentage >= 5) return Colors.orange; // Medium intensity - Orange
    return Colors.red; // Low intensity - Red
  }
}
