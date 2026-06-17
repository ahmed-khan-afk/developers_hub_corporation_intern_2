import 'package:flutter/material.dart';
import 'glass_container.dart';

class EmptyState extends StatelessWidget {
  final String filterLabel;

  const EmptyState({super.key, required this.filterLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              filterLabel == 'Completed'
                  ? Icons.check_circle_outline_rounded
                  : filterLabel == 'Pending'
                      ? Icons.hourglass_empty_rounded
                      : Icons.task_alt_rounded,
              color: Colors.white.withValues(alpha: 0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              filterLabel == 'Completed'
                  ? 'No completed tasks yet'
                  : filterLabel == 'Pending'
                      ? 'No pending tasks!'
                      : 'No tasks yet',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              filterLabel == 'Completed'
                  ? 'Complete a task to see it here'
                  : filterLabel == 'Pending'
                      ? 'Great job — all done!'
                      : 'Tap + to add your first task',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
