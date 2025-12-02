import 'dart:convert';
import 'package:flutter/services.dart';

const categories = [
  'Fashion & Style',
  'Beauty & Makeup',
  'Lifestyle',
  'Cooking & Food',
  'Parenting & Family',
  'Digital Creator',
  'Travel',
  'Music & Dance',
  'Art & Design',
  'Photography',
  'Health & Fitness',
  'Meme page',
  'Education & Learning',
  'Finance & Business',
  'Pets & Animals',
  'Tech & Gadgets',
  'Gaming',
  'Self-Improvement',
  'Sports & Outdoors',
  'Home & Decor',
  'Sustainable Living',
  'Automotive & Cars',
  'Marketplace / Store',
  'Entertainment',
  'News & Politics',
  'Law, Rights & Activism',
  'Religion & Spiritual',
];

const genders = ["Male", "Female", "Other"];

class Country {
  final int id;
  final String label;
  final String countryCode;
  final String currency;

  Country({
    required this.id,
    required this.label,
    required this.countryCode,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      label: json['label'],
      countryCode: json['countryCode'],
      currency: json['currency'],
    );
  }
}

Future<List<Country>> loadCountries() async {
  final String response = await rootBundle.loadString(
    'lib/core/constants/countries.json',
  );
  final List<dynamic> data = json.decode(response);
  return data.map((json) => Country.fromJson(json)).toList();
}
