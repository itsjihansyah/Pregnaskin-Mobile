import 'package:skincare/models/product.dart';

class AlternativeProduct extends Product {
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
  final String? pregnancy_condition;
  final bool? hyperpigmentation;
  final bool? pih;
  final bool? acne;
  final bool? stretch_marks;
  final bool? melasma;
  final bool? dry_skin;
  final bool? oily_skin;
  final bool? sensitive_skin;
  final String? image_url;
  final String? good_for;
  final String? benefits;
  final String? concern;
  final String? included_features;
  final String? excluded_features;
  final String? unsafe_reason;

  AlternativeProduct({
    required int id,
    required String brand,
    required String name,
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
    this.pregnancy_condition,
    this.hyperpigmentation,
    this.pih,
    this.acne,
    this.stretch_marks,
    this.melasma,
    this.dry_skin,
    this.oily_skin,
    this.sensitive_skin,
    this.image_url,
    this.good_for,
    this.benefits,
    this.concern,
    this.included_features,
    this.excluded_features,
    this.unsafe_reason,
  }) : super(id: id, brand: brand, name: name, category: category);

  factory AlternativeProduct.fromJson(Map<String, dynamic> json) {
    return AlternativeProduct(
      id: json['id'] ?? 0,
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
          ? 0
          : (json['similarity_score'] is double)
              ? json['similarity_score'].round()
              : (json['similarity_score'] is int)
                  ? json['similarity_score']
                  : double.tryParse(json['similarity_score'].toString())
                          ?.round() ??
                      0,
      matchIngredients: json['match_ingredient_count'] == null
          ? 0
          : (json['match_ingredient_count'] is int)
              ? json['match_ingredient_count']
              : (json['match_ingredient_count'] is double)
                  ? json['match_ingredient_count'].round()
                  : int.tryParse(json['match_ingredient_count'].toString()) ??
                      0,
      pregnancy_condition: json['pregnancy_condition'],
      hyperpigmentation: json['hyperpigmentation'],
      pih: json['pih'],
      acne: json['acne'],
      stretch_marks: json['stretch_marks'],
      melasma: json['melasma'],
      dry_skin: json['dry_skin'],
      oily_skin: json['oily_skin'],
      sensitive_skin: json['sensitive_skin'],
      image_url: json['image_url'],
      good_for: json['good_for'],
      benefits: json['benefits'],
      concern: json['concern'],
      included_features: json['included_features'],
      excluded_features: json['excluded_features'],
      unsafe_reason: json['unsafe_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'pregnancy_condition': pregnancy_condition,
      'hyperpigmentation': hyperpigmentation,
      'pih': pih,
      'acne': acne,
      'stretch_marks': stretch_marks,
      'melasma': melasma,
      'dry_skin': dry_skin,
      'oily_skin': oily_skin,
      'sensitive_skin': sensitive_skin,
      'good_for': good_for,
      'concern': concern,
      'excluded_features': excluded_features,
      'unsafe_reason': unsafe_reason,
    };
  }
}
