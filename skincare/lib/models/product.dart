class Product {
  final int id;
  final String brand;
  final String name;
  final String? safe;
  final String category;
  final String? type;
  final double? rating;
  final String? good_for;
  final String? benefits;
  final String? concern;
  final String? included_features;
  final String? excluded_features;
  final String? unsafe_reason;
  final String? country;
  final String? ingredients;
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
  final bool is_favorite;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    this.safe,
    required this.category,
    this.type,
    this.rating,
    this.good_for,
    this.benefits,
    this.concern,
    this.included_features,
    this.excluded_features,
    this.unsafe_reason,
    this.country,
    this.ingredients,
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
    this.is_favorite = false,
  });

  // Convert JSON to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      name: json['name'],
      safe: json['safe'],
      category: json['category'],
      type: json['type'],
      rating: json['rating']?.toDouble(),
      good_for: json['good_for'],
      benefits: json['benefits'],
      concern: json['concern'],
      included_features: json['included_features'],
      excluded_features: json['excluded_features'],
      unsafe_reason: json['unsafe_reason'],
      country: json['country'],
      ingredients: json['ingredients'],
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
      is_favorite: json['is_favorite'] ?? false,
    );
  }

  // Convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'name': name,
      'safe': safe,
      'category': category,
      'type': type,
      'rating': rating,
      'good_for': good_for,
      'benefits': benefits,
      'concern': concern,
      'included_features': included_features,
      'excluded_features': excluded_features,
      'unsafe_reason': unsafe_reason,
      'country': country,
      'ingredients': ingredients,
      'pregnancy_condition': pregnancy_condition,
      'hyperpigmentation': hyperpigmentation,
      'pih': pih,
      'acne': acne,
      'stretch_marks': stretch_marks,
      'melasma': melasma,
      'dry_skin': dry_skin,
      'oily_skin': oily_skin,
      'sensitive_skin': sensitive_skin,
      'image_url': image_url,
      'is_favorite': is_favorite,
    };
  }
}
