import 'package:go_router/go_router.dart';
import 'package:sof_users/features/reputation_items/presentation/reputation_items_screen.dart';
import 'package:sof_users/features/sof_users/presentation/sof_users_screen.dart';

import '../../features/sof_users/domain/models/sof_user.dart';

class AppRoutes {
  // All app routes
  static const String sofUsersScreen = "/";
  static const String reputationItemsScreen = "/reputationItemsScreen";

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: sofUsersScreen,
        builder: (context, state) => const SOFUsersListScreen(),
      ),

      GoRoute(
        path: reputationItemsScreen,

        builder: (context, state) {
          final SOFUser user = state.extra as SOFUser;
          return ReputationItemsScreen(sofUser: user);
        },
      ),
    ],
  );
}
