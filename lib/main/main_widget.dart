// Import necessary files and packages
import '/backend/gemini/gemini.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
export 'main_model.dart';

// Define a StatefulWidget named MainWidget
class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

// Define the state for MainWidget
class _MainWidgetState extends State<MainWidget> {
  // Initialize a MainModel instance
  late MainModel _model;

  // Create a GlobalKey for the scaffold
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Create the MainModel instance using createModel method
    _model = createModel(context, () => MainModel());
  }

  @override
  void dispose() {
    // Dispose the model
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes in FFAppState
    context.watch<FFAppState>();

    // GestureDetector to handle taps outside text fields
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        // Set background color
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            title: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Text(
                'Animalize',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      fontSize: 60.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            actions: const [],
            centerTitle: false,
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Stack(
              children: [
                // Background image
                Opacity(
                  opacity: 0.15,
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1613408181923-f058a1b0e00c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyNHx8Z3JlZW58ZW58MHx8fHwxNzEyMzQ5NzUyfDA&ixlib=rb-4.0.3&q=80&w=1080',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.0, 0.0),
                      ),
                    ),
                  ),
                ),
                ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    // Conditional rendering based on FFAppState
                    if (FFAppState().ImagePath != 'uploaded')
                      Opacity(
                        opacity: 0.0,
                        child: Container(
                          width: 100.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                        ),
                      ),
                   // Check if an image has been uploaded
                    if (FFAppState().ImagePath == 'uploaded')
                    // Align the text slightly above the center of the screen
                    Align(
                        alignment: const AlignmentDirectional(0.0, -0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          // Display the generated output text
                          child: Text(
                            valueOrDefault<String>(
                              _model.output,
                              'Output',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                    // Upload button
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            // Show media picker bottom sheet
                            final selectedMedia =
                                await selectMediaWithSourceBottomSheet(
                              context: context,
                              allowPhoto: true,
                              pickerFontFamily: 'Ubuntu',
                            );
                            // Validate selected media files
                            if (selectedMedia != null &&
                                selectedMedia.every((m) => validateFileFormat(
                                    m.storagePath, context))) {
                              setState(() => _model.isDataUploading = true);
                              var selectedUploadedFiles = <FFUploadedFile>[];
                              try {
                                selectedUploadedFiles = selectedMedia
                                    .map((m) => FFUploadedFile(
                                          name: m.storagePath.split('/').last,
                                          bytes: m.bytes,
                                          height: m.dimensions?.height,
                                          width: m.dimensions?.width,
                                          blurHash: m.blurHash,
                                        ))
                                    .toList();
                              } finally {
                                _model.isDataUploading = false;
                              }
                              if (selectedUploadedFiles.length ==
                                  selectedMedia.length) {
                                setState(() {
                                  _model.uploadedLocalFile =
                                      selectedUploadedFiles.first;
                                });
                              } else {
                                setState(() {});
                                return;
                              }
                            }
                            // Generate text from uploaded image
                            await geminiTextFromImage(
                              context,
                              'You are one of the best zoologists in the world. When looking at the image look at coloration and patterns to help identify the animal. Please add this information for a single animal with bullet points and breaks in between each piece of information:  Disclaimer: (Add disclaimer about respecting all animals no matter their danger level. Include that it may not be the correct animal due to AI problems.)     Status of: (Not inherently dangerous.) (Proceed with Caution.)  (Dangerous, do not interact!)     Name of Animal: (Input animal name here)     What to do if attacked or bitten by the animal:    About Animal: (Include Appearance, Behavior, Diet, and Habitat) ',
                              uploadImageBytes: _model.uploadedLocalFile,
                            ).then((generatedText) {
                              safeSetState(() => _model.output = generatedText);
                            });
                            setState(() {
                              FFAppState().ImagePath = 'uploaded';
                            });
                            setState(() {});
                          },
                          text: 'Upload',
                          options: FFButtonOptions(
                            width: 300.0,
                            height: 100.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 40.0,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 3.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
