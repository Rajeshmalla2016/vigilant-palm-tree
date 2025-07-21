import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  String success;
  String message;
  List<Datum> data;

  Welcome({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String suretyGiven1;
  String suretyGiven2;
  String suretyGiven3;
  String devidendHead;
  String devidendAmt;
  String suretyTaken1;
  String suretyTaken2;
  String suretyTaken3;

  Datum({
    required this.suretyGiven1,
    required this.suretyGiven2,
    required this.suretyGiven3,
    required this.devidendHead,
    required this.devidendAmt,
    required this.suretyTaken1,
    required this.suretyTaken2,
    required this.suretyTaken3,
  });
/*
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    suretyGiven1: json["surety_given_1"],
    suretyGiven2: json["surety_given_2"],
    suretyGiven3: json["surety_given_3"],
    devidendHead: json["devidend_head"],
    devidendAmt: json["devidend_amt"],
    suretyTaken1: json["surety_taken_1"],
    suretyTaken2: json["surety_taken_2"],
    suretyTaken3: json["surety_taken_3"],
  );

 */
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    suretyGiven1: json["surety_given_1"] ?? "",
    suretyGiven2: json["surety_given_2"] ?? "",
    suretyGiven3: json["surety_given_3"] ?? "",
    devidendHead: json["devidend_head"] ?? "",
    devidendAmt: json["devidend_amt"] ?? "",
    suretyTaken1: json["surety_taken_1"] ?? "",
    suretyTaken2: json["surety_taken_2"] ?? "",
    suretyTaken3: json["surety_taken_3"] ?? "",
  );


  Map<String, dynamic> toJson() => {
    "surety_given_1": suretyGiven1,
    "surety_given_2": suretyGiven2,
    "surety_given_3": suretyGiven3,
    "devidend_head": devidendHead,
    "devidend_amt": devidendAmt,
    "surety_taken_1": suretyTaken1,
    "surety_taken_2": suretyTaken2,
    "surety_taken_3": suretyTaken3,
  };
}
