### Geocoder API

## Getting started

1. Clone the repo
  ```
  $ git clone git@github.com:dmitryz/geocoder.git
  $ cd geocoder
  ```
1. Install dependencies
  ```
  $ bundle install
  ```
1. Whatch the scpecs pass
  ```
  $ ./bin/rspec
  ```
1. Define environment variables:
  `GEOCODER_GOOGLE_URL = "https://maps.googleapis.com/maps/api/geocode/json"`
  `GEOCODER_GOOGLE_KEY = "MY KEY"`

## API

1. Authenticate
  ```
  REQUEST: POST /auth/sign_in
  BODY (json): { "email": "my@email.com", "password": "my_password" }
  SUCCESSFULL RESPONSE CODE: 200
  UNAUTHORIZED RESPONSE CODE: 401
  RESPONSE HEADERS:
    access-token: TOken
    token-type: Bearer
    client: clientID

  REQUEST: GET /geocodes/search?query=Checkpoint Charly
  REQUEST HEADERS:
    access-token: From Authentication
    client: Client ID from authentication
    uid: Client email
    Content-Type: application/json; charset=utf-8
  SUCCESSFULL RESPONSE CODE: 200
  UNAUTHORIZED RESPONSE CODE: 401
  RESPONSE BODY (json):
    {"longtitude": 1, "latitude": 2}
  ```

## Description

1. Implemented Ruby philosophy of duck typing, on Geocoder library.
As such we can quickly add any new external geocode adapter.
1. Dependency injection of adapters in geocode resolver, as result low coupled and testable classes.
1. DeviseTokenAuth gem, Simple, multi-client and secure token-based authentication for Rails. Very useful for single page application.
1. Representers decorator for json output a rich set of options and semantics for parsing and rendering documents.

