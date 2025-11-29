import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sof_users/core/injection_container/injection_container.dart';
import 'package:sof_users/core/shared_widgets/failure_widget.dart';
import 'package:sof_users/core/utilities/styles.dart';
import 'package:sof_users/features/sof_users/presentation/controller/sof_users_cubit.dart';
import 'package:sof_users/features/sof_users/presentation/widgets/user_list_view.dart';

class SOFUsersListScreen extends StatelessWidget {
  const SOFUsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SofUsersCubit(getIt(), getIt())..initialCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "StackOverflow Users",
            style: AppStyles.kTextStyle22Primary,
          ),
          actions: [
            BlocBuilder<SofUsersCubit, SofUsersState>(
              builder: (context, state) {
                final cubit = SofUsersCubit.get(context);
                return IconButton(
                  icon: Icon(
                    cubit.isShowBookmarkedOnly
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  onPressed: () {
                    cubit.showBookMarkOnly();
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<SofUsersCubit, SofUsersState>(
          buildWhen: (prev, curr) =>
              curr is UsersLoaded ||
              curr is UsersLoading ||
              curr is UsersFailure,
          builder: (context, state) {
            final cubit = SofUsersCubit.get(context);
            if (state is UsersLoading || state is SofUsersInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UsersFailure) {
              return FailureWidget(
                failureMessage: state.failure.message,
                buttonTap: () {
                  cubit.initialCubit();
                },
              );
            }

            if (state is UsersLoaded) {
              return UsersList(cubit.sofUsers);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
