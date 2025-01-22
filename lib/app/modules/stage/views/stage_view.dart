import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../controllers/stage_controller.dart';

class StageView extends StatelessWidget {
  final StageController stageController = Get.put(StageController());
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stage Management'),
        actions: [

            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                themeController.toggleTheme(); // Toggle the theme
              },
            ),
        ],
      ),
      body: Obx(() {
        if (stageController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: stageController.stages.length,
            itemBuilder: (context, index) {
              final stage = stageController.stages[index];
              return ListTile(
                title: Text(stage['title'] ?? 'No Title'),
                subtitle: Text('ID: ${stage['id']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        final updatedStage = {
                          "title": "Updated Title",
                          "body": "Updated content.",
                          "id": index+1,
                        };
                        stageController.updateStage(index, updatedStage);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        stageController.deleteStage(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newStage = {
            "userId": stageController.stages.length + 1,
            "title": "New Stage",
            "body": "Description of the new stage.",
            "id": stageController.stages.length + 1,
          };
          stageController.addStage(newStage);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

