import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gallery/config/app_config.dart';

class Inventory {
  int? id;
  int? asset_id;
  int? consumable_id;
  int? organization_id;
  int? person_id;
  int? quantity;
  int? quantity_in;
  int? quantity_out;

  Inventory({
    this.id,
    this.asset_id,
    this.consumable_id,
    this.organization_id,
    this.person_id,
    this.quantity,
    this.quantity_in,
    this.quantity_out,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        id: json["id"],
        asset_id: json["asset_id"],
        consumable_id: json["consumable_id"],
        organization_id: json["organization_id"],
        person_id: json["person_id"],
        quantity: json["quantity"],
        quantity_in: json["quantity_in"],
        quantity_out: json["quantity_out"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "asset_id": asset_id,
        "consumable_id": consumable_id,
        "organization_id": organization_id,
        "person_id": person_id,
        "quantity": quantity,
        "quantity_in": quantity_in,
        "quantity_out": quantity_out,
      };
}

Future<List<Inventory>> fetchInventories() async {
  final response = await http.get(
    Uri.parse('${AppConfig.campusAssetsBffApiUrl}/inventories'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
      'Authorization': 'Bearer ${AppConfig.campusBffApiKey}',
    },
  );

  if (response.statusCode == 200) {
    var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Inventory> inventories = await resultsJson
        .map<Inventory>((json) => Inventory.fromJson(json))
        .toList();
    return inventories;
  } else {
    throw Exception('Failed to load Inventories');
  }
}

Future<Inventory> fetchInventory(int id) async {
  final response = await http.get(
    Uri.parse('${AppConfig.campusAssetsBffApiUrl}/inventories/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
      'Authorization': 'Bearer ${AppConfig.campusBffApiKey}',
    },
  );

  if (response.statusCode == 200) {
    return Inventory.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Inventory');
  }
}

Future<http.Response> createInventory(Inventory inventory) async {
  final response = await http.post(
    Uri.parse('${AppConfig.campusAssetsBffApiUrl}/inventories'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AppConfig.campusBffApiKey}',
    },
    body: jsonEncode(inventory.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to create Inventory.');
  }
}

Future<http.Response> updateInventory(Inventory inventory) async {
  final response = await http.put(
    Uri.parse('${AppConfig.campusAssetsBffApiUrl}/inventories/${inventory.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AppConfig.campusBffApiKey}',
    },
    body: jsonEncode(inventory.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to update Inventory.');
  }
}

Future<http.Response> deleteInventory(int id) async {
  final response = await http.delete(
    Uri.parse('${AppConfig.campusAssetsBffApiUrl}/inventories/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AppConfig.campusBffApiKey}',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to delete Inventory.');
  }
}
