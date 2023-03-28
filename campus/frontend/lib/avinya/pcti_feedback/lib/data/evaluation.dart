import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gallery/config/app_config.dart';

class Evaluation {
  int? id;
  int? evaluatee_id;
  int? evaluator_id;
  int? evaluation_criteria_id;
  int? activity_instance_id;
  String? updated;
  String? response;
  String? notes;
  String? created;
  int? grade;
  var child_evaluations = <Evaluation>[];
  var parent_evaluations = <Evaluation>[];

  Evaluation({
    this.id,
    this.evaluatee_id,
    this.evaluator_id,
    this.evaluation_criteria_id,
    this.activity_instance_id,
    this.updated,
    this.response,
    this.notes,
    this.created,
    this.grade,
    this.child_evaluations = const [],
    this.parent_evaluations = const [],
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      evaluatee_id: json['evaluatee_id'],
      evaluator_id: json['evaluator_id'],
      evaluation_criteria_id: json['evaluation_criteria_id'],
      activity_instance_id: json['activity_instance_id'],
      updated: json['updated'],
      response: json['response'],
      created: json['created'],
      notes: json['notes'],
      grade: json['grade'],
      // child_evaluations: json['child_evaluations']
      //     .map<Evaluation>((eval_json) => Evaluation.fromJson(eval_json))
      //     .toList(),
      // parent_evaluations: json['child_evaluations']
      //     .map<Evaluation>((eval_json) => Evaluation.fromJson(eval_json))
      //     .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (evaluatee_id != null) 'evaluatee_id': evaluatee_id,
        if (evaluator_id != null) 'evaluator_id': evaluator_id,
        if (evaluation_criteria_id != null)
          'evaluation_criteria_id': evaluation_criteria_id,
        if (activity_instance_id != null)
          'activity_instance_id': activity_instance_id,
        if (updated != null) 'updated': updated,
        if (response != null) 'response': response,
        if (created != null) 'created': created,
        if (notes != null) 'notes': notes,
        if (grade != null) 'grade': grade,
        // 'child_evaluations': [child_evaluations],
        // 'parent_evaluations': [parent_evaluations],
      };
}

// Future<List<Evaluation>>fetchPctiParticipantEvaluations(int person_id) async{
//   final response = await http.get(
//     Uri.parse(AppConfig.campusPctiFeedbackBffApiUrl + '/pcti_participant_evaluations?person_id=$person_id'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'accept': 'application/json',
//       'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
//     },
//   );

//   if (response.statusCode == 200) {
//     var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
//     List<Evaluation> pctiEvaluations = await resultsJson
//         .map<Evaluation>((json) => Evaluation.fromJson(json))
//         .toList();
//     return pctiEvaluations;
//   } else {
//     throw Exception('Failed to load pctiEvaluations');
//   }
// }

Future<List<Evaluation>> fetchEvaluations() async {
  final response = await http.get(
    Uri.parse(AppConfig.campusPctiFeedbackBffApiUrl + '/all_evaluations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
      'Authorization': 'Bearer ' + AppConfig.campusPctiFeedbackBffApiKey,
    },
  );

  if (response.statusCode == 200) {
    var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Evaluation> applicantConsents = await resultsJson
        .map<Evaluation>((json) => Evaluation.fromJson(json))
        .toList();
    return applicantConsents;
  } else {
    throw Exception('Failed to load Evaluation');
  }
}

Future<Evaluation> fetchEvaluation(String id) async {
  final response = await http.get(
    Uri.parse(AppConfig.campusPctiFeedbackBffApiUrl +
        '/pcti_activity_evaluation/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
      'Authorization': 'Bearer ' + AppConfig.campusPctiFeedbackBffApiKey,
    },
  );

  if (response.statusCode == 200) {
    var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
    Evaluation applicantConsent =
        await resultsJson.map<Evaluation>((json) => Evaluation.fromJson(json));
    return applicantConsent;
  } else {
    throw Exception('Failed to load Evaluation');
  }
}

Future<http.Response> createEvaluation(List<Evaluation> evaluation) async {
  print(evaluation);
  print(evaluation.map((evaluation) => evaluation.toJson()).toList());
  // log(evaluations.map((evaluation) => evaluation.toJson()).toString());
  final response = await http.post(
    Uri.parse(AppConfig.campusPctiFeedbackBffApiUrl + '/evaluations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + AppConfig.campusPctiFeedbackBffApiKey,
    },
    body: jsonEncode(
        evaluation.map((evaluation) => evaluation.toJson()).toList()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to create Evaluation.');
  }
}

Future<http.Response> updateEvaluation(Evaluation applicantConsent) async {
  final response = await http.put(
    Uri.parse(AppConfig.campusPctiFeedbackBffApiUrl + '/evaluations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + AppConfig.campusPctiFeedbackBffApiKey,
    },
    body: jsonEncode(applicantConsent.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to update Evaluation.');
  }
}

Future<http.Response> deleteEvaluation(String id) async {
  final http.Response response = await http.delete(
    Uri.parse(AppConfig.campusPctiFeedbackBffApiUrl + '/evaluations/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + AppConfig.campusPctiFeedbackBffApiKey,
    },
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception("Failed to delete Evaluation.");
  }
}
