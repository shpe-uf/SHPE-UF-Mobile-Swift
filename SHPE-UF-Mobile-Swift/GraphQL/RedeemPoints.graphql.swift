mutation RedeemPoints($redeemPointsInput: RedeemPointsInput) {
  redeemPoints(redeemPointsInput: $redeemPointsInput) {
    events {
      code
    }
  }
}
