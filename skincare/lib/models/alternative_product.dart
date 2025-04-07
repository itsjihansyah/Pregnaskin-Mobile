class AlternativeProduct {
  final String brand;
  final String name;
  final String safe;
  final String category;
  final String type;
  final double rating;
  final String country;
  final String feature;
  final String imageUrl;
  final bool isFavorite;
  final String description;
  final String ingredients;
  final int matchPercentage;
  final int matchIngredients;

  const AlternativeProduct({
    required this.brand,
    required this.name,
    required this.safe,
    required this.category,
    required this.type,
    required this.rating,
    required this.country,
    required this.feature,
    required this.imageUrl,
    this.isFavorite = false,
    required this.description,
    required this.ingredients,
    required this.matchPercentage,
    required this.matchIngredients,
  });

  factory AlternativeProduct.fromJson(Map<String, dynamic> json) {
    return AlternativeProduct(
      brand: json['brand'] ?? '',
      name: json['name'] ?? '',
      safe: json['safe'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      country: json['country'] ?? '',
      feature: json['included_features'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      description: json['benefits'] ?? '',
      ingredients: json['ingredients'] ?? '',
      matchPercentage: json['similarity_score'] == null
          ? 0.0
          : (json['similarity_score'] is int)
              ? json['similarity_score'].toInt()
              : int.tryParse(json['similarity_score'].toString()) ?? 0.0,
      matchIngredients: json['match_ingredient_count'] == null
          ? 0
          : (json['match_ingredient_count'] is int)
              ? json['match_ingredient_count']
              : int.tryParse(json['match_ingredient_count'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'name': name,
      'safe': safe,
      'category': category,
      'type': type,
      'rating': rating,
      'country': country,
      'included_features': feature,
      'image_url': imageUrl,
      'is_favorite': isFavorite,
      'benefits': description,
      'ingredients': ingredients,
      'similarity_score': matchPercentage,
      'match_ingredient_count': matchIngredients,
    };
  }
}
