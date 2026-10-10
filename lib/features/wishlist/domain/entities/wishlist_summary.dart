class WishlistSummary {
  const WishlistSummary({
    required this.priceDropCount,
    this.hasPriceDropInformation = false,
    required this.newAlertCount,
    required this.totalReviewCount,
  });

  final int priceDropCount;
  final bool hasPriceDropInformation;
  final int newAlertCount;
  final int totalReviewCount;
}
