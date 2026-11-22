import 'package:re_view_front/l10n/generated/app_localizations.dart';
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
import 'package:re_view_front/features/payments/presentation/view_models/test_payment_view_model.dart';
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
      final repository = _repository ??= CartCheckoutRepositoryImpl(
        ref.watch(apiClientProvider),
        contract,
        null,
        null,
      );
      return ProviderScope(
        key: ValueKey(session.revision),
        overrides: [
          testPaymentContractProvider.overrideWithValue(contract?.payment),
          testPaymentRepositoryProvider.overrideWithValue(repository),
          testPaymentViewModelProvider.overrideWith(TestPaymentViewModel.new),
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
                  AppLocalizations.of(context).paymentCheckoutTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context).paymentCheckoutDescription),
                if (!configured)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      AppLocalizations.of(context).paymentCheckoutNotConfigured,
                    ),
                  ),
                if (!session.isLoggedIn)
                  TextButton(
                    onPressed: () => context.push(RoutePaths.login),
                    child: Text(
                      AppLocalizations.of(context).paymentCheckoutLoginSelect,
                    ),
                  ),
                if (!validSelection)
                  Text(AppLocalizations.of(context).paymentCheckoutNoSelection),
                if (validSelection) ...[
                  for (final item in selection.items)
                    ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        AppLocalizations.of(context).paymentCheckoutQuantity(
                          item.quantity,
                          item.price == null
                              ? AppLocalizations.of(
                                  context,
                                ).homePriceUnavailable
                              : AppLocalizations.of(
                                  context,
                                ).paymentCheckoutUnitPrice(
                                  item.price.toString(),
                                ),
                        ),
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
                            AppLocalizations.of(
                              context,
                            ).paymentCheckoutRecipient,
                            AppLocalizations.of(context).paymentCheckoutPhone,
                            AppLocalizations.of(
                              context,
                            ).paymentCheckoutPostalCode,
                            AppLocalizations.of(context).paymentCheckoutAddress,
                            AppLocalizations.of(
                              context,
                            ).paymentCheckoutAddressDetail,
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
                          if (text.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            ).paymentCheckoutRequired;
                          }
                          if (i == 1 &&
                              (!RegExp(r'^\+?[0-9\- ]+$').hasMatch(text) ||
                                  text.replaceAll(RegExp(r'\D'), '').length <
                                      8 ||
                                  text.replaceAll(RegExp(r'\D'), '').length >
                                      15)) {
                            return AppLocalizations.of(
                              context,
                            ).paymentCheckoutPhoneInvalid;
                          }
                          if (i == 2 && !RegExp(r'^\d{5}$').hasMatch(text)) {
                            return AppLocalizations.of(
                              context,
                            ).paymentCheckoutPostalLength(5);
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
                    child: Text(
                      AppLocalizations.of(context).paymentCheckoutQuote,
                    ),
                  ),
                ],
                TextButton(
                  onPressed: () => context.go(RoutePaths.cart),
                  child: Text(AppLocalizations.of(context).paymentCheckoutBack),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
