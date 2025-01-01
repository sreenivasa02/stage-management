import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StageController extends GetxController {
  var isLoading = true.obs;
  var stages = <Map<String, dynamic>>[].obs;

  static const baseUrl = 'https://dummy-json.mock.beeceptor.com/posts'; // Base URL

  @override
  void onInit() async {
    super.onInit();
    await fetchStages();
  }


  Future<void> fetchStages() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        stages.value = data.cast<Map<String, dynamic>>();
      } else {
        print('Failed to load stages: ${response.statusCode}');
      }
    } finally {
      isLoading(false);
    }
  }


  Future<void> addStage(Map<String, dynamic> newStage) async {
    try {
      isLoading(true);
      final responsePost = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
       // body: jsonEncode(newStage),
      );

      if (responsePost.statusCode == 200 || responsePost.statusCode == 201) {
        stages.add(newStage);//json.decode(responsePut.body);
        print("Stage added successfully.");
      } else {
        print('Failed to add stage: ${responsePost.statusCode}');
      }
    } finally {
      isLoading(false);
    }
  }


  Future<void> updateStage(int index, Map<String, dynamic> updatedStage) async {
    try {
      isLoading(true);
      final stageId = stages[index]['id'];
      final responsePut = await http.put(
        Uri.parse('$baseUrl/$stageId'),
        headers: {'Content-Type': 'application/json'},
        //body: jsonEncode(updatedStage),
      );

      if (responsePut.statusCode == 200) {
        stages[index] = updatedStage;//json.decode(responsePut.body);
        print("Stage updated successfully.");
      } else {
        print('Failed to update stage: ${responsePut.statusCode}');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteStage(int index) async {
    try {
      isLoading(true);
      final stageId = stages[index]['id'];
      final response = await http.delete(Uri.parse('$baseUrl/$stageId'));

      if (response.statusCode == 200) {
        stages.removeAt(index);
        print("Stage deleted successfully.");
      } else {
        print('Failed to delete stage: ${response.statusCode}');
      }
    } finally {
      isLoading(false);
    }
  }
}
