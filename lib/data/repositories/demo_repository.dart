import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/demo_response.dart';

class DemoRepository {
  Future<List<DemoResponse>> getDemoData() async {
    final String response = await rootBundle.loadString('assets/json/demo.json');
    final data = await json.decode(response) as List;
    return data.map((e) => DemoResponse.fromJson(e)).toList();
  }
}
