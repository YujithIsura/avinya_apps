import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  static String apiUrl = '';
  static String campusAttendanceBffApiUrl = '';
  static String campusProfileBffApiUrl = '';
  static String campusAttendanceBffApiKey = '';
  static String choreoSTSEndpoint = "https://sts.choreo.dev/oauth2/token";
  static String choreoSTSClientID = "HYDMyYYEYZ3Q3VzGaBYFn5eydYoa";
  static String asgardeoTokenEndpoint =
      "https://api.asgardeo.io/t/avinyatest/oauth2/token";
  static String asgardeoClientId = "pJ2gM2o6yXN4f60FypEYWWERrAoa";
  static var apiTokens = null;
  static String applicationName = 'Avinya Campus Apps';
  static String applicationVersion = '1.0.0';
  static String mainCampusActivity = 'school-day';
  static String campusPctiNotesBffApiUrl = '';

  static String campusPctiFeedbackBffApiUrl = '';

  //AppConfig({required this.apiUrl});

  static Future<AppConfig> forEnvironment(String env) async {
    // load the json file
    String contents = "{}";
    try {
      contents = await rootBundle.loadString(
        'assets/config/$env.json',
      );
    } catch (e) {
      print(e);
    }

    // decode our json
    final json = jsonDecode(contents);
    campusAttendanceBffApiUrl = json['campusAttendanceBffApiUrl'];
    campusProfileBffApiUrl = json['campusProfileBffApiUrl'];
    campusPctiNotesBffApiUrl = json['campusPctiNotesBffApiUrl'];
    campusPctiNotesBffApiUrl = json['campusPctiNotesBffApiUrl'];
    campusPctiFeedbackBffApiUrl = json['campusPctiFeedbackBffApiUrl'];

    // convert our JSON into an instance of our AppConfig class
    return AppConfig();
  }

  String getApiUrl() {
    return apiUrl;
  }
}
