import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/rate.dart';

class Api {
  static Future<List<Rate>> fetchPhotos(String date) async {
    final response = await http.post(
        'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=nHpyy6i0GGVLJeExq4ZrZnf13tWQ89Lk&searchdate=$date&data=AP01',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json;',
        });

    return compute(parsePhotos, utf8.decode(response.bodyBytes));
  }

  static List<Rate> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Rate>((json) => Rate.fromJson(json)).toList();
  }
}
