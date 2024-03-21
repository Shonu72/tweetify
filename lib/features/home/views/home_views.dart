import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tweetify/constants/constants.dart';
import 'package:tweetify/features/explore/views/explore_view.dart';
import 'package:tweetify/features/tweet/views/create_tweet_view.dart';
import 'package:tweetify/features/tweet/widgets/tweet_list.dart';
import 'package:tweetify/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appbar = UIConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.pushNamed(context, CreateTweetScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appbar : null,
      body: IndexedStack(
        index: _page,
        children: const [
          // FeedScreen(),
          // SearchScreen(),
          // NotificationScreen(),
          // MessagesScreen(),

          // Text("Feed Screen"),
          TweetList(),
          ExploreViews(),
          Text("notification Screen"),
          Text("Messages Screen"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            CreateTweetScreen.route(),
          );
        },
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        selectedItemColor: Pallete.whiteColor,
        unselectedItemColor: Pallete.greyColor,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              color: _page == 0 ? Pallete.whiteColor : Pallete.greyColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              color: _page == 1 ? Pallete.whiteColor : Pallete.greyColor,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              color: _page == 2 ? Pallete.whiteColor : Pallete.greyColor,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 3
                  ? AssetsConstants.messages
                  : AssetsConstants.messagesFilled,
              color: _page == 3 ? Pallete.whiteColor : Pallete.greyColor,
            ),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
