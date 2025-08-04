class Category {
  final int id;
  final String nameEn;
  final String nameZh;
  final String nameKh;
  final String iconUrl;

  Category({
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.nameKh,
    required this.iconUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameEn: json['nameEn'],
      nameZh: json['nameZh'],
      nameKh: json['nameKh'],
      iconUrl: json['iconUrl'],
    );
  }

  String getName(String language) {
    switch (language) {
      case 'zh':
        return nameZh;
      case 'kh':
        return nameKh;
      default:
        return nameEn;
    }
  }
}
