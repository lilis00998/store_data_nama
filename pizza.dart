class Pizza {
  late final int id;
  late final String pizzaName;
  late final String description;
  late final double price;
  late final String imageUrl;

  Pizza.fromJson(Map<String, dynamic> json) {
    // Mengatasi String ke int, jika gagal/null maka diisi 0
    id = int.tryParse(json['id'].toString()) ?? 0;

    // Mengatasi field null atau tipe bukan String
    pizzaName = json['pizzaName'] != null
        ? json['pizzaName'].toString()
        : 'No name';

    description = json['description'] != null
        ? json['description'].toString()
        : '';

    // Mengatasi String ke double, jika gagal/null maka diisi 0
    price = double.tryParse(json['price'].toString()) ?? 0;

    imageUrl = json['imageUrl'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pizzaName': pizzaName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
