import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimalGuideDetailPage extends StatelessWidget {
  static const String id = 'animal-guide-detail';

 final Map<String, Map<String, List<String>>> detailedGuideData = {
  'Dogs': {
  'Labrador Retriever': [
    'Friendly, energetic, and great with children—ideal for families.',
    'Needs daily walks and active playtime to prevent obesity.',
    'Highly trainable; enjoys fetch and water activities.',
    'Brush 2–3 times a week; sheds seasonally.',
    'Prone to hip dysplasia and ear infections—regular vet checkups are essential.',
  ],
  'German Shepherd': [
    'Loyal, protective, and very intelligent—suitable for active and experienced owners.',
    'Requires early socialization and consistent obedience training.',
    'Needs vigorous physical and mental stimulation daily.',
    'Double coat needs brushing several times a week.',
    'Prone to joint issues and bloat; routine health checks are necessary.',
  ],
  'Indian Pariah Dog': [
    'Hardy, alert, and highly adaptable to Indian climates.',
    'Naturally healthy with fewer genetic disorders.',
    'Requires moderate exercise and a secure space.',
    'Very low grooming needs—occasional brushing is enough.',
    'Great guard instincts; needs gentle socialization and training.',
  ],
  'Doberman': [
    'Intelligent, sleek, and loyal—makes an excellent guard dog.',
    'Needs structured training and early socialization.',
    'High energy; requires long walks and stimulating games.',
    'Short coat—easy to groom but sensitive to cold weather.',
    'Needs a confident owner who can provide leadership.',
  ],
  'Golden Retriever': [
    'Affectionate, intelligent, and very social—perfect for families.',
    'Eager to please; easy to train and responds well to positive reinforcement.',
    'Needs daily exercise to manage energy levels.',
    'Sheds heavily; daily brushing helps manage fur.',
    'Regular ear cleaning and grooming necessary due to floppy ears and thick coat.',
  ],
  'Beagle': [
    'Playful and curious; loves to sniff and explore.',
    'Friendly with children and other pets.',
    'Moderate exercise needs but easily distracted by scents.',
    'Short coat—low grooming, but regular ear cleaning is vital.',
    'Can be stubborn—requires patient, reward-based training.',
  ],
},

  'Cats': {
  'Bengal': [
    'Highly energetic and athletic—requires lots of playtime and stimulation.',
    'Intelligent and curious—can learn tricks and enjoy interactive toys.',
    'Short, soft coat—weekly brushing is usually enough.',
    'Needs vertical spaces like cat trees or shelves to climb.',
    'Loyal and affectionate but may not be a lap cat.',
  ],
  'British Shorthair': [
    'Calm, quiet, and independent—suits apartment living well.',
    'Dense plush coat—needs weekly grooming to reduce shedding.',
    'Loves routine and may be shy with strangers.',
    'Not overly active—daily short play sessions are sufficient.',
    'Prone to obesity—monitor diet and encourage movement.',
  ],
  'Siamese': [
    'Vocal, social, and affectionate—craves companionship.',
    'Short coat—minimal grooming required.',
    'Highly intelligent—enjoys puzzle toys and interaction.',
    'Doesn’t like being left alone—best suited for homes with people around.',
    'Can form strong bonds with one or two family members.',
  ],
  'Sphynx': [
    'Hairless but not low-maintenance—needs regular baths to remove skin oils.',
    'Very affectionate, cuddly, and seeks warmth.',
    'Great with kids and other pets—loves attention.',
    'Prone to skin issues and sunburn—keep indoors or shaded.',
    'Needs ear cleaning and nail trimming often.',
  ],
  'Maine Coon': [
    'Gentle giants—very friendly, sociable, and intelligent.',
    'Thick, water-resistant coat—brush 2–3 times a week.',
    'Enjoys playing with water and being around people.',
    'Needs moderate exercise—daily playtime and space to roam.',
    'Prone to heart issues like HCM—regular vet visits are important.',
  ],
},
'Birds': {
  'Pigeons and Doves': [
    'Calm and gentle birds—ideal for both beginners and experienced keepers.',
    'Can be kept in outdoor aviaries or indoor cages with adequate space.',
    'Need a consistent diet of grains and clean water daily.',
    'Very social—thrive better in pairs or groups.',
    'Clean cages regularly to prevent diseases like canker or mites.',
  ],
  'Parrots': [
    'Highly intelligent and talkative—require mental stimulation and social interaction.',
    'Need a large, secure cage with toys, ladders, and perches.',
    'Diet should include seeds, pellets, fruits, and vegetables.',
    'Can live for decades—require long-term commitment.',
    'Prone to boredom and plucking if left alone too long.',
  ],
  'Lovebirds': [
    'Affectionate and often form strong pair bonds.',
    'Small but active—need ample cage space and daily out-of-cage time.',
    'Like to chew—provide bird-safe toys and natural perches.',
    'Diet should include seeds, veggies, fruits, and fresh water.',
    'Can be noisy and territorial—handle with care and patience.',
  ],
  'Budgies': [
    'Popular beginner bird—small, friendly, and easy to care for.',
    'Require regular interaction to remain tame and social.',
    'Diet should include millet, fresh vegetables, and fortified seeds.',
    'Need toys and mirrors to stay entertained.',
    'Sensitive to smoke, fumes, and sudden temperature changes.',
  ],
  'Macaw': [
    'Large, vibrant, and very intelligent birds—need constant stimulation.',
    'Require spacious cages or aviaries with time outside the cage daily.',
    'Diet should include nuts, fruits, vegetables, and formulated pellets.',
    'Extremely loud—suitable for owners who can handle noise.',
    'Form deep bonds with their owners and may show signs of jealousy or stress if ignored.',
  ],
},
'Farm Animals': {
  'Cow': [
    'Cows require a spacious, clean shelter with good ventilation and protection from weather.',
    'Need a diet rich in green fodder, dry hay, and mineral supplements for milk production and health.',
    'Ensure access to clean drinking water at all times.',
    'Regular veterinary check-ups and vaccinations are essential to prevent diseases.',
    'Cows are social—prefer being around other animals. Isolation can lead to stress.',
    'Keep the floor dry and clean to prevent hoof infections and mastitis.',
  ],
  'Buffalo': [
    'Buffaloes need shaded, cool environments—especially during summer due to their heat sensitivity.',
    'Feed them a balanced diet of green fodder, concentrates, and mineral mixtures for optimal milk yield.',
    'Clean and bathe buffaloes daily—many enjoy wallowing in water or mud to cool off.',
    'Provide regular deworming and vaccinations to avoid infections.',
    'Strong and calm animals—suitable for both dairy and draught purposes.',
    'Need strong fencing or secure enclosures to prevent wandering.',
  ],
  'Chicken': [
    'Require a coop with proper lighting, ventilation, and protection from predators.',
    'Feed should include grains, corn, kitchen scraps, and layers feed for egg-laying hens.',
    'Access to clean, fresh water is essential.',
    'Maintain cleanliness in the coop to prevent diseases like coccidiosis and bird flu.',
    'Ensure nesting boxes with clean straw or sawdust for egg-laying hens.',
    'Provide enough space to prevent overcrowding and aggressive behavior.',
  ],
},
'Fish': {
  'Goldfish': [
    'Requires a spacious tank—minimum 20 gallons for one fish.',
    'Prefers cooler water temperatures (65–75°F).',
    'Produce a lot of waste—needs efficient filtration and regular water changes.',
    'Avoid sharp decorations as goldfish have delicate fins.',
    'Goldfish are social and prefer living in groups.',
  ],
  'Guppy': [
    'Small, hardy fish—perfect for beginners.',
    'Thrive in warm water (72–82°F) and a planted tank.',
    'Feed small portions of high-quality flakes or brine shrimp.',
    'Breed rapidly—separate genders if population control is needed.',
    'Peaceful—can be kept with other non-aggressive fish.',
  ],
  'Molly': [
    'Needs a 10+ gallon tank with a heater (74–82°F).',
    'Can live in both freshwater and brackish water.',
    'Feed with flakes, vegetables, and occasional protein like bloodworms.',
    'Very social—best kept in groups.',
    'Livebearers—can reproduce quickly in mixed-gender tanks.',
  ],
  'Angel Fish': [
    'Elegant but semi-aggressive—avoid pairing with small or fin-nipping fish.',
    'Require a tall tank with soft, slightly acidic water.',
    'Temperature range: 76–82°F.',
    'Carnivorous—enjoy flakes, pellets, and frozen or live food.',
    'Need a calm environment with hiding spots.',
  ],
  'Oscar': [
    'Large and intelligent—needs a minimum 55-gallon tank.',
    'Aggressive and territorial—not ideal for community tanks.',
    'Prefers warm water (74–81°F) with strong filtration.',
    'Eats pellets, live food, and treats like earthworms or shrimp.',
    'Responsive to human interaction but needs experienced care.',
  ],
  'Tetras': [
    'Small, colorful fish—ideal for community tanks.',
    'Best kept in schools of 6 or more.',
    'Water temperature: 70–80°F with soft, slightly acidic water.',
    'Peaceful—mix well with guppies, mollies, and gouramis.',
    'Enjoy live plants and hiding areas in the aquarium.',
  ],
  'Gourami': [
    'Available in multiple types—generally peaceful and hardy.',
    'Need medium to large tanks with floating plants.',
    'Prefer warm water (72–82°F) with low flow.',
    'Omnivorous—feed flakes, vegetables, and frozen food.',
    'Can be territorial during mating—monitor tank mates.',
  ],
},
'Reptiles': {
  'Geckos': [
    'Leopard geckos are great for beginners—docile and easy to handle.',
    'Require a 10–20 gallon tank with warm (88–92°F) and cool zones.',
    'Use under-tank heating pads—not heat lamps—for belly warmth.',
    'Feed insects like crickets or mealworms dusted with calcium supplements.',
    'No need for UVB light, but consistent day-night cycle is essential.',
    'Keep humidity levels low to moderate (30–40%).',
  ],
  'Tortoise': [
    'Long-lived pets—can live over 50 years with proper care.',
    'Need large outdoor enclosures or roomy indoor pens with UVB lighting.',
    'Herbivores—feed with grasses, leafy greens, and occasional fruits.',
    'Require access to both basking areas (90–100°F) and shade.',
    'Hydration is important—provide shallow water for soaking and drinking.',
    'Never keep in damp or cold environments—they are prone to respiratory issues.',
  ],
  'Snakes': [
    'Ball pythons and corn snakes are ideal for beginners—non-venomous and calm.',
    'Require secure, escape-proof enclosures with hideouts and climbing options.',
    'Maintain warm temperatures (75–85°F) with a basking spot (90°F).',
    'Feed pre-killed mice or rats depending on size—once every 1–2 weeks.',
    'Humidity levels depend on species (ball pythons: 50–60%).',
    'Handle gently and avoid during shedding or after meals.',
  ],
},

  
};


 @override
Widget build(BuildContext context) {
  final String? animalName = ModalRoute.of(context)?.settings.arguments as String?;
  final Map<String, List<String>>? specificGuides = detailedGuideData[animalName ?? ''];

  return Scaffold(
    appBar: AppBar(
      title: Text('${animalName ?? 'Unknown'} Adoption Guide'),
      backgroundColor: Colors.teal,
    ),
    body: specificGuides != null && specificGuides.isNotEmpty
        ? ListView(
            children: specificGuides.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: entry.value.map((step) {
                  int stepNumber = entry.value.indexOf(step) + 1;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        '$stepNumber',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(step),
                  );
                }).toList(),
              );
            }).toList(),
          )
        : Center(
            child: Text(
              'No guide available for this animal.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
  );
}
}