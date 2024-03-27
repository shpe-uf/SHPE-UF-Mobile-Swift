mutation RegisterUser($registerInput: RegisterInput) 
{
  register(registerInput: $registerInput) {
    username
    points
    major
    lastName
    id
    graduating
    firstName
  }
}



