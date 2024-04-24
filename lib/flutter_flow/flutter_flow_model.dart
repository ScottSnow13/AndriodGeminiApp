//Import necessary packages and files
import 'package:collection/collection.dart'; 
import 'package:flutter/scheduler.dart'; 
import 'package:provider/provider.dart'; 

// Function to wrap a widget with a model
Widget wrapWithModel<T extends FlutterFlowModel>({
  required T model,
  required Widget child,
  required VoidCallback updateCallback,
  bool updateOnChange = false,
}) {
  // Set the update callback and whether to update on change
  model.setOnUpdate(
    onUpdate: updateCallback,
    updateOnChange: updateOnChange,
  );
  // By default, models for components are disposed by the page's model,
  // so we set disposeOnWidgetDisposal to false for these components.
  model.disposeOnWidgetDisposal = false;
  // Wrap the child with a Provider to access the model
  return Provider<T>.value(
    value: model,
    child: child,
  );
}

// Function to create a model
T createModel<T extends FlutterFlowModel>(
  BuildContext context,
  T Function() defaultBuilder,
) {
  // Retrieve existing model if it exists, otherwise create a new one
  final model = context.read<T?>() ?? defaultBuilder();
  // Initialize the model
  model._init(context);
  return model;
}

// Abstract class for defining a model
abstract class FlutterFlowModel<W extends Widget> {
  bool _isInitialized = false; // Flag to check if the model is initialized
  // Initialization method, to be implemented by subclasses
  void initState(BuildContext context);
  // Internal initialization method
  void _init(BuildContext context) {
    // Initialize only if not already initialized
    if (!_isInitialized) {
      initState(context);
      _isInitialized = true;
    }
    // Set widget associated with this model
    if (context.widget is W) _widget = context.widget as W;
  }

  // Widget associated with this model
  W? _widget;
  W get widget => _widget!; // Non-null assertion, widget should never be null

  // Whether to dispose this model when the corresponding widget is disposed
  bool disposeOnWidgetDisposal = true;
  // Method to dispose the model, to be implemented by subclasses
  void dispose();
  // Method to conditionally dispose the model
  void maybeDispose() {
    if (disposeOnWidgetDisposal) {
      dispose();
    }
    // Remove reference to widget for garbage collection
    _widget = null;
  }

  // Whether to update the containing page / component on updates
  bool updateOnChange = false;
  // Callback function to call when the model receives an update
  VoidCallback _updateCallback = () {};
  void onUpdate() => updateOnChange ? _updateCallback() : () {};
  // Set callback function and whether to update on change
  FlutterFlowModel setOnUpdate({
    bool updateOnChange = false,
    required VoidCallback onUpdate,
  }) =>
      this
        .._updateCallback = onUpdate
        ..updateOnChange = updateOnChange;
  // Update the containing page when this model received an update
  void updatePage(VoidCallback callback) {
    callback(); // Execute provided callback
    _updateCallback(); // Call update callback
  }
}

// Class to manage multiple dynamic models
class FlutterFlowDynamicModels<T extends FlutterFlowModel> {
  FlutterFlowDynamicModels(this.defaultBuilder);

  final T Function() defaultBuilder; // Default builder function
  final Map<String, T> _childrenModels = {}; // Map to store child models
  final Map<String, int> _childrenIndexes = {}; // Map to store child indexes
  Set<String>? _activeKeys; // Set of active model keys

  // Get or create a model by key and index
  T getModel(String uniqueKey, int index) {
    _updateActiveKeys(uniqueKey); // Update active keys
    _childrenIndexes[uniqueKey] = index; // Store index
    return _childrenModels[uniqueKey] ??= defaultBuilder(); // Retrieve or create model
  }

  // Get values from models based on index
  List<S> getValues<S>(S? Function(T) getValue) {
    return _childrenIndexes.entries
        .sorted((a, b) => a.value.compareTo(b.value)) // Sort by index
        .where((e) => _childrenModels[e.key] != null)
        .map((e) => getValue(_childrenModels[e.key]!) ?? _getDefaultValue<S>()!) // Map values
        .toList();
  }

  // Get value from model at specific index
  S? getValueAtIndex<S>(int index, S? Function(T) getValue) {
    final uniqueKey =
        _childrenIndexes.entries.firstWhereOrNull((e) => e.value == index)?.key; // Find key by index
    return getValueForKey(uniqueKey, getValue);
  }

  // Get value from model with specific key
  S? getValueForKey<S>(String? uniqueKey, S? Function(T) getValue) {
    final model = _childrenModels[uniqueKey];
    return model != null ? getValue(model) : null;
  }

  // Dispose all child models
  void dispose() => _childrenModels.values.forEach((model) => model.dispose());

  // Update the set of active keys
  void _updateActiveKeys(String uniqueKey) {
    final shouldResetActiveKeys = _activeKeys == null;
    _activeKeys ??= {};
    _activeKeys!.add(uniqueKey);

    if (shouldResetActiveKeys) {
      // Add a post-frame callback to remove and dispose of unused models after
      // building, then reset `_activeKeys` to null.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _childrenIndexes.removeWhere((k, _) => !_activeKeys!.contains(k)); // Remove unused indexes
        _childrenModels.keys
            .toSet()
            .difference(_activeKeys!)
            .forEach((k) => _childrenModels.remove(k)?.dispose()); // Dispose unused models
        _activeKeys = null;
      });
    }
  }
}

// Function to get default value for a type
T? _getDefaultValue<T>() {
  switch (T) {
    case int:
      return 0 as T;
    case double:
      return 0.0 as T;
    case String:
      return '' as T;
    case bool:
      return false as T;
    default:
      return null as T;
  }
}

// Extension for adding validation to text input fields
extension TextValidationExtensions on String? Function(BuildContext, String?)? {
  String? Function(String?)? asValidator(BuildContext context) =>
      this != null ? (val) => this!(context, val) : null;
}
