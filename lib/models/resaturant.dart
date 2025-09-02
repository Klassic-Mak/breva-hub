class Restaurant {
  final String id;
  final String name;
  final String phoneNumber;
  final String description;
  final String locationUrl;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.description,
    required this.locationUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      locationUrl: json['loactionUrl'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      rating: json['rating'].toDouble(),
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
