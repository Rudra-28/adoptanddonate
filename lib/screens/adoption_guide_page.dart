import 'package:adoptanddonate_new/screens/animal_guide_detail_page.dart';
import 'package:flutter/material.dart';

class AnimalGuideSelectionPage extends StatelessWidget {
  static const String id = 'animal-guide-selection';

 final List<Map<String, dynamic>> animals = [
  {
    'name': 'Dogs',
    'image': 'lib/assets/images/dog.png',
    'color': Colors.orangeAccent,
  },
  {
    'name': 'Cats',
    'image': 'lib/assets/images/cat.png',
    'color': Colors.pinkAccent,
  },
  {
    'name': 'Birds',
    'image': 'lib/assets/images/bird.png',
    'color': Colors.lightBlueAccent,
  },
  {
    'name': 'Farm Animals',
    'image': 'lib/assets/images/cow.png',
    'color': Colors.green,
  },
  {
    'name': 'Fish',
    'image': 'lib/assets/images/fish.png',
    'color': Colors.teal,
  },
  {
    'name': 'Reptiles',
    'image': 'lib/assets/images/tortoise.png',
    'color': Colors.deepPurple,
  },
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adoption Guides'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: animals.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final animal = animals[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AnimalGuideDetailPage.id,
                  arguments: animal['name'],
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                color: animal['color'].withOpacity(0.85),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          animal['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      animal['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
