import 'dart:math';

void main() {
  // Create products
  var shirt = ClothingItem("T-Shirt", 19.99, "M", "Cotton");
  var book = BookItem("Dart Programming", 29.99, "123-4567890", 250);
  var laptop = ElectronicsItem("Laptop", 999.99, "XYZ123", 24);

  // Create shopping cart
  var cart = ShoppingCart();

  // Add items to cart
  cart.addItem(shirt, 2);
  cart.addItem(book, 1);
  cart.addItem(laptop, 1);

  // Display cart contents
  cart.displayCart();

  // Calculate and display total
  double total = cart.calculateTotal(taxRate: 0.08);
  print("\nSubtotal with tax (8%): \$${total.toStringAsFixed(2)}");

  // Apply discounts
  double finalTotal = cart.applyFinalDiscounts(total);
  print("Final total after discounts: \$${finalTotal.toStringAsFixed(2)}");
}

// Abstract class representing a generic product
abstract class Product {
  final String _name;
  final double _basePrice;

  Product(this._name, this._basePrice);

  // Getter methods for private variables
  String get name => _name;
  double get basePrice => _basePrice;

  // Abstract method to be implemented by subclasses
  String getProductDetails();

  // Common method that can be overridden
  double calculatePrice([int quantity = 1]) {
    return basePrice * quantity;
  }
}

// Clothing product subclass
class ClothingItem extends Product {
  final String size;
  final String material;

  ClothingItem(String name, double price, this.size, this.material)
      : super(name, price);

  @override
  String getProductDetails() {
    return "$name (Size: $size, Material: $material) - \$$basePrice";
  }

  @override
  double calculatePrice([int quantity = 1]) {
    // Clothing might have special pricing for multiple items
    if (quantity >= 3) {
      return basePrice * quantity * 0.9;
    }
    return super.calculatePrice(quantity);
  }
}

// Book product subclass
class BookItem extends Product {
  final String isbn;
  final int pageCount;

  BookItem(String name, double price, this.isbn, this.pageCount)
      : super(name, price);

  @override
  String getProductDetails() {
    return "$name (ISBN: $isbn, $pageCount pages) - \$$basePrice";
  }

  @override
  double calculatePrice([int quantity = 1]) {
    // Books might have special pricing
    return basePrice * quantity * 0.95;
  }
}

// Electronics product subclass
class ElectronicsItem extends Product {
  final String modelNumber;
  final int warrantyMonths;

  ElectronicsItem(
      String name, double price, this.modelNumber, this.warrantyMonths)
      : super(name, price);

  @override
  String getProductDetails() {
    return "$name (Model: $modelNumber, Warranty: $warrantyMonths months) - \$$basePrice";
  }

  @override
  double calculatePrice([int quantity = 1]) {
    // Electronics might have minimum price rule
    return max(basePrice * quantity, 799.99);
  }
}

// Shopping cart class with encapsulation
class ShoppingCart {
  final List<Map<Product, int>> _items =
      []; // Private list of items with quantities

  // Method to add items to cart
  void addItem(Product product, int quantity) {
    if (quantity <= 0) return;
    _items.add({product: quantity});
  }

  // Method to display cart contents
  void displayCart() {
    print("Shopping Cart Contents:");
    for (var item in _items) {
      item.forEach((product, quantity) {
        print(
            "- ${product.getProductDetails()} x $quantity = \$${product.calculatePrice(quantity).toStringAsFixed(2)}");
      });
    }
  }

  // Calculate total with optional tax
  double calculateTotal({double taxRate = 0.0}) {
    double subtotal = _items.fold(0, (sum, item) {
      return sum + item.keys.first.calculatePrice(item.values.first);
    });
    return subtotal * (1 + taxRate);
  }

  // Apply final discounts
  double applyFinalDiscounts(double total) {
    // Tiered discount based on total amount
    double discount = 0;
    if (total > 1000) {
      discount = 0.15;
    } else if (total > 500) {
      discount = 0.10;
    } else if (total > 100) {
      discount = 0.05;
    }

    // Additional discount based on number of items (using factorial)
    int itemCount = _items.fold(0, (count, item) => count + item.values.first);
    double factorialDiscount = _calculateFactorialDiscount(itemCount) / 100;

    // Apply both discounts
    return total * (1 - discount) * (1 - factorialDiscount);
  }

  // Private recursive method for factorial discount
  double _calculateFactorialDiscount(int n) {
    if (n <= 1) return 1.0;
    return n * _calculateFactorialDiscount(n - 1);
  }
}
