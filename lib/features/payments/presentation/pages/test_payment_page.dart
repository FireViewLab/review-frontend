import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/payments/presentation/providers/test_payment_providers.dart';
import 'package:re_view_front/features/payments/presentation/widgets/toss_test_payment_widget.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
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
                widget.cart ? '장바구니 토스 TEST 결제' : '토스 TEST 서비스 결제',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                widget.cart
                    ? 'TEST 주문·결제 전용입니다. 실제 상품 배송과 실결제는 진행하지 않습니다. 판매·배송 가능 상품과 최종 금액은 서버 견적으로 확인합니다.'
                    : '테스트 전용입니다. 외부 쇼핑몰 상품 주문·실결제·자동 플랜 변경을 진행하지 않습니다.',
              ),
              if (!loggedIn) ...[
                const Text('주문 조회와 결제는 로그인이 필요합니다. 결제 콜백 주소는 로그인 후 다시 열어 주세요.'),
                TextButton(
                  onPressed: () => context.push(RoutePaths.login),
                  child: const Text('로그인'),
                ),
              ] else if (!configured)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'TEST 결제 키와 서버 주문·승인 계약이 아직 준비되지 않았습니다. 현재 결제를 시작하거나 완료할 수 없습니다.',
                  ),
                )
              else if (!kIsWeb)
                const Text('현재 TEST 결제는 웹 브라우저에서만 지원합니다.')
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
                        child: const Text('TEST 주문'),
                      ),
                    ),
                  TextButton(
                    onPressed: state.isBusy ? null : _load,
                    child: const Text('결제 대상 다시 조회'),
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
                      child: Text(_opening ? 'TEST 결제창 여는 중' : 'TEST 결제창 열기'),
                    ),
                    TextButton(
                      onPressed: _opening
                          ? null
                          : () => setState(() {
                              _request = null;
                              _readyOrder = null;
                              _sdkRevision++;
                            }),
                      child: const Text('결제창 다시 불러오기'),
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
                    child: const Text('서버 승인 상태 다시 조회'),
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
                    child: const Text('TEST 주문 선택으로 돌아가기'),
                  ),
                ],
              ],
              TextButton(
                onPressed: () => context.push(RoutePaths.plan),
                child: const Text('현재 플랜 확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
