mutation CreateEvent($createEventInput: CreateEventInput) {
  createEvent(createEventInput: $createEventInput)
  {
    category
    code
    expiration
    name
    points
    request
  }
}

