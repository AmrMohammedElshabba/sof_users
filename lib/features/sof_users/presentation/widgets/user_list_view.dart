import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sof_users/core/utilities/app_images.dart';
import 'package:sof_users/core/utilities/app_routers.dart';
import 'package:sof_users/core/utilities/styles.dart';
import 'package:sof_users/features/sof_users/domain/models/sof_user.dart';

import '../controller/sof_users_cubit.dart';

class UsersList extends StatelessWidget {
  final List<SOFUser> users;

  const UsersList(this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SofUsersCubit, SofUsersState>(
      buildWhen: (prev, curr) =>
          curr is BookmarkLoaded || curr is ShowBookMarkOnly,
      builder: (context, bookmarkState) {
        final cubit = SofUsersCubit.get(context);

        final bookmarks = cubit.bookmarks;

        final list = cubit.isShowBookmarkedOnly
            ? users.where((u) => bookmarks.contains(u.userId)).toList()
            : users;

        return ListView.separated(
          itemCount:
              list.length +
              (cubit.hasMore && !cubit.isShowBookmarkedOnly ? 1 : 0),
          controller: cubit.scrollController,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            if (index >= list.length && !cubit.isShowBookmarkedOnly) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final user = list[index];
            final isBookmarked = bookmarks.contains(user.userId);

            return ListTile(
              onTap: () {
                context.push(AppRoutes.reputationItemsScreen, extra: user);
              },
              leading: SizedBox(
                width: 44,
                height: 44,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.profileImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        padding: EdgeInsetsGeometry.all(8),
                      ),
                    ),
                    errorWidget: (context, url, error) => SvgPicture.asset(
                      AppImages.avatarPlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              title: Text(
                user.displayName,
                style: AppStyles.kTextStyle18Primary,
              ),
              subtitle: Text(
                "Reputation: ${user.reputation}",
                style: AppStyles.kTextStyle14Black80,
              ),
              trailing: IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () => cubit.toggleBookmarks(user.userId),
              ),
            );
          },
        );
      },
    );
  }
}
