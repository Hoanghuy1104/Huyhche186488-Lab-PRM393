import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const JsonCrudScreen(),
    );
  }
}

class JsonCrudScreen extends StatefulWidget {
  const JsonCrudScreen({super.key});

  @override
  State<JsonCrudScreen> createState() => _JsonCrudScreenState();
}

class _JsonCrudScreenState extends State<JsonCrudScreen> {
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // 1. Lấy đường dẫn tệp trong local storage
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/items.json');
  }

  // 2. Tải dữ liệu ban đầu (Tải từ Storage, nếu chưa có thì đọc từ Assets) - Lab 9.1 & 9.2
  Future<void> _initData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          _items = jsonDecode(contents);
          _filteredItems = List.from(_items);
          _isLoading = false;
        });
      } else {
        // Đọc từ Assets nếu chưa có file ở Local Storage (Lab 9.1)
        final String response = await rootBundle.loadString('assets/data/items.json');
        final data = jsonDecode(response);
        setState(() {
          _items = data;
          _filteredItems = List.from(_items);
          _isLoading = false;
        });
        await _saveToStorage(); // Lưu bản đầu tiên xuống Storage
      }
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
      setState(() => _isLoading = false);
    }
  }

  // 3. Tự động lưu dữ liệu vào Local Storage - Lab 9.2
  Future<void> _saveToStorage() async {
    try {
      final file = await _localFile;
      await file.writeAsString(jsonEncode(_items));
    } catch (e) {
      debugPrint("Lỗi lưu file: $e");
    }
  }

  // 4. Tìm kiếm / Lọc dữ liệu - Lab 9.3
  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_items);
      } else {
        _filteredItems = _items.where((item) {
          final title = item['title'].toString().toLowerCase();
          final desc = item['description'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || desc.contains(searchLower);
        }).toList();
      }
    });
  }

  // 5. Thêm/Sửa mục (CRUD - Add & Edit) - Lab 9.3
  void _showFormDialog({Map<String, dynamic>? item, int? index}) {
    final titleController = TextEditingController(text: item != null ? item['title'] : '');
    final descController = TextEditingController(text: item != null ? item['description'] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Thêm công việc mới' : 'Chỉnh sửa công việc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final desc = descController.text.trim();

              if (title.isEmpty) return;

              setState(() {
                if (item == null) {
                  // Thêm mới với ID tự tăng (Bonus)
                  int newId = _items.isEmpty
                      ? 1
                      : (_items.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1);
                  _items.add({'id': newId, 'title': title, 'description': desc});
                } else {
                  // Cập nhật
                  int actualIndex = _items.indexWhere((element) => element['id'] == item['id']);
                  if (actualIndex != -1) {
                    _items[actualIndex] = {'id': item['id'], 'title': title, 'description': desc};
                  }
                }
                _filterItems(_searchController.text);
              });

              await _saveToStorage();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(item == null ? 'Đã thêm mới thành công!' : 'Đã cập nhật!')),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  // 6. Xóa mục với Dialog xác nhận (CRUD - Delete) - Lab 9.3 & Bonus
  void _deleteItem(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa mục này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              setState(() {
                _items.removeWhere((element) => element['id'] == id);
                _filterItems(_searchController.text);
              });

              await _saveToStorage();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa dữ liệu thành công!')),
                );
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9: JSON Storage & CRUD'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Thanh tìm kiếm (Search Bar) - Lab 9.3
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterItems,
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm theo từ khóa...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterItems('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                // Danh sách dữ liệu (ListView)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _initData, // Pull-to-refresh (Bonus)
                    child: _filteredItems.isEmpty
                        ? const Center(child: Text('Không có dữ liệu'))
                        : ListView.builder(
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text('${item['id']}'),
                                  ),
                                  title: Text(
                                    item['title'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(item['description'] ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showFormDialog(item: item, index: index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteItem(item['id']),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}