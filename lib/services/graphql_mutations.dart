class GraphQLMutations {
  // Post mutations
  static const String createPostMutation = '''
    mutation CreatePost(\$title: String!, \$content: String!, \$imageUrl: String) {
      createPost(title: \$title, content: \$content, imageUrl: \$imageUrl) {
        id
        title
        content
        imageUrl
        author {
          id
          name
        }
        createdAt
      }
    }
  ''';

  static const String updatePostMutation = '''
    mutation UpdatePost(\$id: ID!, \$title: String, \$content: String, \$imageUrl: String) {
      updatePost(id: \$id, title: \$title, content: \$content, imageUrl: \$imageUrl) {
        id
        title
        content
        imageUrl
        updatedAt
      }
    }
  ''';

  static const String deletePostMutation = '''
    mutation DeletePost(\$id: ID!) {
      deletePost(id: \$id) {
        id
        success
      }
    }
  ''';

  // Like mutations
  static const String likePostMutation = '''
    mutation LikePost(\$postId: ID!) {
      likePost(postId: \$postId) {
        id
        likes
      }
    }
  ''';

  static const String unlikePostMutation = '''
    mutation UnlikePost(\$postId: ID!) {
      unlikePost(postId: \$postId) {
        id
        likes
      }
    }
  ''';

  // Comment mutations
  static const String createCommentMutation = '''
    mutation CreateComment(\$postId: ID!, \$content: String!) {
      createComment(postId: \$postId, content: \$content) {
        id
        content
        author {
          id
          name
          avatar
        }
        createdAt
      }
    }
  ''';

  static const String deleteCommentMutation = '''
    mutation DeleteComment(\$id: ID!) {
      deleteComment(id: \$id) {
        id
        success
      }
    }
  ''';

  // User mutations
  static const String updateProfileMutation = '''
    mutation UpdateProfile(\$name: String, \$bio: String, \$avatar: String) {
      updateProfile(name: \$name, bio: \$bio, avatar: \$avatar) {
        id
        name
        bio
        avatar
      }
    }
  ''';

  static const String followUserMutation = '''
    mutation FollowUser(\$userId: ID!) {
      followUser(userId: \$userId) {
        id
        followers
      }
    }
  ''';

  static const String unfollowUserMutation = '''
    mutation UnfollowUser(\$userId: ID!) {
      unfollowUser(userId: \$userId) {
        id
        followers
      }
    }
  ''';

  // Authentication mutations
  static const String loginMutation = '''
    mutation Login(\$email: String!, \$password: String!) {
      login(email: \$email, password: \$password) {
        token
        user {
          id
          name
          email
          avatar
        }
      }
    }
  ''';

  static const String registerMutation = '''
    mutation Register(\$name: String!, \$email: String!, \$password: String!) {
      register(name: \$name, email: \$email, password: \$password) {
        token
        user {
          id
          name
          email
        }
      }
    }
  ''';

  static const String logoutMutation = '''
    mutation Logout {
      logout {
        success
      }
    }
  ''';
} 