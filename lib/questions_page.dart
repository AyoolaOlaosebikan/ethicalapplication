import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'chatgptcall.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _selectedValue =
      'Is it ethical for companies to collect and sell personal data without explicit consent from users?';

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChatGPTCall gptCall = ChatGPTCall();
  String _response = '';
  String _response2 = '';

  List<String> responses = [];
  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  void _loadResponses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedResponses = prefs.getStringList('responses') ?? [];
    setState(() {
      responses = savedResponses;
    });
  }

  void saveResponses(List<String> responses) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('responses', responses);
  }

  void _sendToChatGpt() async {
    String question = _controller.text;
    if (question.isNotEmpty) {
      _response = 'Loading...';
      try {
        String response = await gptCall.sendMessage(question);
        setState(() {
          _response = response;
          print(response);
          responses.add(response);
        });
      } catch (e) {
        print("Failed to load response: $e");
        setState(() {
          _response = 'Failed to get a response. Please try again.';
        });
      }
    }
  }

  void _sendToChatGpt2(String dragdown, String position) async {
    _response2 = 'Loading...';
    try {
      String response = await gptCall.sendMessage(dragdown + position);
      setState(() {
        _response2 = response;
        print(response);
        responses.add(response);
      });
    } catch (e) {
      print("Failed to load response: $e");
      setState(() {
        _response2 = 'Failed to get a response. Please try again.';
      });
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
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    //setting color to abc7ff
                    color: Color.fromARGB(255, 171, 199, 255),
                  ),
                  child: const Align(
                    alignment: Alignment
                        .bottomLeft, // Align the text to the bottom left
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Ethical App',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Ask Questions'),
                  onTap: () {
                    // Navigate to Ask Questions
                    Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/askQuestions',
                        (_) => false);
                  },
                ),
                ListTile(
                  title: const Text('Results'),
                  onTap: () {
                    // Navigate to View Questions
                    saveResponses(responses);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/resultsPage',
                      (_) => false,
                    );
                  },
                ),
                ListTile(
                  title: const Text('About Us'),
                  onTap: () {
                    // Navigate to Settings
                    Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/aboutUs', 
                        (_) => false);
                  },
                ),
                ListTile(
                  title: const Text('Log out'),
                  onTap: () {
                    // Navigate to Settings
                    Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/', 
                        (_) => false);
                  },
                ),
              ],
            ),
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
                      child: Text(
                        'Input Text',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    'Preset Questions': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Preset Questions',
                        style: TextStyle(color: Colors.black),
                      ),
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
                  // Customize the appearance of the segmented control
                  selectedColor: const Color.fromARGB(255, 171, 199, 255),
                  unselectedColor: Colors.white,
                  borderColor: const Color.fromARGB(255, 97, 65, 65),
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
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 300.0,
                        maxHeight: 300.0,
                      ),
                      child: SizedBox(
                        width: 325,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Set the outline color
                                width: .75, // Adjust the outline thickness
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: MarkdownBody(
                                    data: _response,
                                    styleSheet: MarkdownStyleSheet(
                                      p: const TextStyle(fontSize: 16),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ] else if (_selectedOption == 'Preset Questions') ...[
                  Container(
                    width: 325,
                    height: 200,
                    child: DropdownButtonFormField<String>(
                      itemHeight: 120,
                      value: _selectedValue,
                      isExpanded: true,
                      items: <String>[
                        'Is it ethical for companies to collect and sell personal data without explicit consent from users?',
                        'Should artificial intelligence systems be allowed to make life-and-death decisions, such as in self-driving cars or military drones?',
                        'Is it morally acceptable for wealthy nations to prioritize their economic growth over taking action to combat climate change, considering its global impact?',
                        'Is it ethical for doctors to withhold information from a patient about their diagnosis if it’s believed to be in the patient’s best interest?',
                        ' Should social media platforms be responsible for monitoring and removing harmful content, or should freedom of speech take precedence?',
                        'Is it ethical to use animals for testing in the development of new drugs, cosmetics, or other products?',
                        'Should the government make education free for all, or should it be an individual’s responsibility to pay for higher education?',
                        'Should parents be allowed to genetically engineer their children for traits like intelligence, appearance, or athleticism?',
                        'Is it ethical for employers to track employees’ productivity or location through surveillance technology?',
                        'Should corporations be obligated to act in a way that benefits society, even if it reduces their profits?'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValue = newValue!;
                        });
                      },
                      iconSize: 24,
                      isDense: false,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the buttons horizontally
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _sendToChatGpt2(_selectedValue,
                              " Answer this question in favor of.");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('For'),
                      ),
                      const SizedBox(width: 16), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          _sendToChatGpt2(_selectedValue,
                              " Answer this question neutrally.");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Neutral'),
                      ),
                      const SizedBox(width: 16), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          _sendToChatGpt2(
                              _selectedValue, " Answer this question against.");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Against'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 300,
                    width: 325,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Set the outline color
                            width: .75, // Adjust the outline thickness
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: MarkdownBody(
                                data: _response2,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(fontSize: 16),
                                )),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ));
  }
}
