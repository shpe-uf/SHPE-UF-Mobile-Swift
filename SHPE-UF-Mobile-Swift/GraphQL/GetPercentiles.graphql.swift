query GetPercentiles($userId: ID!) {
  getUser(userId: $userId) {
    fallPercentile
    springPercentile
    summerPercentile
  }
}
