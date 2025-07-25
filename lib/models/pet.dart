class Pet {
  final String id;
  final String name;
  final int age;
  final double price;
  final String imageUrl;
  bool isAdopted;
  bool isFavorite;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.imageUrl,
    this.isAdopted = false,
    this.isFavorite = false,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: (json['age'] ?? 0).toInt(),
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      isAdopted: json['isAdopted'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'price': price,
    'imageUrl': imageUrl,
    'isAdopted': isAdopted,
    'isFavorite': isFavorite,
  };
}
