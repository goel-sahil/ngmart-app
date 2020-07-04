class CartResponse {
  List<CartData> data;

  CartResponse({this.data});

  CartResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CartData>();
      json['data'].forEach((v) {
        data.add(new CartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartData {
  int id;
  int userId;
  int productId;
  num quantity;
  num pricePerUnit;
  String createdAt;
  String updatedAt;
  Product product;

  CartData(
      {this.id,
        this.userId,
        this.productId,
        this.quantity,
        this.pricePerUnit,
        this.createdAt,
        this.updatedAt,
        this.product});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    pricePerUnit = json['price_per_unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price_per_unit'] = this.pricePerUnit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  int id;
  String title;
  String description;
  String image;
  int categoryId;
  int brandId;
  int price;
  int quantity;
  int quantityIncrement;
  int quantityUnitId;
  int orderedTimes;
  int status;
  String createdAt;
  String updatedAt;
  String imageUrl;
  Category category;
  CartBrand brand;
  CartBrand quantityUnit;

  Product(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.categoryId,
        this.brandId,
        this.price,
        this.quantity,
        this.quantityIncrement,
        this.quantityUnitId,
        this.orderedTimes,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.imageUrl,
        this.category,
        this.brand,
        this.quantityUnit});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    brandId = json['brand_id'];
    price = json['price'];
    quantity = json['quantity'];
    quantityIncrement = json['quantity_increment'];
    quantityUnitId = json['quantity_unit_id'];
    orderedTimes = json['ordered_times'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    brand = json['brand'] != null ? new CartBrand.fromJson(json['brand']) : null;
    quantityUnit = json['quantity_unit'] != null
        ? new CartBrand.fromJson(json['quantity_unit'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['brand_id'] = this.brandId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['quantity_increment'] = this.quantityIncrement;
    data['quantity_unit_id'] = this.quantityUnitId;
    data['ordered_times'] = this.orderedTimes;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand.toJson();
    }
    if (this.quantityUnit != null) {
      data['quantity_unit'] = this.quantityUnit.toJson();
    }
    return data;
  }
}

class Category {
  int id;
  String title;
  String image;
  int categoryId;
  int status;
  String createdAt;
  String updatedAt;
  String imageUrl;

  Category(
      {this.id,
        this.title,
        this.image,
        this.categoryId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    categoryId = json['category_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class CartBrand {
  int id;
  String title;

  CartBrand({this.id, this.title});

  CartBrand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
