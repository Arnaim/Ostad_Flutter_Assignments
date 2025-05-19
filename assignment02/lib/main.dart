import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kalpurush', // Default font for both English and Bengali
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String seatsLeftText = "সিট বাকি";
  final String daysLeftText = "দিন বাকি";
  DateTime targetDate = DateTime.now().add(const Duration(days: 30));

  // List created to add the country images and other information
  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Full Stack Web Development with JavaScript (MERN)',
      'image': 'assets/images/Bangladesh.png',
      'seats': '১০',
      'daysOffset': 0,
    },
    {
      'title': 'App Development with Flutter',
      'image': 'assets/images/Germany.png',
      'seats': '১৫',
      'daysOffset': 5,
    },
    {
      'title': 'Full Stack Web Development ASP.NET CORE',
      'image': 'assets/images/Iceland.png',
      'seats': '০৮',
      'daysOffset': 2,
    },
    {
      'title': 'Full Stack Web Development with Python, Django & React',
      'image': 'assets/images/Cambodia.png',
      'seats': '১২',
      'daysOffset': 7,
    },
    {
      'title': 'Full Stack Web Development with PHP, Laravel & Vue.js',
      'image': 'assets/images/Japan.png',
      'seats': '০৯',
      'daysOffset': 3,
    },
    {
      'title': 'SQL Manual & Automated Testing',
      'image': 'assets/images/Brazil.png',
      'seats': '২০',
      'daysOffset': 10,
    },
    {
      'title': 'Mobile App Development with React Native',
      'image': 'assets/images/Ireland.png',
      'seats': '১৪',
      'daysOffset': 4,
    },
    {
      'title': 'Data Science with Python',
      'image': 'assets/images/South_Africa.png',
      'seats': '০৭',
      'daysOffset': 1,
    },
  ];

  // Timer logic
  Duration get remainingTime => targetDate.difference(DateTime.now());

  // Responsive grid columns
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1024) return 4; // Desktop
    if (width > 768) return 3;  // Tablet
    return 2;                   // Mobile
  }

  @override
  void initState() {
    super.initState();
    // Update timer every second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) => _buildCourseCard(index),
        ),
      ),
    );
  }

Widget _buildCourseCard(int index) {
  final daysLeft = remainingTime.inDays + courses[index]['daysOffset'];

  return LayoutBuilder(
    builder: (context, constraints) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flag image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    courses[index]['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.flag, size: 50),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Seats and Days Left
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seatsLeftText, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      Text(courses[index]['seats'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(daysLeftText, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      Text(
                        _convertToBengaliNumerals(daysLeft.toString()),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Course title
              Text(
                courses[index]['title'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('Enroll pressed for ${courses[index]['title']}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(227, 229, 231, 0.996),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'বিস্তারিত দেখি',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//comparing Bengali with English numericals 
  String _convertToBengaliNumerals(String englishNumber) {
    const englishToBengali = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    return englishNumber.split('').map((digit) => 
      englishToBengali[digit] ?? digit
    ).join('');
  }
}