class ProductRequest {
  List<int> categoryId;
  int page;

  ProductRequest({this.categoryId, this.page});

  ProductRequest.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'].cast<int>();
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['page'] = this.page;
    return data;
  }
}
