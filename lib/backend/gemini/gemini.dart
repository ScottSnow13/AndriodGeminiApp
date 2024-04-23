import 'package:flutter/material.dart'; // Importing the material package which provides the Flutter UI framework.
import 'package:google_generative_ai/google_generative_ai.dart'; // Importing the Google Generative AI package.
import 'package:http/http.dart' as http; // Importing the http package and aliasing it as 'http'.
import '/flutter_flow/flutter_flow_util.dart'; // Importing utility functions from the flutter_flow package.

const _kGemeniApiKey = 'Active API Key'; // Declaring a constant variable for the API key.

// Asynchronous function to generate text using the Gemini Generative AI model.
Future<String?> geminiGenerateText(
  BuildContext context,
  String prompt,
) async {
  final model = GenerativeModel(model: 'gemini-pro', apiKey: _kGemeniApiKey); // Creating an instance of the GenerativeModel with specified model and API key.
  final content = [Content.text(prompt)]; // Creating content for the model input with the provided prompt.

  try {
    final response = await model.generateContent(content); // Generating content using the model and content.
    return response.text; // Returning the generated text.
  } catch (e) {
    showSnackbar( // Showing a Snackbar in case of an error.
      context,
      e.toString(), // Showing the error message.
    );
    return null; // Returning null in case of an error.
  }
}

// Asynchronous function to count tokens in the generated text using the Gemini Generative AI model.
Future<String?> geminiCountTokens(
  BuildContext context,
  String prompt,
) async {
  final model = GenerativeModel(model: 'gemini-pro', apiKey: _kGemeniApiKey); // Creating an instance of the GenerativeModel with specified model and API key.
  final content = [Content.text(prompt)]; // Creating content for the model input with the provided prompt.

  try {
    final response = await model.countTokens(content); // Counting tokens in the generated content.
    return response.totalTokens.toString(); // Returning the total number of tokens as a string.
  } catch (e) {
    showSnackbar( // Showing a Snackbar in case of an error.
      context,
      e.toString(), // Showing the error message.
    );
    return null; // Returning null in case of an error.
  }
}

// Asynchronous function to load image bytes from a URL using the http package.
Future<Uint8List> loadImageBytesFromUrl(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl)); // Fetching the image bytes from the specified URL.

  if (response.statusCode == 200) { // Checking if the response status code indicates success.
    return response.bodyBytes; // Returning the image bytes.
  } else {
    throw Exception('Failed to load image'); // Throwing an exception if failed to load image.
  }
}

// Asynchronous function to generate text from an image using the Gemini Generative AI model.
Future<String?> geminiTextFromImage(
  BuildContext context,
  String prompt, {
  String? imageNetworkUrl = '',
  FFUploadedFile? uploadImageBytes,
}) async {
  assert(
    imageNetworkUrl != null || uploadImageBytes != null,
    'Either imageNetworkUrl or uploadImageBytes must be provided.', // Asserting that either imageNetworkUrl or uploadImageBytes must be provided.
  );

  final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: _kGemeniApiKey); // Creating an instance of the GenerativeModel with specified model and API key.
  final imageBytes = uploadImageBytes != null
      ? uploadImageBytes.bytes
      : await loadImageBytesFromUrl(imageNetworkUrl!); // Loading image bytes either from upload or from the specified URL.
  final content = [
    Content.multi([
      TextPart(prompt), // Adding the text prompt as part of the content.
      DataPart('image/jpeg', imageBytes!), // Adding the image bytes as part of the content.
    ])
  ];

  try {
    final response = await model.generateContent(content); // Generating content using the model and content.
    return response.text; // Returning the generated text.
  } catch (e) {
    showSnackbar( // Showing a Snackbar in case of an error.
      context,
      e.toString(), // Showing the error message.
    );
    return null; // Returning null in case of an error.
  }
}
