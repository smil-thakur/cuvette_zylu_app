class DurationMethods {
  String endDate;
  DurationMethods(this.endDate);
  final List<int> monthdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  int countLeapYears(int year, int month, int date) {
    if (month <= 2) {
      year--;
    }

    return ((year / 4) - (year / 100) + (year / 400)).toInt();
  }

  int getDifference(int year, int month, int date) {
    int yearnow = int.parse(endDate[0] + endDate[1] + endDate[2] + endDate[3]);
    int monthnow = int.parse(endDate[5] + endDate[6]);
    int datenow = int.parse(endDate[8] + endDate[9]);
    int n1 = year * 365 + date;
    for (int i = 0; i < month - 1; i++) {
      n1 = n1 + monthdays[i];
    }
    n1 = n1 + countLeapYears(year, month, date);
    int n2 = yearnow * 365 + datenow;
    for (int i = 0; i < monthnow - 1; i++) {
      n2 = n2 + monthdays[i];
    }
    n2 = n2 + countLeapYears(yearnow, monthnow, datenow);
    return n2 - n1;
  }
}
