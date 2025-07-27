/// Türkçe tarih biçimlendirme aracı.
/// Örn: 16.07.2025
String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}."
         "${date.month.toString().padLeft(2, '0')}."
         "${date.year}";
}
String formatDateTime(DateTime dateTime) {
  return "${formatDate(dateTime)} "
         "${dateTime.hour.toString().padLeft(2, '0')}:"
         "${dateTime.minute.toString().padLeft(2, '0')}";
}
