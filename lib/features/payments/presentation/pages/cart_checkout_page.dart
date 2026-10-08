import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/cart/presentation/providers/cart_providers.dart';
import 'package:re_view_front/features/payments/data/cart_checkout_contract.dart';
import 'package:re_view_front/features/payments/data/cart_checkout_repository_impl.dart';
import 'package:re_view_front/features/payments/domain/entities/cart_checkout.dart';
import 'package:re_view_front/features/payments/presentation/pages/test_payment_page.dart';
import 'package:re_view_front/features/payments/presentation/providers/test_payment_providers.dart';
import 'package:re_view_front/features/payments/presentation/view_models/test_payment_state.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

class CartCheckoutPage extends ConsumerStatefulWidget {
  const CartCheckoutPage({super.key, this.selection});
  final CartCheckoutSelection? selection;
  @override
  ConsumerState<CartCheckoutPage> createState() => _CartCheckoutPageState();
}

class _CartCheckoutPageState extends ConsumerState<CartCheckoutPage> {
  final _form = GlobalKey<FormState>();
  final _inputs = List.generate(5, (_) => TextEditingController());
  CartCheckoutRepositoryImpl? _repository;
  bool _reconciled = false;
  @override
  void dispose() {
    for (final input in _inputs) {
      input.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    final contract = CartCheckoutContract.fromEnvironment();
    final selection = widget.selection;
    final restoring = GoRouterState.of(
      context,
    ).uri.queryParameters.containsKey('orderId');
    ref.listen(authSessionProvider, (previous, next) {
      if (previous != next) {
        for (final input in _inputs) {
          input.clear();
        }
        setState(() {
          _repository = null;
          _reconciled = false;
        });
      }
    });
    if (restoring || _repository != null) {
      final repository =
          _repository ??
          CartCheckoutRepositoryImpl(
            ref.watch(apiClientProvider),
            contract,
            null,
            null,
          );
      return ProviderScope(
        overrides: [
          testPaymentContractProvider.overrideWithValue(contract?.payment),
          testPaymentRepositoryProvider.overrideWithValue(repository),
        ],
        child: Consumer(
          builder: (context, childRef, _) {
            childRef.listen<TestPaymentState>(testPaymentViewModelProvider, (
              previous,
              next,
            ) {
              if (next.order?.isPaid == true && !_reconciled) {
                _reconciled = true;
                ref.read(cartViewModelProvider.notifier).load();
                ref.invalidate(cartItemCountProvider);
                ref.invalidate(cartProductIdsProvider);
              }
            });
            return const TestPaymentPage(cart: true);
          },
        ),
      );
    }
    final validSelection =
        selection != null &&
        selection.items.isNotEmpty &&
        selection.sessionRevision == session.revision;
    final configured =
        contract != null && ref.watch(testPaymentClientKeyProvider).isNotEmpty;
    return Scaffold(
      body: SingleChildScrollView(
        child: AppContentView(
          maxWidth: 720,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '장바구니 TEST 주문',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                const Text(
                  '실결제·실제 배송은 진행하지 않습니다. 쇼핑몰 상품을 이 서비스가 판매·배송할 수 있는지 서버 확인이 필요합니다. 표시 가격은 참고용이며 배송비·최종 금액은 서버 견적으로 확인합니다.',
                ),
                if (!configured)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'TEST 공개 키와 장바구니 견적·주문·승인 API가 아직 없습니다. 주문 저장과 결제는 사용할 수 없습니다. 주소는 서버에 보내거나 저장하지 않습니다.',
                    ),
                  ),
                if (!session.isLoggedIn)
                  TextButton(
                    onPressed: () => context.push(RoutePaths.login),
                    child: const Text('로그인 후 주문 선택'),
                  ),
                if (!validSelection)
                  const Text('현재 계정의 선택 상품이 없습니다. 장바구니에서 상품을 선택해 주세요.'),
                if (validSelection) ...[
                  for (final item in selection.items)
                    ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        '${item.quantity}개 · ${item.price == null ? '가격 정보 없음' : '참고 개당 ${item.price}원'}',
                      ),
                      onTap: () => context.push(
                        item.detailPath,
                        extra: item.routeContext,
                      ),
                    ),
                  for (var i = 0; i < _inputs.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextFormField(
                        controller: _inputs[i],
                        enabled: configured && session.isLoggedIn,
                        decoration: InputDecoration(
                          labelText: [
                            '수령인',
                            '연락처',
                            '우편번호',
                            '주소',
                            '상세 주소 (선택)',
                          ][i],
                        ),
                        keyboardType: i == 1
                            ? TextInputType.phone
                            : i == 2
                            ? TextInputType.number
                            : TextInputType.text,
                        maxLength: i == 3 || i == 4 ? 200 : 40,
                        validator: (value) {
                          if (i == 4) return null;
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) return '입력해 주세요.';
                          if (i == 1 &&
                              !RegExp(r'^[0-9+\- ]{8,20}$').hasMatch(text)) {
                            return '연락처 형식을 확인해 주세요.';
                          }
                          if (i == 2 && !RegExp(r'^\d{5}$').hasMatch(text)) {
                            return '우편번호 5자리를 입력해 주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                  FilledButton(
                    onPressed: configured && session.isLoggedIn
                        ? () {
                            if (!_form.currentState!.validate()) return;
                            setState(
                              () => _repository = CartCheckoutRepositoryImpl(
                                ref.read(apiClientProvider),
                                contract,
                                selection,
                                CheckoutAddress(
                                  recipient: _inputs[0].text.trim(),
                                  phone: _inputs[1].text.trim(),
                                  postalCode: _inputs[2].text.trim(),
                                  address: _inputs[3].text.trim(),
                                  detail: _inputs[4].text.trim(),
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text('서버 TEST 견적 확인'),
                  ),
                ],
                TextButton(
                  onPressed: () => context.go(RoutePaths.cart),
                  child: const Text('장바구니로 돌아가기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
