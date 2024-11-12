import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatGPTCall {
  final String apiKey = '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';

  Future<String> sendMessage(String message) async {
  const url = 'https://api.openai.com/v1/chat/completions';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'user', 'content': message}
        ],
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load response. Status: ${response.statusCode}');
    }
  } catch (e) {
    print("Error sending message: $e");
    return 'Error: Could not get a response from the server';
  }
  }
}