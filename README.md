# swiftyCompanion
The idea of this application is to search for information about student of the 42 Network by their nickname.

## My app can
- Signs in using OAuth 2.0
- Shows preview of the found peers with their profiles pictures in a green contour, in case the user is active, also shows the status of the peer (student, alumni or some else)
- Shows peer's details which are profile picture, full name, email, pool year, the level and all the cursus skills with values in the sections and all the projects peer did or in progress with.
- It is possible to go back to the first view
- The project uses Auto Layout.

## Quality & UX decisions (what I focused on)
- Predictable UI states: search / loading / empty / error
- Clear user feedback when the API request fails or the user is not found
- Safe networking and parsing: input validation + decoding error handling
- MVP separation: UI stays simple, business logic stays testable
- Basic test coverage for the most error-prone parts (networking / parsing / view model logic)

## Edge cases handled
- Invalid / empty nickname
- Token expired (OAuth)
- Slow network / no internet
- Missing optional fields in API response

## Demo
https://github.com/hmeriann/swiftyCompanion/assets/78214685/efe6871c-8eac-4467-9a8c-0e1b17b60a62

