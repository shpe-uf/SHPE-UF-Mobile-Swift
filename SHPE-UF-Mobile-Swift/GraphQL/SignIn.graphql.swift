mutation SignIn($username: String!, $password: String!, $remember: String!) {
  login(username: $username, password: $password, remember: $remember) {
    year
    username
    updatedAt
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
    id
    firstName
    lastName
    major
    photo
    token
    country
    ethnicity
    graduating
    internships
    classes
    sex
    socialMedia
    permission
  }
}
