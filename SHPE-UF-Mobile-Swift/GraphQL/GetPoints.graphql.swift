query GetPoints($userId: ID!) {
  getUser(userId: $userId) {
    fallPoints
    springPoints
    summerPoints
  }
}

