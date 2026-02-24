class WaterEntry {
  final int? id;
  final int amountMl;
  final int timestamp; // ms epoch
  final String dayKey; // YYYY-MM-DD

  WaterEntry({
    this.id,
    required this.amountMl,
    required this.timestamp,
    required this.dayKey,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'amount_ml': amountMl,
    'timestamp': timestamp,
    'day_key': dayKey,
  };

  static WaterEntry fromMap(Map<String, Object?> map) => WaterEntry(
    id: map['id'] as int?,
    amountMl: map['amount_ml'] as int,
    timestamp: map['timestamp'] as int,
    dayKey: map['day_key'] as String,
  );
}