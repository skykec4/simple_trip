import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myapp/models/rate.dart';
import 'package:myapp/utils/store.dart';
import 'package:provider/provider.dart';


class Api {
  static String rateDate = '';
  static Future<List<Rate>> fetchPhotos() async {
    var response;
    rateDate = DateFormat('yyyyMMdd').format(DateTime.now().toLocal());
    for (var i = 0; i < 10; i++) {
//      print('rateDate : $rateDate');

      if (i > 0) {

        rateDate = DateFormat('yyyyMMdd').format(DateTime.now().add(Duration(days: -i)).toLocal());
      }

      response = await http.post(
          'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=nHpyy6i0GGVLJeExq4ZrZnf13tWQ89Lk&searchdate=$rateDate&data=AP01',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json;',
          });

//      print('response.body [$today] : ${response.body}');
//      print('response.statusCode [$rateDate]} : ${response.statusCode}');
//      print('response.statusCode [$rateDate]: ${response.body.length}');

      if (response.statusCode == 200 && response.body.length > 2) {
        break;
      }
    }
//    print('oo?');
    return compute(rateFromJson, utf8.decode(response.bodyBytes));
  }

  static List<Rate> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Rate>((json) => Rate.fromJson(json)).toList();
  }
}
