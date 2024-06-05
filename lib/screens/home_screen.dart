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
  Future<List<PublicHoliday>> fetchHolidays(int year, String country) async {
    const baseURL = 'https://public-holiday.p.rapidapi.com';
    Map<String, String> requestHeaders = {
      'X-RapidAPI-Key': '',
      'X-RapidAPI-Host': 'public-holiday.p.rapidapi.com'
    };

    final response = await http.get(
      Uri.parse('$baseURL/$year/$country'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      //convert array of JSON objects to List<dynamic>
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      //convert List<dynamic> to List<PublicHoliday>
      List<PublicHoliday> holidays =
          jsonList.map((json) => PublicHoliday.fromJson(json)).toList();
      return holidays;
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<PublicHoliday>>(
          future: fetchHolidays(2024, 'SG'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  PublicHoliday publicHoliday = snapshot.data![index];
                  return ListTile(
                    title: Text(publicHoliday.name),
                    subtitle: Text(publicHoliday.date),
                  );
                },
              );
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
