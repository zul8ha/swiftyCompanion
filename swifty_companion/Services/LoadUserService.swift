//
//  LoadUserService.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 17.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

protocol IUserService {
    func loadUserData(with login: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class UserService: IUserService {
    
    private let httpClient: IHTTPClient
    
    init(with httpClient: IHTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadUserData(with login: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)") else { return }
        var urlRequest = URLRequest(url: url)
        let bearer = "Bearer 8d8e59dfced39371bc5e1c643ed6456cde23c9dabd7d4e7cda36a78892299401"
        urlRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
        
        httpClient.loadData(with: urlRequest) { result in
            switch result {
            case let .success(data):
                let decoder = JSONDecoder()
                do {
                    let decodedUser = try decoder.decode(User.self, from: data)
                    completion(.success(decodedUser))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
}
