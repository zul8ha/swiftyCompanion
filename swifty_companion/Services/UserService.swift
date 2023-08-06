//
//  UserService.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 17.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

protocol IUserService {
    func loadUserData(with login: String, accessToken: String, completion: @escaping (Result<User, Error>) -> Void)
    
    func search(with searchString: String, accessToken: String, completion: @escaping (Result<[User], Error>) -> Void)
}

/// Performs the urlRequest to load Users data using the httpClient and AccessToken and decodes the User from loaded data
final class UserService: IUserService {

    private let accessToken: AccessToken
    private let httpClient: IHTTPClient
    
    init(
        accessToken: AccessToken,
        httpClient: IHTTPClient
    ) {
        self.accessToken = accessToken
        self.httpClient = httpClient
    }
    
    func search(with searchString: String, accessToken: String, completion: @escaping (Result<[User], Error>) -> Void) {
        
    }
   
    func loadUserData(with login: String, accessToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)") else { return }
        var urlRequest = URLRequest(url: url)
        let bearer = "Bearer \(accessToken)"
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
                //                print("🐙🐙🐙 \(error)")
            }
        }
    }
}
