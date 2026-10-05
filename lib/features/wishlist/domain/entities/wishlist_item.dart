class WishlistItem {
  const WishlistItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.categoryDisplayName,
    required this.avgRti,
    required this.rtiGrade,
    required this.rtiColor,
    required this.reviewCount,
    required this.avgRating,
    required this.isPriceDrop,
    required this.isNewAlert,
    this.platform,
    this.savedAt,
  });

  final int productId;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  final String? categoryDisplayName;
  final double? avgRti;
  final String? rtiGrade;
  final String? rtiColor;
  final int reviewCount;
  final double avgRating;
  final bool isPriceDrop;
  final bool isNewAlert;
  final String? platform;
  final DateTime? savedAt;
}
