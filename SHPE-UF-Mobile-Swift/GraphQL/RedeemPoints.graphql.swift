mutation RedeemPoints($redeemPointsInput: RedeemPointsInput) {
  redeemPoints(redeemPointsInput: $redeemPointsInput) {
    fallPoints
    fallPercentile
    springPoints
    springPercentile
    summerPercentile
    summerPoints
    events {
      category
      name
      points
      createdAt
      id
    }
  }
}
