//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 07.06.2023.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ) { // запрос на получение токена аутентификации
        assert(Thread.isMainThread) // проверяем, вызывается ли метод из главного потока
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let session = urlSession
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let decodedObject):
                completion(.success(decodedObject.accessToken))
                self?.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

    private func authTokenRequest(code: String) -> URLRequest { // func создает и возвращает URL запрос для получения авторизационного токена
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = Constants.defaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

private enum NetworkError: Error {
    case codeError
}
