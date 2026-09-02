import 'package:flower_app/app/layout/main_shell.dart';
import 'package:flower_app/core/auth/domain/repos/auth_repository.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_cubit.dart';
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
  late AuthCubit authCubit;
  late CartViewModel cartViewModel;
  late GoRouter router;

  setUp(() {
    authCubit = AuthCubit(_FakeAuthRepository());
    cartViewModel = CartViewModel(CartUseCase(_EmptyCartRepo()));
    router = _testRouter();
  });

  tearDown(() async {
    await authCubit.close();
    await cartViewModel.close();
    router.dispose();
  });

  testWidgets('shows bottom bar on Home, Category, Cart, and Profile', (
    tester,
  ) async {
    await _pumpShell(tester, router, authCubit, cartViewModel);

    await _expectBarVisible(tester, router, '/home');
    await _expectBarVisible(tester, router, '/category');
    await _expectBarVisible(tester, router, '/cart');
    await _expectBarVisible(tester, router, '/profile');
  });

  testWidgets('hides bottom bar on product details and other secondary routes', (
    tester,
  ) async {
    await _pumpShell(tester, router, authCubit, cartViewModel);

    await _expectBarHidden(tester, router, '/product-details/abc');
    await _expectBarHidden(tester, router, '/best_seller');
    await _expectBarHidden(tester, router, '/occasion');
  });
}

Future<void> _pumpShell(
  WidgetTester tester,
  GoRouter router,
  AuthCubit authCubit,
  CartViewModel cartViewModel,
) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider.value(value: cartViewModel),
        ],
        child: MaterialApp.router(
          theme: AppTheme(lightThemeColors).themeData,
          routerConfig: router,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
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
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const Text('HOME')),
              GoRoute(
                path: '/best_seller',
                builder: (_, _) => const Text('BEST'),
              ),
              GoRoute(
                path: '/occasion',
                builder: (_, _) => const Text('OCCASION'),
              ),
              GoRoute(
                path: '/product-details/:productId',
                builder: (_, _) => const Text('DETAILS'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/category',
                builder: (_, _) => const Text('CATEGORY'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/cart', builder: (_, _) => const Text('CART')),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, _) => const Text('PROFILE'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<void> logout() async {}
}

class _EmptyCartRepo implements CartRepo {
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
}
