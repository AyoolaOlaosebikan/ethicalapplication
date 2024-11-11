import 'dart:convert';
import 'package:flutter/material.dart';
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
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': message}
        ],
        'max_tokens': 100,
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