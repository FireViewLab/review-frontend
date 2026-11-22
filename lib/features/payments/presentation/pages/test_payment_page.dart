import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/payments/presentation/providers/test_payment_providers.dart';
import 'package:re_view_front/features/payments/presentation/widgets/toss_test_payment_widget.dart';
import 'package:re_view_front/shared/presentation/product_formatters.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class TestPaymentPage extends ConsumerStatefulWidget {
  const TestPaymentPage({super.key, this.cart = false});
  final bool cart;
  @override
  ConsumerState<TestPaymentPage> createState() => _TestPaymentPageState();
}

class _TestPaymentPageState extends ConsumerState<TestPaymentPage> {
  Future<void> Function()? _request;
  String? _readyOrder;
  bool _opening = false;
  int _sdkRevision = 0;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) _load();
    });
  }

  void _load() {
    final vm = ref.read(testPaymentViewModelProvider.notifier);
    final uri = GoRouterState.of(context).uri;
    if (uri.queryParameters.containsKey('orderId')) {
      vm.restore(uri);
    } else {
      vm.load();
    }
  }

  String _callback(String result, {String? orderId}) => Uri.base
      .replace(
        path: widget.cart ? RoutePaths.cartCheckout : RoutePaths.testPayment,
        queryParameters: {'result': result, 'orderId': ?orderId},
        fragment: '',
      )
      .toString();
  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(isLoggedInProvider);
    final state = ref.watch(testPaymentViewModelProvider);
    final vm = ref.read(testPaymentViewModelProvider.notifier);
    final key = ref.watch(testPaymentClientKeyProvider);
    final configured =
        key.isNotEmpty && ref.watch(testPaymentContractProvider) != null;
    final callback = GoRouterState.of(context).uri.queryParameters['result'];
    final order = state.order;
    return Scaffold(
      body: SingleChildScrollView(
        child: AppContentView(
          maxWidth: 720,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.cart
                    ? AppLocalizations.of(context).paymentTestCartTitle
                    : AppLocalizations.of(context).paymentTestServiceTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                widget.cart
                    ? AppLocalizations.of(context).paymentTestCartDescription
                    : AppLocalizations.of(
                        context,
                      ).paymentTestServiceDescription,
              ),
              if (!loggedIn) ...[
                Text(AppLocalizations.of(context).paymentTestLoginRequired),
                TextButton(
                  onPressed: () => context.push(RoutePaths.login),
                  child: Text(AppLocalizations.of(context).actionLogin),
                ),
              ] else if (!configured)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    AppLocalizations.of(context).paymentTestNotConfigured,
                  ),
                )
              else if (!kIsWeb)
                Text(AppLocalizations.of(context).paymentTestWebOnly)
              else ...[
                if (state.isBusy) const LinearProgressIndicator(),
                if (state.message != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(state.message!),
                  ),
                if (order == null) ...[
                  for (final offer in state.offers)
                    ListTile(
                      title: Text(offer.name),
                      subtitle: Text(
                        [
                          formatSearchPrice(offer.amount),
                          ...offer.details,
                        ].join('\n'),
                      ),
                      trailing: FilledButton(
                        onPressed: state.isBusy ? null : () => vm.create(offer),
                        child: Text(
                          AppLocalizations.of(context).paymentTestOrder,
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: state.isBusy ? null : _load,
                    child: Text(
                      AppLocalizations.of(context).paymentTestReloadTargets,
                    ),
                  ),
                ] else ...[
                  Text('${order.name} · ${formatSearchPrice(order.amount)}'),
                  if (order.status == 'PENDING' && callback == null) ...[
                    TossTestPaymentWidget(
                      key: ValueKey('${order.id}-$_sdkRevision'),
                      clientKey: key,
                      order: order,
                      successUrl: _callback('success'),
                      failUrl: _callback('fail', orderId: order.id),
                      onReady: (request) {
                        if (mounted) {
                          setState(() {
                            _request = request;
                            _readyOrder = order.id;
                          });
                        }
                      },
                      onError: vm.notice,
                    ),
                    FilledButton(
                      onPressed:
                          _readyOrder == order.id &&
                              _request != null &&
                              !_opening
                          ? () async {
                              setState(() => _opening = true);
                              try {
                                await _request!();
                              } finally {
                                if (mounted) setState(() => _opening = false);
                              }
                            }
                          : null,
                      child: Text(
                        _opening
                            ? AppLocalizations.of(context).paymentTestOpening
                            : AppLocalizations.of(context).paymentTestOpen,
                      ),
                    ),
                    TextButton(
                      onPressed: _opening
                          ? null
                          : () => setState(() {
                              _request = null;
                              _readyOrder = null;
                              _sdkRevision++;
                            }),
                      child: Text(
                        AppLocalizations.of(context).paymentTestReloadWindow,
                      ),
                    ),
                  ],
                  TextButton(
                    onPressed: state.isBusy
                        ? null
                        : () => vm.restore(
                            GoRouterState.of(context).uri.replace(
                              queryParameters: {
                                ...GoRouterState.of(
                                  context,
                                ).uri.queryParameters,
                                'orderId': order.id,
                              },
                            ),
                          ),
                    child: Text(
                      AppLocalizations.of(context).paymentTestReloadApproval,
                    ),
                  ),
                  TextButton(
                    onPressed: state.isBusy || _opening
                        ? null
                        : () {
                            vm.reset();
                            _request = null;
                            _readyOrder = null;
                            context.go(
                              widget.cart
                                  ? RoutePaths.cart
                                  : RoutePaths.testPayment,
                            );
                          },
                    child: Text(
                      AppLocalizations.of(context).paymentTestBackToOrders,
                    ),
                  ),
                ],
              ],
              TextButton(
                onPressed: () => context.push(RoutePaths.plan),
                child: Text(AppLocalizations.of(context).paymentTestCheckPlan),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
