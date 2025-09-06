import '../models/alternative_product.dart';

class ProductService {
  final List<AlternativeProduct> products;

  ProductService(this.products);

  List<AlternativeProduct> getAlternativesFor(AlternativeProduct product) {
    return products
        .where((alt) => alt.category == product.category && alt.name != product.name)
        .toList();
  }
}

// Usage Example:
void main() {
  ProductService productService = ProductService(products);

  AlternativeProduct selectedProduct = products.first; // Assume this is the product to compare
  List<AlternativeProduct> alternatives = productService.getAlternativesFor(selectedProduct);

  print("Alternatives for ${selectedProduct.name}:");
  for (var alt in alternatives) {
    print("- ${alt.name}");
  }
}
