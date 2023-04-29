class HamlCalculationModel {
  String? expectedPergnantDate;
  int? getNowMonth,
      getNowWeek,
      getNowDay,
      getRemainMonth,
      getRemainWeek,
      getRemainDay,
      getPastMonth,
      getPastWeek,
      getPastDay;

  HamlCalculationModel({
    this.expectedPergnantDate,
    this.getNowMonth,
    this.getNowWeek,
    this.getNowDay,
    this.getRemainMonth,
    this.getRemainWeek,
    this.getRemainDay,
    this.getPastMonth,
    this.getPastWeek,
    this.getPastDay,
  });

  HamlCalculationModel.fromJson(Map<String, dynamic> jsonDate) {
    expectedPergnantDate = jsonDate['expected_pregnant_date'];
    getNowMonth = jsonDate['get_now']['now_months'];
    getNowWeek = jsonDate['get_now']['now_weeks'];
    getNowDay = jsonDate['get_now']['now_days'];
    getRemainMonth = jsonDate['get_remain']['remain_months'];
    getRemainWeek = jsonDate['get_remain']['remain_weeks'];
    getRemainDay = jsonDate['get_remain']['remain_days'];
    getPastMonth = jsonDate['get_past']['past_months'];
    getPastWeek = jsonDate['get_past']['past_weeks'];
    getPastDay = jsonDate['get_past']['past_days'];
  }
}
