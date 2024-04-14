import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_ease/core/constants/string_contants.dart';
import 'package:grad_ease/core/theme/color_pallete.dart';
import 'package:grad_ease/features/feeds/domain/enitity/feed_post_entity.dart';
import 'package:grad_ease/features/feeds/domain/usecase/add_reply_use_case.dart';
import 'package:grad_ease/features/feeds/presentation/bloc/feed_detail_bloc/feed_detail_bloc.dart';
import 'package:grad_ease/features/feeds/presentation/widgets/feed_post.dart';

class PostDetailScreen extends StatefulWidget {
  final FeedPostEntity feedPost;
  const PostDetailScreen({Key? key, required this.feedPost}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final replyTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FeedDetailBloc>().add(
          GetAllPostReplies(postId: widget.feedPost.id),
        );
  }

  @override
  void dispose() {
    super.dispose();
    replyTextEditingController.dispose();
  }

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
              post: widget.feedPost,
            ),
            const Divider(),
            BlocConsumer<FeedDetailBloc, FeedDetailState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.feedDetailStateStatus ==
                    FeedDetailStateStatus.loading) {
                  return const Expanded(
                    child: Center(
                        child: SizedBox(
                      height: 30,
                      width: 40,
                      child: CircularProgressIndicator(),
                    )),
                  );
                }
                if (state.feedDetailStateStatus ==
                    FeedDetailStateStatus.success) {
                  if (state.feedPostReplies!.isEmpty) {
                    return Expanded(
                      child: Center(
                          child: Text(
                        "Be the first one to discuss on this post !",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.feedPostReplies!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(state
                                      .feedPostReplies![index]
                                      .author
                                      .profileImage ??
                                  StringConstants.avtarImage),
                            ),
                            title: Text(
                                state.feedPostReplies![index].author.fullName!),
                            subtitle:
                                Text(state.feedPostReplies![index].content!),
                          );
                        }),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: replyTextEditingController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Enter item',
                      ),
                      style: Theme.of(context).textTheme.labelMedium,
                      onSubmitted: (replyText) {
                        final addReplyParams = AddReplyUseCaseParams(
                          postId: widget.feedPost.id,
                          content: replyText,
                        );
                        context.read<FeedDetailBloc>().add(
                              AddNewReply(addReply: addReplyParams),
                            );
                      },
                    ),
                  ),
                  BlocBuilder<FeedDetailBloc, FeedDetailState>(
                    builder: (context, state) {
                      if (state.isReplying ?? false) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        );
                      }
                      return IconButton(
                          onPressed: () {
                            final addReplyParams = AddReplyUseCaseParams(
                              postId: widget.feedPost.id,
                              content: replyTextEditingController.text.trim(),
                            );
                            context.read<FeedDetailBloc>().add(
                                  AddNewReply(addReply: addReplyParams),
                                );
                            replyTextEditingController.clear();
                          },
                          icon: const Icon(Icons.send));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
