mutation ForgotPassword($email: String!) {
  forgotPassword(email: $email) {
    id
    token
  }
}
