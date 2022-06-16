import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_with_go_router/constants.dart';
import 'package:nav_with_go_router/login_state.dart';
import 'package:nav_with_go_router/ui/create_account.dart';
import 'package:nav_with_go_router/ui/details.dart';
import 'package:nav_with_go_router/ui/error_page.dart';
import 'package:nav_with_go_router/ui/home_screen.dart';
import 'package:nav_with_go_router/ui/login.dart';
import 'package:nav_with_go_router/ui/more_info.dart';
import 'package:nav_with_go_router/ui/payment.dart';
import 'package:nav_with_go_router/ui/personal_info.dart';
import 'package:nav_with_go_router/ui/signin_info.dart';

class MyRouter {
  final LoginState loginState;

  MyRouter(
    this.loginState,
  );

  late final router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    navigatorBuilder: (context, state, child) {
      // deeplink enter here coz extra cannot see here
      print("get by location");
      print(state.location);

      print("get by name");
      print("name : ${state.name}");

      print(state.queryParams);
      print(state.error);
      print("<-------------------------->");
      return child;
    },
    routes: [
      GoRoute(
        name: rootRouteName,
        path: '/',
        redirect: (state) {
          return state.namedLocation(
            homeRouteName,
            params: {
              'tab': 'shop',
            },
          );
        },
      ),
      GoRoute(
        name: loginRouteName,
        path: '/login',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const Login(),
          );
        },
      ),
      GoRoute(
        name: createAccountRouteName,
        path: '/create-account',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const CreateAccount(),
          );
        },
      ),
      GoRoute(
        name: homeRouteName,
        path: '/home/:tab(shop|cart|profile)',
        pageBuilder: (context, state) {
          final tab = state.params['tab']!;
          return MaterialPage<void>(
            key: state.pageKey,
            child: HomeScreen(
              tab: tab,
            ),
            arguments: {
              "tab": tab,
            },
          );
        },
        routes: [
          GoRoute(
            name: subDetailsRouteName,
            path: 'details/:item',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const Details(),
                arguments: {
                  'description': state.params['item']!,
                },
              );
            },
          ),
          GoRoute(
            name: profilePersonalRouteName,
            path: 'personal',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const PersonalInfo(),
              );
            },
          ),
          GoRoute(
            name: profilePaymentRouteName,
            path: 'payment',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const Payment(),
              );
            },
          ),
          GoRoute(
            name: profileSigninInfoRouteName,
            path: 'signin-info',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const SigninInfo(),
              );
            },
          ),
          GoRoute(
            name: profileMoreInfoRouteName,
            path: 'more-info',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const MoreInfo(),
              );
            },
          ),
        ],
      ),
      // forwarding routes to remove the need to put the 'tab' param in the code
      GoRoute(
        path: '/shop',
        redirect: (state) {
          return state.namedLocation(
            homeRouteName,
            params: {
              'tab': 'shop'
            },
          );
        },
      ),
      GoRoute(
        path: '/cart',
        redirect: (state) {
          return state.namedLocation(
            homeRouteName,
            params: {
              'tab': 'cart'
            },
          );
        },
      ),
      GoRoute(
        path: '/profile',
        redirect: (state) {
          return state.namedLocation(
            homeRouteName,
            params: {
              'tab': 'profile'
            },
          );
        },
      ),
      GoRoute(
        name: detailsRouteName,
        path: '/details-redirector/:item',
        redirect: (state) {
          return state.namedLocation(
            subDetailsRouteName,
            params: {
              'tab': 'shop',
              'item': state.params['item']!,
            },
          );
        },
      ),
      GoRoute(
        name: personalRouteName,
        path: '/profile-personal',
        redirect: (state) {
          return state.namedLocation(
            profilePersonalRouteName,
            params: {
              'tab': 'profile'
            },
          );
        },
      ),
      GoRoute(
        name: paymentRouteName,
        path: '/profile-payment',
        redirect: (state) {
          return state.namedLocation(
            profilePaymentRouteName,
            params: {
              'tab': 'profile'
            },
          );
        },
      ),
      GoRoute(
        name: signinInfoRouteName,
        path: '/profile-signin-info',
        redirect: (state) {
          return state.namedLocation(
            profileSigninInfoRouteName,
            params: {
              'tab': 'profile'
            },
          );
        },
      ),
      GoRoute(
        name: moreInfoRouteName,
        path: '/profile-more-info',
        redirect: (state) {
          return state.namedLocation(
            profileMoreInfoRouteName,
            params: {
              'tab': 'profile'
            },
          );
        },
      ),
    ],

    errorPageBuilder: (context, state) {
      print('Error Page with : ${state.error}');
      return MaterialPage<void>(
        key: state.pageKey,
        child: ErrorPage(error: state.error),
      );
    },

    // redirect to the login page if the user is not logged in
    redirect: (state) {
      // Replace here with BloC
      final loginLoc = state.namedLocation(loginRouteName);
      final loggingIn = state.subloc == loginLoc;
      final createAccountLoc = state.namedLocation(createAccountRouteName);
      final creatingAccount = state.subloc == createAccountLoc;
      final loggedIn = loginState.loggedIn;
      final rootLoc = state.namedLocation(rootRouteName);

      if (!loggedIn && !loggingIn && !creatingAccount) return loginLoc;
      if (loggedIn && (loggingIn || creatingAccount)) return rootLoc;
      return null;
    },
  );
}
