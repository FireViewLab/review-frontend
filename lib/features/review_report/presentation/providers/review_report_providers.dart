import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/review_report/presentation/view_models/review_report_state.dart';
import 'package:re_view_front/features/review_report/presentation/view_models/review_report_view_model.dart';

export 'review_report_dep_providers.dart';

final reviewReportViewModelProvider =
    NotifierProvider<ReviewReportViewModel, ReviewReportState>(
  ReviewReportViewModel.new,
);
