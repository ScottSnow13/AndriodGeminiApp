// Import necessary packages and files
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/index.dart'; // Import index.dart file (not clear from provided code)
import '/flutter_flow/flutter_flow_theme.dart'; // Import Flutter Flow theme
import '/flutter_flow/flutter_flow_util.dart'; // Import Flutter Flow utilities

// Export necessary packages
export 'package:go_router/go_router.dart'; // Export go_router package
export 'serialization_util.dart'; // Export serialization utilities

// Define a constant key for transition information
const kTransitionInfoKey = '__transition_info__';

// Define a class for managing application state
class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._(); // Private constructor

  static AppStateNotifier? _instance; // Singleton instance
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  // State variable to control showing splash image
  bool showSplashImage = true;

  // Method to stop showing splash image
  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners(); // Notify listeners of state change
  }
}

// Function to create a router
GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/', // Initial location for the router
      debugLogDiagnostics: true, // Enable debug log diagnostics
      refreshListenable: appStateNotifier, // Listens for state changes
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              // Show splash image if specified
              builder: (context) => Container(
                color: FlutterFlowTheme.of(context).primary,
                child: Center(
                  child: Image.asset(
                    'assets/images/App_Icon_Square.png',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          : const MainWidget(), // Show main widget otherwise
      routes: [
        // Define routes
        FFRoute(
          name: '_initialize',
          path: '/',
          // Route builder for showing splash image or main widget
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: FlutterFlowTheme.of(context).primary,
                    child: Center(
                      child: Image.asset(
                        'assets/images/App_Icon_Square.png',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : const MainWidget(), // Show main widget
        ),
        FFRoute(
          name: 'Main',
          path: '/main',
          builder: (context, params) => const MainWidget(), // Main route
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(), // Convert routes to GoRouter routes
    );

// Extension for handling navigation parameters
extension NavParamExtensions on Map<String, String?> {
  // Method to filter out null values
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

// Extension for navigation utilities
extension NavigationExtensions on BuildContext {
  // Method to safely pop from navigation stack
  void safePop() {
    if (canPop()) {
      pop(); // Pop if possible
    } else {
      go('/'); // Go to initial page otherwise
    }
  }
}

// Extension for GoRouter state
extension _GoRouterStateExtensions on GoRouterState {
  // Get extra map from state
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  // Get all parameters
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  // Get transition information
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

// Class for handling parameters in routes
class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Check if parameters are empty
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  // Complete async futures
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  // Get parameter value
  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    if (param is! String) {
      return param;
    }
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

// Class representing a route
class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  // Convert FFRoute to GoRoute
  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          // Fix status bar on iOS 16 and below
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
         
