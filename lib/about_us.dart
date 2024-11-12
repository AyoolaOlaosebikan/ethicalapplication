import 'package:flutter/material.dart';

// About Us Page
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
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
                '/askQuestions',
                (_) => false
                );
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
                '/aboutUs',
                (_) => false
                );
              },
            ),
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                // Navigate to Settings
                Navigator.pushNamedAndRemoveUntil(context, 
                '/',
                (_) => false
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildPersonCard(
            imagePath: 'assets/images/davis_lynn.png',
            name: 'Davis Lynn',
            classification: 'Junior',
            major: 'Finance, Computer Science (AI Focus), Data Science',
            funFact: 'I competitively surf',
          ),
          const SizedBox(height: 16),
          buildPersonCard(
            imagePath: 'assets/images/ayoola_olaosebikan.png',
            name: 'Ayoola Olaosebikan',
            classification: 'Junior',
            major: 'Computer Science (Software Engineering), Data Science',
            funFact: 'I have a twin brother',
          ),
          const SizedBox(height: 16),
          buildPersonCard(
            imagePath: 'assets/images/luke_berridge.jpg',
            name: 'Luke Berridge',
            classification: 'Senior',
            major: 'Computer Science (AI/ML)',
            funFact: 'I have family buried in the Vatican',
          ),
        ],
      ),
    );
  }

  Widget buildPersonCard({
    required String imagePath,
    required String name,
    required String classification,
    required String major,
    required String funFact,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Classification: $classification',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Major: $major',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Fun Fact: $funFact',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
