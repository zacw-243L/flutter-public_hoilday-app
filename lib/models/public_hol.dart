class PublicHoliday {
  String date;
  String name;

  PublicHoliday({
    required this.date,
    required this.name,
  });

  factory PublicHoliday.fromJson(Map<String, dynamic> json) {
    return PublicHoliday(
      date: json['date'],
      name: json['name'],
    );
  }
}
