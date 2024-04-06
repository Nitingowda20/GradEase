import 'package:flutter/material.dart';
import 'package:grad_ease/core/theme/color_pallete.dart';
import 'package:grad_ease/features/feeds/data/feed_post_model.dart';
import 'package:grad_ease/features/feeds/presentation/widgets/feed_post.dart';

class PostDetailScreen extends StatelessWidget {
  final FeedPostModel feedPostModel;
  const PostDetailScreen({Key? key, required this.feedPostModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: ColorPallete.whiteColor),
        centerTitle: true,
        title: Text(
          "Detail",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FeedPost(
              post: FeedPostModel(
                title: feedPostModel.title,
                description: feedPostModel.description,
                name: feedPostModel.name,
                course: feedPostModel.course,
                profileUrl: feedPostModel.profileUrl,
                likeCount: 12,
                commentCount: 2,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                  itemCount: communityPosts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(communityPosts[index].profileUrl),
                      ),
                      title: Text(communityPosts[index].name),
                      subtitle: Text(communityPosts[index].description),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Enter item',
                      ),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}