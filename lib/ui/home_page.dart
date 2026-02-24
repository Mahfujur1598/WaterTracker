import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes.dart';
import '../controllers/home_controller.dart';
import '../controllers/settings_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    final settings = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.history),
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final goalMl = settings.goalMl.value;
          final goalL = (goalMl / 1000).toStringAsFixed(1);

          final total = home.todayTotalMl.value;

          // ✅ clamp for ring value
          final ringProgress = home.progress.clamp(0.0, 1.0);
          final percent = (ringProgress * 100).toStringAsFixed(0);

          final enabled = settings.reminderEnabled.value;
          final hours = settings.reminderHours.value;
          final perReminder = settings.perReminderMl;
          final timesPerDay = settings.remindersPerDay;

          // ✅ success if goal reached (preferred)
          final isSuccess = home.isGoalReached.value;

          return ListView(
            children: [
              // ✅ Top Progress Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 240,
                        height: 240,



                        child: Column(
                          children: [
                            if (!isSuccess) ...[
                              // background ring
                              CircularProgressIndicator(
                                value: 0,
                                strokeWidth: 10,
                                color: Colors.grey.shade200,
                              ),

                              // animated ring
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: ringProgress),
                                duration: const Duration(milliseconds: 70),
                                curve: Curves.easeOutCubic,
                                builder: (_, v, __) {
                                  return CircularProgressIndicator(
                                    value: v,
                                    strokeWidth: 3,
                                    color: Theme.of(context).primaryColor,
                                  );
                                },
                              ),
                            ],

                            // 👉 Center content
                            isSuccess
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.check_circle,
                                  size: 50,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Hit your daily goal! 🎉',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )
                                : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$percent%',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$total ml',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Goal: $goalMl ml ($goalL L)',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),

                      const SizedBox(height: 12),
                      Divider(height: 24,),

                      // ✅ Chips row (Goal / Every / Per)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          _InfoChip(
                            icon: Icons.flag,
                            label: 'Goal',
                            value: '$goalMl ml',
                          ),
                          _InfoChip(
                            icon: Icons.schedule,
                            label: 'Every',
                            value: enabled ? '${hours}h' : 'OFF',
                            isDisabled: !enabled,
                          ),
                          _InfoChip(
                            icon: Icons.local_drink,
                            label: 'Per',
                            value: enabled ? '$perReminder ml' : '-',
                            isDisabled: !enabled,
                          ),
                          _InfoChip(
                            icon: Icons.repeat,
                            label: 'Day',
                            value: enabled ? '$timesPerDay×' : '-',
                            isDisabled: !enabled,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        enabled
                            ? 'Reminders: every $hours hour(s), drink $perReminder ml each time'
                            : 'Reminders are OFF. Turn ON from Settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: enabled
                              ? Colors.grey.shade700
                              : Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ✅ Quick Add Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Add',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () async => await home.addWater(250),
                              child: const Text('+250 ml'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () async => await home.addWater(500),
                              child: const Text('+500 ml'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final amount = await _askAmount(context);
                            if (amount != null && amount > 0) {
                              await home.addWater(amount);
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Custom Amount'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<int?> _askAmount(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add water (ml)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'e.g., 300'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              Navigator.pop(context, value);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// ✅ Button-like chip widget (Goal / Every / Per)
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDisabled;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: isDisabled ? Colors.grey.shade100 : Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isDisabled ? Colors.grey : null),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDisabled ? Colors.grey : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}