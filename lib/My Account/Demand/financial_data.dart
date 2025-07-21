// lib/models/financial_data.dart

class FinancialData {
  final String month;
  final String drd;
  final String rrd;
  final String sc;
  final String tf;
  final String slp;
  final String sli;
  final String slpe;
  final String elp;
  final String eli;
  final String elpe;
  final String tot;
  final String scbal;

  FinancialData({
    required this.month,
    required this.drd,
    required this.rrd,
    required this.sc,
    required this.tf,
    required this.slp,
    required this.sli,
    required this.slpe,
    required this.elp,
    required this.eli,
    required this.elpe,
    required this.tot,
    required this.scbal,
  });

  factory FinancialData.fromJson(Map<String, dynamic> json) {
    return FinancialData(
      month: json['month'],
      drd: json['drd'],
      rrd: json['rrd'],
      sc: json['sc'],
      tf: json['tf'],
      slp: json['slp'],
      sli: json['sli'],
      slpe: json['slpe'],
      elp: json['elp'],
      eli: json['eli'],
      elpe: json['elpe'],
      tot: json['tot'],
      scbal: json['scbal'],
    );
  }
}
