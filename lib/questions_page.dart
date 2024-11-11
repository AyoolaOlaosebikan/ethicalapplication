import 'package:flutter/material.dart';
import 'chatgptcall.dart';
import 'package:flutter/cupertino.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  String _selectedOption = 'Input Text';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChatGPTCall gptCall = ChatGPTCall();
  String _response = '';

  void _sendToChatGpt() async {
    print("hi niggas");
    String question = _controller.text;
    if (question.isNotEmpty) {
      try {
        String response = await gptCall.sendMessage(question);
        setState(() {
          _response = response;
        });
      } catch (e) {
        print("Failed to load response: $e");
        setState(() {
          _response = 'Failed to get a response. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ask Questions!'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CupertinoSegmentedControl<String>(
                  padding: const EdgeInsets.all(8),
                  // Define the segmented control options
                  children: const {
                    'Input Text': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Input Text'),
                    ),
                    'Preset Questions': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Preset Questions'),
                    )
                  },
                  // Current selected option
                  groupValue: _selectedOption,
                  onValueChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                    // Handle segmented control option change
                    print('Selected: $value');
                  },
                  // Customize the appearance
                  selectedColor: Colors.blue,
                  unselectedColor: Colors.grey[300],
                  borderColor: Colors.blue,
                  pressedColor: Colors.blue.withOpacity(0.2),
                ),
                const SizedBox(height: 32),
                if (_selectedOption == 'Input Text') ...[
                  const Text(
                    'Tap below to type a question:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    width: 325,
                    child: TextField(
                      controller: _controller,
                      maxLines: 8,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Enter your question',
                        hintText: 'Type your question here...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        print("Question entered: $text");
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _sendToChatGpt();
                      print("Submitted question: ${_controller.text}");
                      _controller.clear();
                      _focusNode.unfocus();
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 300,
                    width: 325,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Response: $_response',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ] else if (_selectedOption == 'Preset Questions') ...[
                  // const Text(
                  //   'Choose a preset question:',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  // const SizedBox(height: 16),
                  // // Display a list of preset questions
                  // ..._presetQuestions.map((question) => ListTile(
                  //       title: Text(question),
                  //       onTap: () {
                  //         print("Selected question: $question");
                  //       },
                  //     )),
                ],
              ],
            ),
          ),
        ));
  }
}
