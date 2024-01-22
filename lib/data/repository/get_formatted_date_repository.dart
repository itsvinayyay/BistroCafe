class FormattedDate {
  String getCurrentDate() {
    DateTime currentDate = DateTime.now();
    return '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
  }

  String getMonth() {
    DateTime currentDate = DateTime.now();
    return '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}';
  }
}
