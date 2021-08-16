class ContactinfoModel {
  ContactinfoModel({
    this.readingid,
    this.meter_no,
    // this.peak,
    this.offpeak,
    this.month,
    this.year,
    // this.offpkimage,
    this.datetime,
  });

  int readingid;
  String meter_no;
  // String peak;
  String offpeak;
  String month;
  String year;
  // String offpkimage;
  String datetime;


  factory ContactinfoModel.fromJson(Map<String, dynamic> json) => ContactinfoModel(
    readingid: json["readingid"],
    meter_no: json["meter_no"],
    // peak: json["peak"],
    offpeak: json["offpeak"],
    month: json["month"],
    year: json["year"],
    // offpkimage: json["offpkimage"],
    datetime: json["datetime"],

  );

  Map<String, dynamic> toJson() => {
    "readingid": readingid,
    "meter_no": meter_no,
    // "peak": offpeak,
    "offpeak": offpeak,
    "month":month,
    "year":year,
    // "offpkimage" :offpkimage,
    "datetime": datetime,
  };
}