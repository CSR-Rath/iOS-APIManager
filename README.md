# API Manager

A clean and reusable APIManager built with Swift async/await.

## Features

- Generic API request handling
- Request & response logging
- Automatic refresh token handling
- Status code validation
- URL error mapping
- Support for query parameters
- Support for Encodable request body


## Status Code Handling

| Status Code | Description |
|---|---|
| 200...299 | Success |
| 401 | Unauthorized / Refresh Token |
| 403 | Forbidden |
| 408 | Timeout |
| 500...599 | Server Error |

## Technologies

- Swift
- URLSession
- Async/Await
- MVVM Architecture

## Example

```swift
let response: UserModel = try await APIManager.shared.request(
    body: .parameters([
        "email": "test@gmail.com",
        "password": "123456"
    ]),
    method: .post,
    endpoint: .login
)
