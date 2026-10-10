import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/price_watch_repository_impl.dart';
import '../../domain/repositories/price_watch_repository.dart';

final priceWatchRepositoryProvider = Provider<PriceWatchRepository>(
  (ref) => const UnconfiguredPriceWatchRepository(),
);
