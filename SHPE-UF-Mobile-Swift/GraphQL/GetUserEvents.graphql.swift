query GetUserEvents($userId: ID!) {
  getUser(userId: $userId) {
    events {
      category
      name
      points
      createdAt
    }
  }
}

