class Crypto {
  String id;
  String image;
  String name;
  double unitPrice ; 
  String code ; 
  String description;

  Crypto({
    required this.id,
    required this.image,
    required this.name,
    required this.unitPrice,
    required this.code,
    required this.description
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['_id'],
      image: json['image'],
      name: json['name'],
      unitPrice: json['unitPrice'].toDouble(),
      code: json['code'],
      description: json['description'],
    );
  }
}
