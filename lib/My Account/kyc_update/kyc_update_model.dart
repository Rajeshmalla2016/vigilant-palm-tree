

class KycResponse {
  final String success;
  final String message;
  final List<KycData> data;

  KycResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory KycResponse.fromJson(Map<String, dynamic> json) {
    return KycResponse(
      success: json['success'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => KycData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class KycData {
  final String? firName;
  final String? midName;
  final String? surName;
  final String? email;
  final String? designation;
  final String? birtDt;
  final String? joinDt;
  final String? regdDt;
  final String? divNo;
  final String? billNo;
  final String? cpfNo;
  final String? sexId;
  final String? blodGr;
  final String? nomi1;
  final String? nomiRelation1;
  final String? nomiDob1;
  final String? nomi2;
  final String? nomiRelation2;
  final String? nomiDob2;
  final String? houseNo;
  final String? locaName;
  final String? landmark;
  final String? road;
  final String? area;
  final String? postoffice;
  final String? city;
  final String? dist;
  final String? state;
  final String? pincode;
  final String? houseNo1;
  final String? locaName1;
  final String? landmark1;
  final String? road1;
  final String? area1;
  final String? postoffice1;
  final String? city1;
  final String? dist1;
  final String? state1;
  final String? pincode1;
  final String? mobiNo;
  final String? phNo;
  final String? sapId;
  final String? adhar;
  final String? pan;
  final String? nameOnAccount;
  final String? accountNo;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;

  KycData({
    this.firName,
    this.midName,
    this.surName,
    this.email,
    this.designation,
    this.birtDt,
    this.joinDt,
    this.regdDt,
    this.divNo,
    this.billNo,
    this.cpfNo,
    this.sexId,
    this.blodGr,
    this.nomi1,
    this.nomiRelation1,
    this.nomiDob1,
    this.nomi2,
    this.nomiRelation2,
    this.nomiDob2,
    this.houseNo,
    this.locaName,
    this.landmark,
    this.road,
    this.area,
    this.postoffice,
    this.city,
    this.dist,
    this.state,
    this.pincode,
    this.houseNo1,
    this.locaName1,
    this.landmark1,
    this.road1,
    this.area1,
    this.postoffice1,
    this.city1,
    this.dist1,
    this.state1,
    this.pincode1,
    this.mobiNo,
    this.phNo,
    this.sapId,
    this.adhar,
    this.pan,
    this.nameOnAccount,
    this.accountNo,
    this.bankName,
    this.branchName,
    this.ifscCode,
  });

  factory KycData.fromJson(Map<String, dynamic> json) {
    return KycData(
      firName: json['fir_name'],
      midName: json['mid_name'],
      surName: json['sur_name'],
      email: json['email'],
      designation: json['designation'],
      birtDt: json['birt_dt'],
      joinDt: json['join_dt'],
      regdDt: json['regd_dt'],
      divNo: json['div_no'],
      billNo: json['bill_no'],
      cpfNo: json['cpf_no'],
      sexId: json['sex_id'],
      blodGr: json['blod_gr'],
      nomi1: json['nomi1'],
      nomiRelation1: json['nomi_relation1'],
      nomiDob1: json['nomi_dob1'],
      nomi2: json['nomi2'],
      nomiRelation2: json['nomi_relation2'],
      nomiDob2: json['nomi_dob2'],
      houseNo: json['house_no'],
      locaName: json['loca_name'],
      landmark: json['landmark'],
      road: json['road'],
      area: json['area'],
      postoffice: json['postoffice'],
      city: json['city'],
      dist: json['dist'],
      state: json['state'],
      pincode: json['pincode'],
      houseNo1: json['house_no1'],
      locaName1: json['loca_name1'],
      landmark1: json['landmark1'],
      road1: json['road1'],
      area1: json['area1'],
      postoffice1: json['postoffice1'],
      city1: json['city1'],
      dist1: json['dist1'],
      state1: json['state1'],
      pincode1: json['pincode1'],
      mobiNo: json['mobi_no'],
      phNo: json['ph_no'],
      sapId: json['sap_id'],
      adhar: json['adhar'],
      pan: json['pan'],
      nameOnAccount: json['nameonaccount'],
      accountNo: json['account_no'],
      bankName: json['bank_name'],
      branchName: json['branch_name'],
      ifscCode: json['ifsc_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fir_name': firName,
      'mid_name': midName,
      'sur_name': surName,
      'email': email,
      'designation': designation,
      'birt_dt': birtDt,
      'join_dt': joinDt,
      'regd_dt': regdDt,
      'div_no': divNo,
      'bill_no': billNo,
      'cpf_no': cpfNo,
      'sex_id': sexId,
      'blod_gr': blodGr,
      'nomi1': nomi1,
      'nomi_relation1': nomiRelation1,
      'nomi_dob1': nomiDob1,
      'nomi2': nomi2,
      'nomi_relation2': nomiRelation2,
      'nomi_dob2': nomiDob2,
      'house_no': houseNo,
      'loca_name': locaName,
      'landmark': landmark,
      'road': road,
      'area': area,
      'postoffice': postoffice,
      'city': city,
      'dist': dist,
      'state': state,
      'pincode': pincode,
      'house_no1': houseNo1,
      'loca_name1': locaName1,
      'landmark1': landmark1,
      'road1': road1,
      'area1': area1,
      'postoffice1': postoffice1,
      'city1': city1,
      'dist1': dist1,
      'state1': state1,
      'pincode1': pincode1,
      'mobi_no': mobiNo,
      'ph_no': phNo,
      'sap_id': sapId,
      'adhar': adhar,
      'pan': pan,
      'nameonaccount': nameOnAccount,
      'account_no': accountNo,
      'bank_name': bankName,
      'branch_name': branchName,
      'ifsc_code': ifscCode,
    };
  }
}

