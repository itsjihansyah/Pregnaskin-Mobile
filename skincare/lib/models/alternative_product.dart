class AlternativeProduct {
  final String brand;
  final String name;
  final String safe;
  final double confidence;
  final String category;
  final String type;
  final double rating;
  final String country;
  final String feature;
  final String imageUrl;
  final bool isFavorite;
  final String description;
  final String ingredients;
  final double matchPercentage;
  final double matchIngredients;

  const AlternativeProduct ({
    required this.brand,
    required this.name,
    required this.safe,
    required this.confidence,
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
    required this.matchIngredients
  });
}

final List<AlternativeProduct> products = [
  AlternativeProduct(brand: 'Carasun', name: 'Solar Smart UV Light Sunscreen SPF 50+', safe: 'Safe', confidence: 100, category: 'Sunscreen', type: 'Sunscreen', rating: 4.8, country: 'Indonesian', feature: 'Silicon-free', imageUrl: 'https://skinsort.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK3M3RlE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--5b0ee79853ebfe671f08134d1b3f3f5ad891ab2f/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0M2QU5wQXVnRE9ncHpZWFpsY25zR09neHhkV0ZzYVhSNWFVcz0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--de5ec8f4d87208741dc6d32ada91b5aaba79d3a6/77a510b6-99e4-4956-8dab-1f1cab523f37-image-0-1722331791052.png', description: 'A popular vegan and cruelty-free eye moisturizer that contains ceramides, exfoliants, hyaluronic acid, niacinamide, peptides, retinoid and vitamin e.', ingredients: '', matchIngredients: 10.0, matchPercentage: 86.3),
  AlternativeProduct(brand: 'Anua', name: 'Heartleaf Pore Control Cleansing Oil', safe: 'Unsafe', confidence: 100, category: 'Cleansers', type: 'Makeup Remover', rating: 4.5, country: 'Korean', feature: 'Hydrating, Redness reducing, Anti-aging, Scar healing, Brightening', imageUrl: 'https://skinsort.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeENpQnc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--d146575c4b957c7336222b2764594ad286aa7fe2/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0M5QUZwQXZRQk9ncHpZWFpsY25zR09neHhkV0ZzYVhSNWFVcz0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--b72940ad2f828f564888ecdc27fe23650eed6efb/Screen%20Shot%202023-05-14%20at%203.38.30%20AM.jpg', description: 'A popular vegan and cruelty-free eye moisturizer that contains ceramides, exfoliants, hyaluronic acid, niacinamide, peptides, retinoid and vitamin e.', ingredients: 'Ethylhexyl Palmitate, Sorbeth-30 Tetraoleate, Sorbitan Sesquioleate, Caprylic/Capric Triglyceride, Butyl Avocadate, Parfum, Helianthus Annuus Seed Oil, Macadamia Ternifolia Seed Oil, Olea Europaea Fruit Oil, Simmondsia Chinensis Seed Oil, Vitis Vinifera Seed Oil, Caprylyl Glycol, Ethylhexylglycerin, Curcuma Longa Root Extract, Melia Azadirachta Flower Extract, Tocopherol, Melia Azadirachta Leaf Extract, Houttuynia Cordata Extract, Corallina Officinalis Extract, Melia Azadirachta Bark Extract, Moringa Oleifera Seed Oil, Ocimum Sanctum Leaf Extract', matchIngredients: 10.0, matchPercentage: 86.3),
  AlternativeProduct(brand: 'SKIN1004', name: 'Madagascar Centella Ampoule', safe: 'Safe', confidence: 100, category: 'Treatments', type: 'Serum', rating: 4.5, country: 'Korean', feature: 'Silicon-free', imageUrl: 'https://skinsort.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeUpFRmc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--dfcb509ae12a19ccfdbd36eded8b3f75bf4e146d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0M2QU5wQXVnRE9ncHpZWFpsY25zR09neHhkV0ZzYVhSNWFVcz0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--de5ec8f4d87208741dc6d32ada91b5aaba79d3a6/414jDIUrXEL._SL1000_.jpg', description: 'A popular vegan and cruelty-free eye moisturizer that contains ceramides, exfoliants, hyaluronic acid, niacinamide, peptides, retinoid and vitamin e.', ingredients: '', matchIngredients: 10.0, matchPercentage: 86.3),
  AlternativeProduct(brand: 'Kiehls', name: 'Age Defender Power Serum', safe: 'Unsafe', confidence: 100, category: 'Treatments', type: 'Serum', rating: 4.2, country: 'American', feature: 'Silicon-free', imageUrl: 'https://skinsort.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBbTRWIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--166cf9f384376a1ef3d35e07258c113112e62498/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0M2QU5wQXVnRE9ncHpZWFpsY25zR09neHhkV0ZzYVhSNWFVcz0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--de5ec8f4d87208741dc6d32ada91b5aaba79d3a6/AgeDefender_PowerSerum_75ml.jpg', description: 'A popular vegan and cruelty-free eye moisturizer that contains ceramides, exfoliants, hyaluronic acid, niacinamide, peptides, retinoid and vitamin e.', ingredients: '', matchIngredients: 10.0, matchPercentage: 86.3),
  AlternativeProduct(brand: 'Dr. Althea', name: '345 Relief Cream', safe: 'Safe', confidence: 100, category: 'Moisturizer', type: 'General Moisturizer', rating: 4.1, country: 'Korean', feature: 'Silicon-free', imageUrl: 'https://skinsort.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK05jRHc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--4788046ec6246a5729ac776a07e8975d1e34770c/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0M2QU5wQXVnRE9ncHpZWFpsY25zR09neHhkV0ZzYVhSNWFVcz0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--de5ec8f4d87208741dc6d32ada91b5aaba79d3a6/61YYw3WIQPL._SL1080_.jpg', description: 'A popular vegan and cruelty-free eye moisturizer that contains ceramides, exfoliants, hyaluronic acid, niacinamide, peptides, retinoid and vitamin e.', ingredients: '', matchIngredients: 10.0, matchPercentage: 86.3),
  AlternativeProduct(brand: 'Beauty of Joseon', name: 'Revive Eye Serum: Ginseng + Retinal', safe: 'Safe', confidence: 100, category: 'Treatments', type: 'Serum', rating: 4.4, country: 'Korean', feature: 'Silicon-free', imageUrl: 'https://skinsort.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdzJGQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--dff31d0439216c1ce73de3030831f979437ff032/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0M2QU5wQXVnRE9ncHpZWFpsY25zR09neHhkV0ZzYVhSNWFVcz0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--de5ec8f4d87208741dc6d32ada91b5aaba79d3a6/41mZhsjqUlL._SY355_.jpg', description: 'A popular vegan and cruelty-free eye moisturizer that contains ceramides, exfoliants, hyaluronic acid, niacinamide, peptides, retinoid and vitamin e.', ingredients: '', matchIngredients: 10.0, matchPercentage: 86.3)
];
