import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:public_holidays/models/public_hol.dart';

//https://rapidapi.com/theapiguy/api/public-holiday/
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<PublicHoliday> fetchHolidays(String country, int year) async {
    const baseURL = 'https://public-holiday.p.rapidapi.com';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Key': 'YOUR-API-KEY',
      'X-RapidAPI-Host': 'public-holiday.p.rapidapi.com'
    };

    final response = await http.get(
      Uri.parse('$baseURL/$year/$country'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var jsonObj = jsonDecode(response.body)[0];
      PublicHoliday holiday = PublicHoliday.fromJson(jsonObj);
      return holiday;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
