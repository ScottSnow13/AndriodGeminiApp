// Import necessary files and packages
import '/flutter_flow/flutter_flow_util.dart';
import 'main_widget.dart' show MainWidget;
import 'package:flutter/material.dart';

// Define MainModel class extending FlutterFlowModel
class MainModel extends FlutterFlowModel<MainWidget> {
  // State fields for stateful widgets in this page.
 // unfocusNode: A FocusNode instance used to manage focus within the widget tree.
  final unfocusNode = FocusNode();
   // isDataUploading: A boolean flag indicating whether data is currently being uploaded.
  bool isDataUploading = false;
 // uploadedLocalFile: An instance of FFUploadedFile representing the uploaded file. It's initialized with an empty Uint8List.
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
