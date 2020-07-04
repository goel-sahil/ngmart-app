class SearchProductRequest {
  String searchTxt;

  SearchProductRequest({this.searchTxt});

  SearchProductRequest.fromJson(Map<String, dynamic> json) {
    searchTxt = json['search'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.searchTxt;
    return data;
  }
}