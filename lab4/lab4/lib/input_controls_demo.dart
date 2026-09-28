import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _ratingValue = 50.0;
  bool _isMovieActive = false;
  String? _selectedGenre;
  DateTime? _selectedDate;

  // Hàm mở DatePicker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 – Input Controls'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Rating Slider
            const Text('Rating (Slider)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              value: _ratingValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _ratingValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _ratingValue = value;
                });
              },
            ),
            Text('Current value: ${_ratingValue.round()}'),
            const SizedBox(height: 24),

            // 2. Active Switch
            const Text('Active (Switch)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Is movie active?'),
              value: _isMovieActive,
              onChanged: (bool value) {
                setState(() {
                  _isMovieActive = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // 3. Genre Radio Group
            const Text('Genre (RadioListTile)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              onChanged: (value) => setState(() => _selectedGenre = value),
            ),
            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              onChanged: (value) => setState(() => _selectedGenre = value),
            ),
            Text('Selected genre: ${_selectedGenre ?? "None"}'),
            const SizedBox(height: 24),

            // 4. Date Picker Button
            Center(
              child: ElevatedButton(
                onPressed: _pickDate,
                child: const Text('Open Date Picker'),
              ),
            ),
            if (_selectedDate != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}