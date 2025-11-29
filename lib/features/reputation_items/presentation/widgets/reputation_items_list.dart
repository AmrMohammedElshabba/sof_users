import 'package:flutter/material.dart';
import 'package:sof_users/core/utilities/styles.dart';
import '../../domain/models/reputation_item.dart';

class ReputationItemsList extends StatelessWidget {
  final List<ReputationItem> items;
  final ScrollController controller;
  final bool hasMore;

  const ReputationItemsList({
    super.key,
    required this.items,
    required this.controller,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemCount: items.length + (hasMore ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        if (index >= items.length) {
          // Pagination Loader
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = items[index];
        return ListTile(
          title: Text(item.type, style: AppStyles.kTextStyle18Primary),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change: ${item.change}',
                style: AppStyles.kTextStyle14Black80,
              ),
              Text(
                'Date: ${item.formattedDate}',
                style: AppStyles.kTextStyle14Black80,
              ),
              if (item.postId != null)
                Text(
                  'Post ID: ${item.postId}',
                  style: AppStyles.kTextStyle14Black80,
                ),
            ],
          ),
        );
      },
    );
  }
}
