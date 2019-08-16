class Category {
  int _categoryId;
  String _categoryName;

  // Getter and Setter functions
  int get categoryId => _categoryId;

  set categoryId(int categoryId) {
    if (!categoryId.isNaN) _categoryId = categoryId;
  }


  String get categoryName => _categoryName;

  set categoryName(String categoryName) {
    if (categoryName.isNotEmpty) _categoryName = categoryName;
  }

  Category(this._categoryName);

  Category.withId(this._categoryId, this._categoryName);

  Map<String, dynamic> toMap() {
    var categoryMap = Map<String, dynamic>();
    categoryMap["categoryId"] = _categoryId;
    categoryMap["categoryName"] = _categoryName;
    return categoryMap;
  }

  Category.fromMap(Map<String, dynamic> categoryMap) {
    this._categoryId = categoryMap["categoryId"];
    this._categoryName = categoryMap["categoryName"];
  }

  @override
  String toString() {
    return "Category { categoryId : $_categoryId, categoryName : $_categoryName}";
  }
}
