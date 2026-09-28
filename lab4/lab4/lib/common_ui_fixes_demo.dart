import 'package:flutter/material.dart';

class CommonUIFixesDemo extends StatefulWidget {
  const CommonUIFixesDemo({super.key});

  @override
  State<CommonUIFixesDemo> createState() => _CommonUIFixesDemoState();
}

class _CommonUIFixesDemoState extends State<CommonUIFixesDemo> {
  int _counter = 0;
  DateTime? _selectedDate;

  // Lỗi 4 Fix: Sử dụng BuildContext hợp lệ trong StatefulWidget
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      // Lỗi 3 Fix: Bắt buộc dùng setState() để cập nhật lại UI
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Fixes'),
      ),
      // Lỗi 2 Fix: Bao bọc bằng SingleChildScrollView để chống lỗi tràn màn hình (Overflow)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Lỗi 1 Fix: ListView bên trong Column phải dùng SizedBox có độ cao cố định 
            // hoặc bọc Expanded nếu nằm ngoài ScrollView
            SizedBox(
              height: 200,
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie A')),
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie B')),
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie C')),
                  ListTile(leading: Icon(Icons.movie), title: Text('Movie D')),
                ],
              ),
            ),
            const Divider(),

            // Minh họa Lỗi 3 (State Fix)
            Text('Counter: $_counter', style: const TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                // Phải bọc trong setState() thì UI mới biến đổi khi _counter tăng
                setState(() {
                  _counter++;
                });
              },
              child: const Text('Increment Counter'),
            ),
            const SizedBox(height: 16),

            // Minh họa Lỗi 4 (DatePicker Context Fix)
            Builder(
              builder: (validContext) => ElevatedButton(
                onPressed: () => _selectDate(validContext),
                child: Text(_selectedDate == null 
                  ? 'Pick Date' 
                  : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}