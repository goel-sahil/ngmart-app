class AdminProductRequest {
  List<int> categoryId;
  List<int> brandId;
  String search;

  AdminProductRequest({this.categoryId, this.brandId, this.search});

  AdminProductRequest.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'].cast<int>();
    brandId = json['brand_id'].cast<int>();
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['brand_id'] = this.brandId;
    data['search'] = this.search;
    return data;
  }
}
