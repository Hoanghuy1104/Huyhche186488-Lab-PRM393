class User {
  int id;
  String name;
  // TODO 1: Khai báo email có thể bị null dùng dấu '?'
  String? email;

  User({required this.id, required this.name, this.email});

  // TODO 2: Factory Constructor để khởi tạo từ dữ liệu JSON/Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      // Nếu name bị null (hoặc thiếu key 'name'), lấy giá trị mặc định là "Khách"
      name: json['name'] ?? "Khách",
      email: json['email'],
    );
  }

  // TODO 3: Hàm hiển thị thông tin profile
  void showProfile() {
    String displayEmail = email ?? "Chưa cập nhật";
    print("ID: $id | Tên: $name | Email: $displayEmail");
  }
}

void main() {
  Map<String, dynamic> rawData1 = {
    "id": 1,
    "name": "Hoang Cong Huy",
    "email": "huyhche186488@fpt.edu.vn"
  };
  Map<String, dynamic> rawData2 = {
    "id": 2,
    "name": null,
    "email": null
  };

  // TODO 4: Khởi tạo đối tượng từ JSON bằng factory User.fromJson
  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);

  // In kết quả ra màn hình
  user1.showProfile();
  user2.showProfile();
}