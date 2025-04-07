import 'package:flutter/material.dart';

class PetCareTipsPage extends StatefulWidget {
  static const String id = 'pet-care';

  @override
  _PetCareTipsPageState createState() => _PetCareTipsPageState();
}

class _PetCareTipsPageState extends State<PetCareTipsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allTips = [
  {
    'title': 'Regular Vet Visits',
    'description':
        'Taking your pet to the vet regularly helps in early detection of any health issues.',
    'icon': Icons.local_hospital,
    'color': Colors.redAccent,
  },
  {
    'title': 'Balanced Diet',
    'description':
        'Ensure your pet gets a proper diet rich in nutrients suitable for their species.',
    'icon': Icons.restaurant,
    'color': Colors.green,
  },
  {
    'title': 'Daily Exercise',
    'description':
        'Exercise helps maintain your pet’s physical and mental well-being.',
    'icon': Icons.directions_run,
    'color': Colors.blue,
  },
  {
    'title': 'Hydration',
    'description':
        'Always provide access to clean, fresh water to avoid dehydration.',
    'icon': Icons.water_drop,
    'color': Colors.lightBlue,
  },
  {
    'title': 'Grooming',
    'description':
        'Regular grooming keeps your pet clean and reduces chances of infection.',
    'icon': Icons.spa,
    'color': Colors.purple,
  },
  {
    'title': 'Mental Stimulation',
    'description':
        'Use toys and games to engage your pet’s mind and prevent boredom.',
    'icon': Icons.psychology,
    'color': Colors.orange,
  },
  {
    'title': 'Vaccinations',
    'description':
        'Keep your pet’s vaccinations up-to-date to protect against diseases.',
    'icon': Icons.vaccines,
    'color': Colors.teal,
  },
  {
    'title': 'Proper ID Tags',
    'description':
        'Ensure your pet has proper identification like a tag or microchip in case they get lost.',
    'icon': Icons.badge,
    'color': Colors.deepOrange,
  },
  {
    'title': 'Safe Environment',
    'description':
        'Create a safe space for your pet to avoid injuries and accidents.',
    'icon': Icons.shield,
    'color': Colors.deepPurple,
  },
  {
    'title': 'Regular Dental Care',
    'description':
        'Brush your pet’s teeth or provide dental treats to maintain oral hygiene.',
    'icon': Icons.medical_services,
    'color': Colors.cyan,
  },
  {
    'title': 'Training & Discipline',
    'description':
        'Basic training helps pets understand commands and behave better.',
    'icon': Icons.school,
    'color': Colors.lime,
  },
  {
    'title': 'Regular Check for Parasites',
    'description':
        'Use anti-parasite treatments to keep fleas, ticks, and worms away.',
    'icon': Icons.bug_report,
    'color': Colors.pinkAccent,
  },
  {
    'title': 'Socialization',
    'description':
        'Let your pet interact with other animals and people to build confidence.',
    'icon': Icons.group,
    'color': Colors.brown,
  },
  {
    'title': 'Safe Toys',
    'description':
        'Give your pet safe, non-toxic toys appropriate to their size and age.',
    'icon': Icons.toys,
    'color': Colors.amber,
  },
  {
    'title': 'Consistent Routine',
    'description':
        'Pets feel secure with a predictable schedule for meals, play, and walks.',
    'icon': Icons.schedule,
    'color': Colors.indigo,
  },
  {
    'title': 'Comfortable Bedding',
    'description':
        'Provide soft, clean bedding in a quiet area where your pet can rest peacefully.',
    'icon': Icons.bed,
    'color': Colors.blueGrey,
  },
  {
    'title': 'Temperature Awareness',
    'description':
        'Avoid leaving pets in hot or cold environments for too long.',
    'icon': Icons.thermostat,
    'color': Colors.red,
  },
  {
    'title': 'Neutering/Spaying',
    'description':
        'Consider neutering to prevent overpopulation and reduce certain behavioral issues.',
    'icon': Icons.health_and_safety,
    'color': Colors.greenAccent,
  },
  {
    'title': 'Travel Safety',
    'description':
        'Use pet seatbelts, carriers, or crates while traveling to ensure safety.',
    'icon': Icons.airport_shuttle,
    'color': Colors.black,
  },
  {
    'title': 'Love & Attention',
    'description':
        'Spend quality time daily with your pet to strengthen your bond and keep them emotionally happy.',
    'icon': Icons.favorite,
    'color': Colors.pink,
  },
];


  List<Map<String, dynamic>> filteredTips = [];

  @override
  void initState() {
    super.initState();
    filteredTips = allTips;
    _searchController.addListener(_filterTips);
  }

  void _filterTips() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredTips = allTips;
      } else {
        filteredTips = allTips.where((tip) {
          final title = tip['title'].toString().toLowerCase();
          final description = tip['description'].toString().toLowerCase();
          return title.contains(query) || description.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 220,
            backgroundColor: Colors.teal,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Pet Care Tips'),
              background: Image.asset(
                'lib/assets/images/pet_banner.jpg', 
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search tips...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          filteredTips.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'No tips found.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tip = filteredTips[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: tip['color'],
                              child: Icon(
                                tip['icon'],
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              tip['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                tip['description'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: filteredTips.length,
                  ),
                ),
        ],
      ),
    );
  }
}
