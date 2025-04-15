import 'package:billiard_club_frontend/model/selected_cue_response.dart';
import 'package:billiard_club_frontend/model/selected_table_response.dart';

class SelectedResponse {
  final List<SelectedCueResponse> selectedCues;
  final List<SelectedTableResponse> selectedTables;

  SelectedResponse({
    required this.selectedCues,
    required this.selectedTables,
  });

  factory SelectedResponse.fromMap(Map<String, dynamic> json) {
    var cuesList = (json['selectedCues'] as List<dynamic>?)
        ?.map((item) => SelectedCueResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    var tablesList = (json['selectedTables'] as List<dynamic>?)
        ?.map((item) => SelectedTableResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return SelectedResponse(
      selectedCues: cuesList,
      selectedTables: tablesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedCues': selectedCues.map((item) => item.toMap()).toList(),
      'selectedTables': selectedTables.map((item) => item.toMap()).toList(),
    };
  }
}