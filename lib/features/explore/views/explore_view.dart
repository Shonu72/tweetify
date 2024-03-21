import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/features/explore/controller/explore_controller.dart';
import 'package:tweetify/features/explore/widgets/search_tile.dart';
import 'package:tweetify/theme/pallete.dart';

class ExploreViews extends ConsumerStatefulWidget {
  const ExploreViews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewsState();
}

class _ExploreViewsState extends ConsumerState<ExploreViews> {
  final searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: "Search Twitter",
              contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
              data: (users) {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return SearchTile(userModel: user);
                  },
                );
              },
              error: (error, st) => ErrorPage(errorText: error.toString()),
              loading: () => const Loader())
          : const SizedBox(),
    );
  }
}
