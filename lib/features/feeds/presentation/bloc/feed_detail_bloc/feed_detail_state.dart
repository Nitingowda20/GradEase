part of 'feed_detail_bloc.dart';

@immutable
class FeedDetailState {
  final FeedDetailStateStatus feedDetailStateStatus;
  final FeedPostEntity? feedPost;
  final List<FeedPostReplyEntity>? feedPostReplies;
  final String? errorMessage;
  final bool? isReplying;
  final bool? isDeleting;

  const FeedDetailState({
    this.feedDetailStateStatus = FeedDetailStateStatus.initial,
    this.feedPost,
    this.feedPostReplies,
    this.errorMessage,
    this.isReplying = false,
    this.isDeleting = false,
  });

  FeedDetailState copyWith({
    FeedDetailStateStatus? feedDetailStateStatus,
    FeedPostEntity? feedPost,
    String? errorMessage,
    List<FeedPostReplyEntity>? feedPostReplies,
    final bool? isReplying,
    final bool? isDeleting,
  }) {
    return FeedDetailState(
      feedDetailStateStatus:
          feedDetailStateStatus ?? this.feedDetailStateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      feedPost: feedPost ?? this.feedPost,
      feedPostReplies: feedPostReplies ?? this.feedPostReplies,
      isReplying: isReplying ?? this.isReplying,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

enum FeedDetailStateStatus { initial, loading, success, error, deletedPost }
