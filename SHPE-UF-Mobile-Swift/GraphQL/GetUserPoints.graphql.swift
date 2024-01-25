query GetUserPoints($userId: ID!) {
  getUser(userId: $userId) {
    points
  }
}
