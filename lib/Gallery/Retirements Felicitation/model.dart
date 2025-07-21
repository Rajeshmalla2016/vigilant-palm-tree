import 'retirementsfelicitation.dart';
import 'dart:convert';

// Model classes
class Welcome {
  List<Datum> data;

  Welcome({
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Datum> dataList = list.map((i) => Datum.fromJson(i)).toList();
    return Welcome(data: dataList);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((datum) => datum.toJson()).toList(),
    };
  }
}

class Datum {
  //int id;
  //String name;
  String imageUrl;
  //String thumbUrl;

  Datum({
   // required this.id,
    //required this.name,
    required this.imageUrl,
   // required this.thumbUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
     // id: json['id'],
     // name: json['name'],
      imageUrl: json['imageUrl'],
    //  thumbUrl: json['thumbUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
     // 'id': id,
     // 'name': name,
      'imageUrl': imageUrl,
     // 'thumbUrl': thumbUrl,
    };
  }
}
