const keyId = 'id';
const keyName = 'pizzaName';
const keyDescription = 'description';
const keyPrice = 'price';
const keyImage = 'imageUrl';

class Pizza {
  late final int id;
  late final String pizzaName;
  late final String description;
  late final double price;
  late final String imageUrl;

  Pizza.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json[keyId].toString()) ?? 0;
    pizzaName = json[keyName] != null ? json[keyName].toString() : 'No name';
    description = json[keyDescription] != null
        ? json[keyDescription].toString()
        : '';
    price = double.tryParse(json[keyPrice].toString()) ?? 0;
    imageUrl = json[keyImage] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      keyId: id,
      keyName: pizzaName,
      keyDescription: description,
      keyPrice: price,
      keyImage: imageUrl,
    };
  }
}
