import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MotivationalCard extends StatelessWidget {
  const MotivationalCard({super.key});

  final List<String> _quotes = const [
    "The way to get started is to quit talking and begin doing. 💪",
    "Don't let yesterday take up too much of today. ✨",
    "You don't have to be great to get started, but you have to get started to be great. 🚀",
    "The future depends on what you do today. 🌟",
    "Success is not final, failure is not fatal: it is the courage to continue that counts. 💫",
    "Believe you can and you're halfway there. 🌈",
    "The only way to do great work is to love what you do. ❤️",
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final quote = _quotes[today.day % _quotes.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Daily Motivation',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quote,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}