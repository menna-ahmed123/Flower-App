import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view/screen/cart_screen.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/cart_footer.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/cart_line.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../cart_test_support.dart';

void main() {
  late FakeCartRepo repo;
  late TestCartViewModel viewModel;

  setUp(() {
    repo = FakeCartRepo();
    viewModel = testCartViewModel(repo);
  });

  tearDown(() async {
    await viewModel.close();
  });

  testWidgets('shows the cart title', (tester) async {
    await pumpCartScreen(tester, viewModel);

    expect(find.text(AppString.myCart), findsOneWidget);
  });

  testWidgets('loads backend cart items when opened with no local cart', (
    tester,
  ) async {
    repo.getCartResponse = SuccessResponse(cartWithItems([cartRose]));
    await pumpCartScreen(tester, viewModel);
    await tester.pumpAndSettle();

    expect(repo.getCartCalls, 1);
    expect(find.byType(CartLine), findsOneWidget);
    expect(find.text('Red Rose'), findsOneWidget);
  });

  testWidgets('does not reload when cart items are already on screen', (
    tester,
  ) async {
    viewModel.emitState(
      CartState(cartState: BaseState(data: cartWithItems([cartRose]))),
    );
    await pumpCartScreen(tester, viewModel);

    expect(repo.getCartCalls, 0);
    expect(find.byType(CartLine), findsOneWidget);
  });

  testWidgets('shows a loading indicator while the first load is in progress', (
    tester,
  ) async {
    viewModel.emitState(const CartState(cartState: BaseState(isLoading: true)));
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(CartEmptyState), findsNothing);
    expect(find.byType(CartErrorState), findsNothing);
  });

  testWidgets('shows a loading indicator while line items are still missing', (
    tester,
  ) async {
    repo.getCartDelay = const Duration(days: 1);
    viewModel.emitState(
      const CartState(
        cartState: BaseState(
          data: CartEntity(
            id: '',
            items: [],
            subtotal: 0,
            deliveryFee: 0,
            total: 0,
            itemCount: 1,
          ),
        ),
      ),
    );
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(CartEmptyState), findsNothing);
    expect(repo.getCartCalls, 1);
    await tester.pump(const Duration(days: 1));
  });

  testWidgets('reloads the cart after local cart state is cleared', (
    tester,
  ) async {
    repo.getCartResponse = SuccessResponse(cartWithItems([cartRose]));
    viewModel.emitState(
      CartState(cartState: BaseState(data: cartWithItems([cartRose]))),
    );
    await pumpCartScreen(tester, viewModel);
    expect(repo.getCartCalls, 0);

    viewModel.emitState(const CartState());
    await tester.pump();

    expect(repo.getCartCalls, 1);
  });

  testWidgets('shows an error state when loading fails with no cart data', (
    tester,
  ) async {
    viewModel.emitState(
      const CartState(cartState: BaseState(errorMessage: 'offline')),
    );
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CartErrorState), findsOneWidget);
    expect(find.text('offline'), findsOneWidget);
    expect(find.text(AppString.retry), findsOneWidget);
    expect(find.byType(CartEmptyState), findsNothing);
  });

  testWidgets('retry on the error state reloads the cart', (tester) async {
    repo.getCartResponse = const SuccessResponse(CartEntity.empty());
    viewModel.emitState(
      const CartState(cartState: BaseState(errorMessage: 'offline')),
    );
    await pumpCartScreen(tester, viewModel);

    await tester.tap(find.text(AppString.retry));
    await tester.pump();

    expect(repo.getCartCalls, 1);
  });

  testWidgets('shows empty state after a purchased cart is cleared', (
    tester,
  ) async {
    repo.getCartResponse = SuccessResponse(cartWithItems([cartRose]));
    viewModel.emitState(
      CartState(cartState: BaseState(data: cartWithItems([cartRose]))),
    );
    await pumpCartScreen(tester, viewModel);
    expect(find.byType(CartLine), findsOneWidget);

    await viewModel.doEvent(const ClearCart());
    await tester.pump();

    expect(repo.removedItemIds, ['item-1']);
    expect(repo.getCartCalls, 0);
    expect(viewModel.state.itemCount, 0);
    expect(find.byType(CartEmptyState), findsOneWidget);
    expect(find.text(AppString.cartIsEmpty), findsOneWidget);
    expect(find.byType(CartLine), findsNothing);
  });

  testWidgets('shows the empty state when the cart has no items', (
    tester,
  ) async {
    viewModel.emitState(
      const CartState(cartState: BaseState(data: CartEntity.empty())),
    );
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CartEmptyState), findsOneWidget);
    expect(find.text(AppString.cartIsEmpty), findsOneWidget);
    expect(find.byType(CartLine), findsNothing);
    expect(find.byType(CartFooter), findsNothing);
  });

  testWidgets('shows cart lines and footer when the cart has items', (
    tester,
  ) async {
    final cart = cartWithItems([cartRose]);
    viewModel.emitState(CartState(cartState: BaseState(data: cart)));
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CartItemsList), findsOneWidget);
    expect(find.byType(CartLine), findsOneWidget);
    expect(find.text('Red Rose'), findsOneWidget);
    expect(find.byType(CartFooter), findsOneWidget);
    expect(find.text(AppString.subtotal), findsOneWidget);
    expect(find.text(AppString.deliveryFee), findsNothing);
    expect(find.text(AppString.total), findsOneWidget);
    expect(find.text(AppString.checkout), findsOneWidget);
  });

  testWidgets('shows a banner when cart prices or stock changed', (
    tester,
  ) async {
    final cart = cartWithItems([cartRose]).copyWith(hasChanges: true);
    viewModel.emitState(CartState(cartState: BaseState(data: cart)));
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CartStatusBanner), findsOneWidget);
    expect(find.text(AppString.cartPricesUpdated), findsOneWidget);
  });

  testWidgets('shows a banner when live pricing is unavailable', (
    tester,
  ) async {
    final cart = cartWithItems([cartRose]).copyWith(pricingUnavailable: true);
    viewModel.emitState(CartState(cartState: BaseState(data: cart)));
    await pumpCartScreen(tester, viewModel);

    expect(find.text(AppString.cartPricingUnavailable), findsOneWidget);
  });

  testWidgets('does not show loading over an already loaded cart', (
    tester,
  ) async {
    viewModel.emitState(
      CartState(
        cartState: BaseState(isLoading: true, data: cartWithItems([cartRose])),
      ),
    );
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(CartLine), findsOneWidget);
  });

  testWidgets('prefers cart items over an error message when data exists', (
    tester,
  ) async {
    viewModel.emitState(
      CartState(
        cartState: BaseState(
          errorMessage: 'offline',
          data: cartWithItems([cartRose]),
        ),
      ),
    );
    await pumpCartScreen(tester, viewModel);

    expect(find.byType(CartErrorState), findsNothing);
    expect(find.byType(CartLine), findsOneWidget);
  });

  testWidgets('empty state pull-to-refresh reloads the cart', (tester) async {
    repo.getCartResponse = ErrorResponse(appError: BadResponseError('offline'));
    viewModel.emitState(
      const CartState(cartState: BaseState(data: CartEntity.empty())),
    );
    await pumpCartScreen(tester, viewModel);

    await tester.fling(
      find.text(AppString.cartIsEmpty),
      const Offset(0, 300),
      1000,
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repo.getCartCalls, 1);
  });
}
