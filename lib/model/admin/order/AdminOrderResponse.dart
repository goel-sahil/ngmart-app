class AdminOrderResponse {
  Data data;

  AdminOrderResponse({this.data});

  AdminOrderResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int currentPage;
  List<DataInner> dataInner;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  Data(
      {this.currentPage,
      this.dataInner,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      dataInner = new List<DataInner>();
      json['data'].forEach((v) {
        dataInner.add(new DataInner.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.dataInner != null) {
      data['data'] = this.dataInner.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class DataInner {
  int id;
  int userId;
  int userAddressId;
  int totalPrice;
  String image;
  int type;
  int status;
  String createdAt;
  String updatedAt;
  String invoice;
  String imageUrl;
  String invoiceUrl;
  UserAddress userAddress;
  List<OrderItems> orderItems;

  DataInner(
      {this.id,
      this.userId,
      this.userAddressId,
      this.totalPrice,
      this.image,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.invoice,
      this.imageUrl,
      this.invoiceUrl,
      this.userAddress,
      this.orderItems});

  DataInner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userAddressId = json['user_address_id'];
    totalPrice = json['total_price'];
    image = json['image'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    invoice = json['invoice'];
    imageUrl = json['image_url'];
    invoiceUrl = json['invoice_url'];
    userAddress = json['user_address'] != null
        ? new UserAddress.fromJson(json['user_address'])
        : null;
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_address_id'] = this.userAddressId;
    data['total_price'] = this.totalPrice;
    data['image'] = this.image;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['invoice'] = this.invoice;
    data['image_url'] = this.imageUrl;
    data['invoice_url'] = this.invoiceUrl;
    if (this.userAddress != null) {
      data['user_address'] = this.userAddress.toJson();
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddress {
  int id;
  String address;
  String city;
  String state;
  String country;
  String pinCode;
  int userId;
  String createdAt;
  String updatedAt;

  UserAddress(
      {this.id,
      this.address,
      this.city,
      this.state,
      this.country,
      this.pinCode,
      this.userId,
      this.createdAt,
      this.updatedAt});

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pinCode = json['pin_code'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pin_code'] = this.pinCode;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrderItems {
  int id;
  int orderId;
  int userId;
  int userAddressId;
  int productId;
  int categoryId;
  int brandId;
  num pricePerUnit;
  num totalPrice;
  int quantity;
  String createdAt;
  String updatedAt;
  Product product;

  OrderItems(
      {this.id,
      this.orderId,
      this.userId,
      this.userAddressId,
      this.productId,
      this.categoryId,
      this.brandId,
      this.pricePerUnit,
      this.totalPrice,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    userAddressId = json['user_address_id'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    brandId = json['brand_id'];
    pricePerUnit = json['price_per_unit'];
    totalPrice = json['total_price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['user_address_id'] = this.userAddressId;
    data['product_id'] = this.productId;
    data['category_id'] = this.categoryId;
    data['brand_id'] = this.brandId;
    data['price_per_unit'] = this.pricePerUnit;
    data['total_price'] = this.totalPrice;
    data['quantity'] = this.quantity;
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
  num price;
  num quantity;
  num quantityIncrement;
  int quantityUnitId;
  num orderedTimes;
  int status;
  String createdAt;
  String updatedAt;
  int isDeleted;
  String imageUrl;
  Category category;
  Brand brand;
  Brand quantityUnit;

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
      this.isDeleted,
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
    isDeleted = json['is_deleted'];
    imageUrl = json['image_url'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    quantityUnit = json['quantity_unit'] != null
        ? new Brand.fromJson(json['quantity_unit'])
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
    data['is_deleted'] = this.isDeleted;
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
  int isDeleted;
  String imageUrl;

  Category(
      {this.id,
      this.title,
      this.image,
      this.categoryId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.isDeleted,
      this.imageUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    categoryId = json['category_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
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
    data['is_deleted'] = this.isDeleted;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Brand {
  int id;
  String title;

  Brand({this.id, this.title});

  Brand.fromJson(Map<String, dynamic> json) {
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
