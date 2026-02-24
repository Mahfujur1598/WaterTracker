import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SettingsController>();
    const hourOptions = [1, 2, 3, 4, 6, 8, 12];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Goal (ml)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text('Current: ${c.goalMl.value} ml')),
                  ElevatedButton(
                    onPressed: () async {
                      final newGoal = await _askNumber(
                        context,
                        title: 'Set Daily Goal (ml)',
                        hint: 'e.g., 2000',
                        initial: c.goalMl.value.toString(),
                      );
                      if (newGoal != null && newGoal > 0) {
                        c.setGoal(newGoal);
                      }
                    },
                    child: const Text('Change'),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Reminder Notifications',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    value: c.reminderEnabled.value,
                    onChanged: (v) => c.setReminderEnabled(v),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Opacity(
                opacity: c.reminderEnabled.value ? 1.0 : 0.5,
                child: IgnorePointer(
                  ignoring: !c.reminderEnabled.value,
                  child: Row(
                    children: [
                      const Text('Every'),
                      const SizedBox(width: 12),
                      DropdownButton<int>(
                        value: hourOptions.contains(c.reminderHours.value)
                            ? c.reminderHours.value
                            : 2,
                        items: hourOptions
                            .map(
                              (h) => DropdownMenuItem(
                            value: h,
                            child: Text('$h hour${h == 1 ? '' : 's'}'),
                          ),
                        )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) c.setReminderHours(v);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Per reminder: ${c.perReminderMl} ml  (${c.remindersPerDay} times/day)',
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => c.testNow(),
                child: const Text('Test Notification Now'),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<int?> _askNumber(
      BuildContext context, {
        required String title,
        required String hint,
        String? initial,
      }) async {
    final controller = TextEditingController(text: initial ?? '');
    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final v = int.tryParse(controller.text.trim());
              Navigator.pop(context, v);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}