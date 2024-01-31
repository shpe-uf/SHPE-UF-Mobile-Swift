mutation SignIn($username: String!, $password: String!, $remember: String!) {
  login(username: $username, password: $password, remember: $remember) {
    year
    username
    updatedAt
    summerPoints
    springPoints
    confirmed
    createdAt
    email
    events {
      attendance
      id
      name
      semester
      points
    }
    fallPoints
    id
    firstName
    lastName
    major
    photo
    token
  }
}

