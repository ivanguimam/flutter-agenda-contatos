class Contact {
  late int? id = null;
  late String? img = null;
  late String name;
  late String email;
  late String phone;

  Contact({
    required this.name,
    required this.email,
    required this.phone
  });

  Contact.fromMap(Map map) {
    id = map["id"];
    name = map["name"];
    email = map["email"];
    phone = map["phone"];
    img = map["img"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "phone": phone,
    };

    if (img != null) {
      map['img'] = img;
    }

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img?)";
  }
}