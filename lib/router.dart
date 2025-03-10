import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fintech_app/wallet/wallet.dart';
import 'package:fintech_app/dashboard/scan.dart';
import 'package:fintech_app/profile/profile.dart';
import 'package:fintech_app/dashboard/request.dart';
import 'package:fintech_app/dashboard/mandates.dart';
import 'package:fintech_app/dashboard/paymoney.dart';
import 'package:fintech_app/dashboard/generate.dart';
import 'package:fintech_app/dashboard/dashboard.dart';
import 'package:fintech_app/dashboard/approvals.dart';
import 'package:fintech_app/transactions/transactions.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const DashBoard(),
      routes: [
        GoRoute(
          path: '/wallet',
          name: 'wallet',
          builder: (context, state) => Wallet(),
        ),
        GoRoute(
          path: '/transactions',
          name: 'transactions',
          builder: (context, state) => Transactions(),
        ),
        GoRoute(
          path: '/request',
          name: 'request',
          builder: (context, state) => Requests(),
        ),
        GoRoute(
          path: '/approvals',
          name: 'approvals',
          builder: (context, state) => Approvals(),
        ),
        GoRoute(
          path: '/scan',
          name: 'scan',
          builder: (context, state) => ScanQR(),
        ),
        GoRoute(
          path: '/generate',
          name: 'generate',
          builder: (context, state) => GenerateQR(),
        ),
        GoRoute(
          path: '/mandates',
          name: 'mandates',
          builder: (context, state) => Mandates(),
        ),
        GoRoute(
          path: '/pay',
          name: 'pay',
          builder: (context, state) => PayMoney(),
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => ProfilePage(),
    ),
  ],
  restorationScopeId: 'app',
  errorBuilder: (context, state) => Container(),
);
