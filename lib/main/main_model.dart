// Import necessary files and packages
import '/flutter_flow/flutter_flow_util.dart';
import 'main_widget.dart' show MainWidget;
import 'package:flutter/material.dart';

// Define MainModel class extending FlutterFlowModel
class MainModel extends FlutterFlowModel<MainWidget> {
  // State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // Stores action output result for [Gemini - Text From Image] action in Button widget.
  String? output;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    // Dispose the unfocusNode
    unfocusNode.dispose();
  }
}
