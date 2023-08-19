//
//  HTTPClient.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 16.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

//typealias DataCompletion = (Result<Data, Error>) -> Void
enum HTTPClientError: LocalizedError {
    case wrongResponseType
    case wrongStatusCode
    case emptyData
    case unauthorized
}

protocol IHTTPClient {
    
//    func loadData(with request: URLRequest, completion: DataCompletion)
    func loadData(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

final class HTTPClient: IHTTPClient {
    
    let session: IURLSession

    // URLSession.shared is an implicit dependencie
    init(with session: IURLSession = URLSession.shared) {
        self.session = session
    }
    
    func loadData(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
            guard let self = self else { return }
            self.handleResult(data: data, response: response, error: error, completion: completion)
        }
        let dataTask = session.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    func handleResult(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: (Result<Data, Error>) -> Void
    ) {
        if let error = error {
            completion(.failure(error))
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(HTTPClientError.wrongResponseType))
            return
        }
        if case let statusCode = httpResponse.statusCode, statusCode == 401 {
            completion(.failure(HTTPClientError.unauthorized))
            return
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            completion(.failure(HTTPClientError.wrongStatusCode))
            return
        }
        guard let data = data else {
            completion(.failure(HTTPClientError.emptyData))
            return
        }
        completion(.success(data))
    }
}
