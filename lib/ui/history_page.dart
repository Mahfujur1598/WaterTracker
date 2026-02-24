import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/history_controller.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HistoryController>();
    final days = c.lastDaysKeys(14);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final key = c.selectedDayKey.value.isEmpty ? days.first : c.selectedDayKey.value;
          final total = c.dayTotal.value;
          final list = c.entries;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Day: '),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: key,
                    items: days
                        .map((d) => DropdownMenuItem(
                      value: d,
                      child: Text(d),
                    ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) c.selectDay(v);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Total: $total ml',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Divider(),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('No entries'))
                    : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final e = list[i];
                    final time = DateFormat('hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(e.timestamp),
                    );
                    return ListTile(
                      title: Text('${e.amountMl} ml'),
                      subtitle: Text(time),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => c.deleteEntry(e.id!),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}