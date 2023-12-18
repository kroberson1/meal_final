import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Ideas',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MealScreen(),
    );
  }
}

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  Meal? meal;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['meals'] != null) {
        setState(() {
          meal = Meal.fromJson(data['meals'][0]);
        });
      }
    } else {
      throw Exception('Failed to load random meal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Ideas'),
      ),
      body: meal != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(meal!.thumbnail,
              height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal!.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Category: ${meal!.category}'),
                SizedBox(height: 8),
                Text('Area: ${meal!.area}'),
                SizedBox(height: 8),
                Text('Instructions: ${meal!.instructions}'),
              ],
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          fetchData();
        },
        label: Text('Random Meal'),
        icon: Icon(Icons.shuffle),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}

class Meal {
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;

  Meal({
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['strMeal'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
    );
  }
}
