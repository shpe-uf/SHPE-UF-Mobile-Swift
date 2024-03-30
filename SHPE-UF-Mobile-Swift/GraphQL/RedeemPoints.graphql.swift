mutation RedeemPoints($redeemPointsInput: RedeemPointsInput) {
  redeemPoints(redeemPointsInput: $redeemPointsInput) {
    fallPoints
    fallPercentile
    springPoints
    springPercentile
    summerPercentile
    summerPoints
    points
    events {
      category
      name
      points
      createdAt
      id
    }
  }
}
