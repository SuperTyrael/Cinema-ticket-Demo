class Date {
  final int year;
  final int month;
  final int day;

  Date({
    required this.year,
    required this.month,
    required this.day,
  });

  factory Date.fromDateTime(DateTime dt) {
    return Date(year: dt.year, month: dt.month, day: dt.day);
  }

  DateTime asDateTime() {
    return DateTime(year, month, day);
  }

  bool contains(DateTime dt) =>
      dt.year == year && dt.month == month && dt.day == day;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Date &&
        other.year == year &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}
