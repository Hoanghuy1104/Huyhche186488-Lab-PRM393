import 'dart:async';
import 'dart:convert';

// ==========================================
// EXERCISE 1: Product Model & Repository
// ==========================================

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  final List<Product> _products = [];
  final StreamController<Product> _liveAddedController = StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_products);
  }

  Stream<Product> get liveAdded => _liveAddedController.stream;

  void addProduct(Product product) {
    _products.add(product);
    _liveAddedController.add(product);
  }

  void dispose() {
    _liveAddedController.close();
  }
}

Future<void> runExercise1() async {
  print('--- EXERCISE 1: Product Model & Repository ---');
  final repo = ProductRepository();

  final subscription = repo.liveAdded.listen((product) {
    print('[Stream Live Update] Added: $product');
  });

  repo.addProduct(Product(id: 'p1', name: 'Laptop', price: 1200.0));
  repo.addProduct(Product(id: 'p2', name: 'Smartphone', price: 800.0));

  final allProducts = await repo.getAll();
  print('[Future getAll] Current inventory count: ${allProducts.length}');

  await subscription.cancel();
  repo.dispose();
  print('');
}

// ==========================================
// EXERCISE 2: User Repository with JSON
// ==========================================

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  // Giả lập dữ liệu JSON chứa thông tin cá nhân của bạn
  Future<String> _fetchUserJsonFromApi() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return '''
    [
      {"name": "Hoang Cong Huy", "email": "huyhche186488@fpt.edu.vn"},
      {"name": "Alice Johnson", "email": "alice@example.com"}
    ]
    ''';
  }

  Future<List<User>> getUsers() async {
    final rawJson = await _fetchUserJsonFromApi();
    final List<dynamic> decodedList = jsonDecode(rawJson);
    
    return decodedList.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();
  }
}

Future<void> runExercise2() async {
  print('--- EXERCISE 2: User Repository with JSON ---');
  final userRepo = UserRepository();
  
  print('Fetching users from API...');
  final users = await userRepo.getUsers();
  
  for (var user in users) {
    print('Parsed: $user');
  }
  print('');
}

// ==========================================
// EXERCISE 3: Async + Microtask Debugging
// ==========================================

Future<void> runExercise3() async {
  print('--- EXERCISE 3: Async + Microtask Debugging ---');

  print('1. Synchronous: Start of runExercise3');

  Future(() {
    print('4. Event Queue: Future callback executed');
  });

  scheduleMicrotask(() {
    print('3. Microtask Queue: Microtask callback executed');
  });

  print('2. Synchronous: End of runExercise3');

  /*
   * Explanation:
   * In Dart's Event Loop architecture:
   * 1. Microtask Queue has HIGHER priority than Event Queue.
   * 2. Synchronous code executes immediately to completion.
   * 3. Before taking any event from Event Queue (e.g., Future timers/IO),
   *    Dart completely clears all items in the Microtask Queue.
   * Therefore, scheduleMicrotask() runs BEFORE Future().
   */

  await Future.delayed(const Duration(milliseconds: 100));
  print('');
}

// ==========================================
// EXERCISE 4: Stream Transformation
// ==========================================

Future<void> runExercise4() async {
  print('--- EXERCISE 4: Stream Transformation ---');

  final numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  final transformedStream = numberStream
      .map((number) => number * number)
      .where((square) => square % 2 == 0);

  await for (final value in transformedStream) {
    print('Emitted transformed value: $value');
  }
  print('');
}

// ==========================================
// EXERCISE 5: Factory Constructors & Cache
// ==========================================

class Settings {
  final String appName;
  static Settings? _instance;

  Settings._internal({required this.appName});

  factory Settings({String appName = 'My App'}) {
    _instance ??= Settings._internal(appName: appName);
    return _instance!;
  }
}

void runExercise5() {
  print('--- EXERCISE 5: Factory Constructors & Cache ---');

  final settingsA = Settings(appName: 'Custom App Name');
  final settingsB = Settings(appName: 'Ignored Name');

  print('Settings A appName: ${settingsA.appName}');
  print('Settings B appName: ${settingsB.appName}');

  final bool isIdentical = identical(settingsA, settingsB);
  print('Are both instances identical(a, b)? -> $isIdentical');
  print('');
}

// ==========================================
// MAIN ENTRY POINT
// ==========================================

void main() async {
  await runExercise1();
  await runExercise2();
  await runExercise3();
  await runExercise4();
  runExercise5();
}