query GetUserPermission($userId: ID!) {
  getUser(userId: $userId) {
    permission
  }
}
