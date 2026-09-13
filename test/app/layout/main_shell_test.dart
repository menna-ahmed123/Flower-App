import 'package:flower_app/app/layout/main_shell.dart';
import 'package:flower_app/features/auth/core/domain/repos/auth_repository.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_event.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:flower_app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  _showsBarTest();
  _hidesBarTest();
  _categoryTabTest();
  _cartTabTest();
  _profileTabTest();
  _guestCartTest();
}

class MainShellCase {
  late FakeAuthRepository authRepository;
  late AuthCubit authCubit;
  late CartViewModel cartViewModel;
  late GoRouter router;

  void setUp() {
    authRepository = FakeAuthRepository();
    authCubit = AuthCubit(authRepository);
    cartViewModel = CartViewModel(CartUseCase(EmptyCartRepo()));
    router = _testRouter();
  }

  Future<void> tearDown() async {
    await authCubit.close();
    await cartViewModel.close();
    router.dispose();
  }
}

void _showsBarTest() {
  group('shows bar', () {
    final c = MainShellCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    testWidgets('shows bottom bar on Home, Category, Cart, and Profile', (
      tester,
    ) async {
      await _pumpShell(tester, c);
      await _expectBarVisible(tester, c.router, '/home');
      await _expectBarVisible(tester, c.router, '/category');
      await _expectBarVisible(tester, c.router, '/cart');
      await _expectBarVisible(tester, c.router, '/profile');
    });
  });
}

void _hidesBarTest() {
  group('hides bar', () {
    final c = MainShellCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    testWidgets(
      'hides bottom bar on product details and other secondary routes',
      (tester) async {
        await _pumpShell(tester, c);
        await _expectBarHidden(tester, c.router, '/product-details/abc');
        await _expectBarHidden(tester, c.router, '/best_seller');
        await _expectBarHidden(tester, c.router, '/occasion');
      },
    );
  });
}

void _categoryTabTest() {
  group('category tab', () {
    final c = MainShellCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    testWidgets('opens category when the categories tab is selected', (
      tester,
    ) async {
      await _pumpShell(tester, c);
      await tester.tap(find.text(AppString.categories));
      await tester.pumpAndSettle();
      expect(_path(c.router), '/category');
      expect(_selectedIndex(tester), 1);
    });
  });
}

void _cartTabTest() {
  group('cart tab', () {
    final c = MainShellCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    testWidgets('opens cart when an authenticated user selects the cart tab', (
      tester,
    ) async {
      await _signIn(c.authCubit);
      await _pumpShell(tester, c);
      await tester.tap(find.text(AppString.cart));
      await tester.pumpAndSettle();
      expect(_path(c.router), '/cart');
      expect(_selectedIndex(tester), 2);
    });
  });
}

void _profileTabTest() {
  group('profile tab', () {
    final c = MainShellCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    testWidgets(
      'opens profile when an authenticated user selects the profile tab',
      (tester) async {
        await _signIn(c.authCubit);
        await _pumpShell(tester, c);
        await tester.tap(find.text(AppString.profile));
        await tester.pumpAndSettle();
        expect(_path(c.router), '/profile');
        expect(_selectedIndex(tester), 3);
      },
    );
  });
}

void _guestCartTest() {
  group('guest cart', () {
    final c = MainShellCase();
    setUp(c.setUp);
    tearDown(c.tearDown);
    testWidgets('does not open cart when a guest selects the cart tab', (
      tester,
    ) async {
      await _pumpShell(tester, c);
      await tester.tap(find.text(AppString.cart));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(_path(c.router), '/home');
      expect(_selectedIndex(tester), 0);
      expect(find.text(AppString.loginToContinue), findsOneWidget);
    });
  });
}

Future<void> _signIn(AuthCubit authCubit) {
  return authCubit.doEvent(const AuthEvent.authCheckRequested());
}

String _path(GoRouter router) => router.routeInformationProvider.value.uri.path;

int _selectedIndex(WidgetTester tester) {
  return tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;
}

Future<void> _pumpShell(WidgetTester tester, MainShellCase c) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_shellApp(c));
  await tester.pumpAndSettle();
}

Widget _shellApp(MainShellCase c) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, _) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: c.authCubit),
        BlocProvider.value(value: c.cartViewModel),
      ],
      child: MaterialApp.router(
        theme: AppTheme(lightThemeColors).themeData,
        routerConfig: c.router,
      ),
    ),
  );
}

Future<void> _expectBarVisible(
  WidgetTester tester,
  GoRouter router,
  String location,
) async {
  router.go(location);
  await tester.pumpAndSettle();
  expect(find.byType(NavigationBar), findsOneWidget);
  expect(find.text(AppString.home), findsWidgets);
}

Future<void> _expectBarHidden(
  WidgetTester tester,
  GoRouter router,
  String location,
) async {
  router.go(location);
  await tester.pumpAndSettle();
  expect(find.byType(NavigationBar), findsNothing);
}

GoRouter _testRouter() {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(
            navigationShell: navigationShell,
            location: state.uri.path,
          );
        },
        branches: _shellBranches(),
      ),
    ],
  );
}

List<StatefulShellBranch> _shellBranches() {
  return [
    StatefulShellBranch(routes: _homeRoutes()),
    StatefulShellBranch(
      routes: [
        GoRoute(path: '/category', builder: (_, _) => const Text('CATEGORY')),
      ],
    ),
    StatefulShellBranch(
      routes: [GoRoute(path: '/cart', builder: (_, _) => const Text('CART'))],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(path: '/profile', builder: (_, _) => const Text('PROFILE')),
      ],
    ),
  ];
}

List<RouteBase> _homeRoutes() {
  return [
    GoRoute(path: '/home', builder: (_, _) => const Text('HOME')),
    GoRoute(path: '/best_seller', builder: (_, _) => const Text('BEST')),
    GoRoute(path: '/occasion', builder: (_, _) => const Text('OCCASION')),
    GoRoute(
      path: '/product-details/:productId',
      builder: (_, _) => const Text('DETAILS'),
    ),
  ];
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.authenticated = true});

  bool authenticated;

  @override
  Future<bool> isAuthenticated() async => authenticated;

  @override
  Future<void> logout() async {}
}

class EmptyCartRepo implements CartRepo {
  @override
  Future<BaseResponse<CartEntity>> getCart() async {
    return const SuccessResponse(CartEntity.empty());
  }

  @override
  Future<BaseResponse<CartEntity>> addItem({
    required String productId,
    int quantity = 1,
  }) async {
    return const SuccessResponse(CartEntity.empty());
  }

  @override
  Future<BaseResponse<CartEntity>> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    return const SuccessResponse(CartEntity.empty());
  }

  @override
  Future<BaseResponse<bool>> removeItem({required String itemId}) async {
    return const SuccessResponse(true);
  }

  @override
  Future<BaseResponse<bool>> placeOrder() async {
    return const SuccessResponse(true);
  }

  @override
  Future<BaseResponse<bool>> processPayment() async {
    return const SuccessResponse(true);
  }
}
