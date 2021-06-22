import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Faq {

  List<Data> _data;

  get(Function(List<Data>) callback, Function(String) callbackError) async {

    if (_data != null) {
      return callback(_data);
    }

    try {
      var url = "${serverPath}getfaq";
      var response = await http.get(url)
          .timeout(const Duration(seconds: 30));

      dprint("api/getfaq");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        Response ret = Response.fromJson(jsonResult);
        _data = ret.data;
        callback(ret.data);
      } else
        callbackError("statusCode=${response.statusCode}");
    } catch (ex) {
      callbackError(ex.toString());
    }
  }
}

class Response {
  bool success;
  List<Data> data;
  Response({this.success, this.data});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['data'] != null) {
      var items = json['data'];
      var t = items.map((f)=> Data.fromJson(f)).toList();
      m = t.cast<Data>().toList();
    }
    return Response(
      success: toBool(json['success'].toString()),
      data: m,
    );
  }
}

class Data {
  String question;
  String answer;
  Data({this.question, this.answer});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      question: json['question'].toString(),
      answer: json['answer'].toString(),
    );
  }
}
