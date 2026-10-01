import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import '../analytics/events.dart';

/// Ask "Did sharing work?" after Share. Feeds success rate (PRD §26).
class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({super.key});
  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  int _stars = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Did sharing keep quality?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  icon: Icon(i <= _stars ? Icons.star : Icons.star_outline,
                      color: BridgeColors.primary),
                  onPressed: () => setState(() => _stars = i),
                ),
            ],
          ),
          BridgePrimaryButton(
            label: 'Send',
            onPressed: _stars == 0
                ? null
                : () {
                    AnalyticsService.log(Events.feedbackSent, {'stars': _stars});
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
    );
  }
}
