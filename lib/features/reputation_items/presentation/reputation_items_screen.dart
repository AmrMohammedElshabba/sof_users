import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sof_users/core/utilities/styles.dart';
import 'package:sof_users/features/reputation_items/presentation/controllers/reputation_items_cubit.dart';
import 'package:sof_users/features/reputation_items/presentation/widgets/reputation_items_list.dart';

import '../../../core/injection_container/injection_container.dart';
import '../../../core/shared_widgets/failure_widget.dart';
import '../../sof_users/domain/models/sof_user.dart';

class ReputationItemsScreen extends StatelessWidget {
  const ReputationItemsScreen({super.key, required this.sofUser});

  final SOFUser sofUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReputationItemsCubit(getIt())..initialCubit(user: sofUser),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reputation Items", style: AppStyles.kTextStyle22Primary),
        ),
        body: BlocBuilder<ReputationItemsCubit, ReputationItemsState>(
          buildWhen: (prev, curr) =>
              curr is ReputationItemsLoaded ||
              curr is ReputationItemsLoading ||
              curr is ReputationItemsFailure,
          builder: (context, state) {
            final cubit = ReputationItemsCubit.get(context);
            if (state is ReputationItemsLoading ||
                state is ReputationItemsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReputationItemsFailure) {
              return FailureWidget(
                failureMessage: state.failure.message,
                buttonTap: () {
                  cubit.initialCubit(user: sofUser);
                },
              );
            }

            if (state is ReputationItemsLoaded) {
              return ReputationItemsList(
                items: cubit.reputationItems,
                controller: cubit.scrollController,
                hasMore: cubit.hasMore,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
