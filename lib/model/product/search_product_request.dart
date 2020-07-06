class SearchProductRequest {
  String searchTxt;
  int page;

  SearchProductRequest({this.searchTxt, this.page});

  SearchProductRequest.fromJson(Map<String, dynamic> json) {
    searchTxt = json['search'].cast<int>();
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.searchTxt;
    data['page'] = this.page;
    return data;
  }
}