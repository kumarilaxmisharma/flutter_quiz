import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelector({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Helper map for language details
    const Map<String, Map<String, String>> languageDetails = {
      'en': {'flag': '🇺🇸', 'name': 'English'},
      'zh': {'flag': '🇨🇳', 'name': '中文'},
      'kh': {'flag': '🇰🇭', 'name': 'ខ្មែរ'},
    };

    return PopupMenuButton<String>(
      onSelected: onLanguageChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (BuildContext context) {
        return languageDetails.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                Text(entry.value['flag']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Text(entry.value['name']!),
              ],
            ),
          );
        }).toList();
      },
      // This is the button the user sees and taps on
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: BoxBorder.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, color: Colors.black54, size: 20),
            const SizedBox(width: 6),
            Text(
              selectedLanguage.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}