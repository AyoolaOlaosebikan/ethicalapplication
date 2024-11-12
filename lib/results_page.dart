import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
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

  Future<void> _clearResponses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('responses'); // Remove the stored responses
    setState(() {
      responses = []; // Clear the local list
    });
  }

  void _showFullText(BuildContext context, String fullText) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullText,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete), // Trash can icon
            onPressed: () {
              // Show a confirmation dialog before clearing
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Clear Responses'),
                    content:
                        const Text('Are you sure you want to clear all responses?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _clearResponses(); // Clear the responses
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
                alignment:
                    Alignment.bottomLeft, // Align the text to the bottom left
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Ethical App',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Ask Questions'),
              onTap: () {
                // Navigate to Ask Questions
                Navigator.pushNamedAndRemoveUntil(context, 
                '/askQuestions'
                , (_) => false);
              },
            ),
            ListTile(
              title: const Text('Results'),
              onTap: () {
                // Navigate to View Questions
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/resultsPage',
                  (_) => false
                );
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                // Navigate to Settings
                Navigator.pushNamedAndRemoveUntil(context, 
                '/aboutUs'
                , (_) => false);
              },
            ),
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                // Navigate to Settings
                Navigator.pushNamedAndRemoveUntil(
                context, 
                '/',
                (_) => false
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: responses.length,
        itemBuilder: (context, index) {
          // Get the first 420 characters of the response
          String shortenedResponse = responses[index].length > 420
              ? '${responses[index].substring(0, 420)}...'
              : responses[index];

          return ListTile(
            title: Text(shortenedResponse),
            onTap: () {
              // Navigate to the details page when a result is tapped
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         FullResponsePage(response: responses[index]),
              //   ),
              // );
              _showFullText(context, responses[index]);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}

// class FullResponsePage extends StatelessWidget {
//   final String response;

//   const FullResponsePage({super.key, required this.response});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Full Response')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Text(
//             response,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }
