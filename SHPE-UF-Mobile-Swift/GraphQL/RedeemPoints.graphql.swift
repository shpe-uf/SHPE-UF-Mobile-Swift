mutation RedeemPoints($redeemPointsInput: RedeemPointsInput) {
  redeemPoints(redeemPointsInput: $redeemPointsInput) {
      fallPoints
      springPoints
      summerPoints
  }
}
