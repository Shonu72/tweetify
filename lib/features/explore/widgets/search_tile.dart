import 'package:flutter/material.dart';
import 'package:tweetify/models/user_models.dart';
import 'package:tweetify/theme/pallete.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(userModel.profilePic),
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          Text(
            userModel.bio,
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
