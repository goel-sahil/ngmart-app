class BannerResponse {
  Data data;

  BannerResponse({this.data});

  BannerResponse.fromJson(Map<String, dynamic> json) {
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
  Null nextPageUrl;
  String path;
  int perPage;
  Null prevPageUrl;
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
  String title;
  String description;
  String image;
  int status;
  String createdAt;
  String updatedAt;
  String imageUrl;
  List<Products> products;

  DataInner(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.products});

  DataInner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
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
  int isDeleted;
  String imageUrl;
  Pivot pivot;
  Category category;
  Brand brand;
  Brand quantityUnit;

  Products(
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
      this.pivot,
      this.category,
      this.brand,
      this.quantityUnit});

  Products.fromJson(Map<String, dynamic> json) {
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
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
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

class Pivot {
  int bannerId;
  int productId;

  Pivot({this.bannerId, this.productId});

  Pivot.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_id'] = this.bannerId;
    data['product_id'] = this.productId;
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
