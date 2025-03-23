enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

enum PostType {
  Post,
  Detail,
  ParentPost,
  Saved,
  Poll,
  PollDetail,
  ParentPoll,
  Mention,
}

enum SortUser {
  Verified,
  Alphabetically,
  Newest,
  Oldest,
  MaxFollower,
}

enum NotificationType {
  NOT_DETERMINED,
  Message,
  Post,
  Comment,
  Repost,
  Follow,
  Mention,
  Like
}
