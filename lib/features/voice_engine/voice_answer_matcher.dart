import 'dart:math';
import 'package:flutter/foundation.dart';

class VoiceAnswerMatcher {
  /// Evaluates if the spoken string is numerically equal to the expected string
  /// after normalizing number words to digits.
  static bool evaluateAnswer(String spoken, String expected) {
    debugPrint('🎤 Heard: "$spoken" | 🎯 Expected: "$expected"');
    
    final int? parsedSpoken = _extractInteger(spoken);
    final int? parsedExpected = _extractInteger(expected);

    debugPrint('🎤 Parsed Spoken Value: $parsedSpoken | 🎯 Parsed Expected Value: $parsedExpected');

    if (parsedSpoken != null && parsedExpected != null) {
      if (parsedSpoken == parsedExpected) return true;
    }

    // Fallback to strict string match (or substring) in case it's not a pure number
    final processedSpoken = _preprocessString(spoken);
    final processedExpected = _preprocessString(expected);

    if (processedSpoken.isEmpty && processedExpected.isEmpty) return true;
    if (processedSpoken.isEmpty || processedExpected.isEmpty) return false;

    if (processedSpoken == processedExpected || processedSpoken.contains(processedExpected)) {
      return true;
    }

    final distance = _levenshteinDistance(processedSpoken, processedExpected);
    final maxLength = max(processedSpoken.length, processedExpected.length);

    final similarity = 1.0 - (distance / maxLength);
    return similarity >= 0.75;
  }

  static int? _extractInteger(String input) {
    String result = input.toLowerCase();

    // Map common number words across languages (English, Marathi, Hindi)
    // Ordered from longest phrases to shortest to avoid partial replacement bugs
    final wordToNum = {
      'twenty five': '25', 'पंचवीस': '25', 'panchvis': '25',
      'twenty four': '24', 'चोवीस': '24', 'chovis': '24',
      'twenty three': '23', 'तेवीस': '23', 'tevis': '23',
      'twenty two': '22', 'बावीस': '22', 'bavis': '22',
      'twenty one': '21', 'एकवीस': '21', 'ekvis': '21',
      'twenty': '20', 'वीस': '20', 'vis': '20', 'बीस': '20', 'bees': '20',
      'nineteen': '19', 'एकोणीस': '19', 'ekonis': '19', 'उन्नीस': '19',
      'eighteen': '18', 'अठरा': '18', 'athra': '18', 'अट्ठारह': '18',
      'seventeen': '17', 'सतरा': '17', 'satra': '17', 'सत्रह': '17',
      'sixteen': '16', 'सोळा': '16', 'sola': '16', 'सोलह': '16',
      'fifteen': '15', 'पंधरा': '15', 'pandhra': '15', 'पंद्रह': '15',
      'fourteen': '14', 'चौदा': '14', 'chauda': '14', 'चौदह': '14',
      'thirteen': '13', 'तेरा': '13', 'tera': '13', 'तेरह': '13',
      'twelve': '12', 'बारा': '12', 'bara': '12', 'बारह': '12',
      'eleven': '11', 'अकरा': '11', 'akara': '11', 'ग्यारह': '11',
      'ten': '10', 'दहा': '10', 'daha': '10', 'दस': '10', 'das': '10',
      'nine': '9', 'नऊ': '9', 'nau': '9', 'नौ': '9',
      'eight': '8', 'आठ': '8', 'aath': '8', 'ath': '8',
      'seven': '7', 'सात': '7', 'saat': '7', 'sat': '7',
      'six': '6', 'सहा': '6', 'saha': '6', 'छह': '6', 'che': '6',
      'five': '5', 'पाच': '5', 'paach': '5', 'pach': '5', 'पांच': '5',
      'four': '4', 'चार': '4', 'chaar': '4', 'char': '4',
      'three': '3', 'तीन': '3', 'teen': '3', 'tin': '3',
      'two': '2', 'दोन': '2', 'don': '2', 'दो': '2', 'do': '2',
      'one': '1', 'एक': '1', 'ek': '1',
      'zero': '0', 'शून्य': '0', 'shunya': '0',
      'thirty': '30', 'तीस': '30', 'tees': '30',
      'forty': '40', 'चाळीस': '40', 'chalis': '40', 'चालीस': '40',
      'fifty': '50', 'पन्नास': '50', 'pannas': '50',
      'sixty': '60', 'साठ': '60', 'saath': '60',
      'seventy': '70', 'सत्तर': '70', 'sattar': '70',
      'eighty': '80', 'ऐंशी': '80', 'ainshi': '80', 'अस्सी': '80',
      'ninety': '90', 'नव्वद': '90', 'navvad': '90', 'नब्बे': '90',
      'hundred': '100', 'शंभर': '100', 'shambhar': '100', 'सौ': '100', 'sau': '100',
    };

    wordToNum.forEach((key, value) {
      result = result.replaceAll(key, value);
    });

    // Normalize Devanagari numerals to Arabic
    const devanagari = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    const arabic = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < devanagari.length; i++) {
      result = result.replaceAll(devanagari[i], arabic[i]);
    }

    // Use regex to extract the first sequence of digits found in the string
    final match = RegExp(r'\d+').firstMatch(result);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    
    return null;
  }

  static String _preprocessString(String input) {
    String result = input.toLowerCase();
    result = result.replaceAll(RegExp(r'[.,!?।]'), '');
    final fillers = ['आहे', 'ना', 'म्हणजे', 'तर'];
    for (final filler in fillers) {
      result = result.replaceAll(RegExp(r'\b' + filler + r'\b'), '');
    }
    result = result.replaceAll(RegExp(r'[^\w\s\u0900-\u097F]'), '');
    return result.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  static int _levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }
}
