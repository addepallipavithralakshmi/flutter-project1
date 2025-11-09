import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreakNotification extends StatelessWidget {
  final int streakCount;

  const StreakNotification({super.key, required this.streakCount});

  @override
  Widget build(BuildContext context) {
    if (streakCount < 3) return const SizedBox.shrink();

    String message = _getStreakMessage(streakCount);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amazing Streak! 🎉',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStreakMessage(int streak) {
    if (streak >= 30) return 'You\'ve completed tasks for $streak days straight! Legendary! 🏆';
    if (streak >= 14) return 'Two weeks of productivity! You\'re on fire! 🔥';
    if (streak >= 7) return 'One week streak! Keep the momentum going! 💪';
    if (streak >= 3) return 'You\'ve completed tasks $streak days in a row! 🚀';
    return '';
  }
}