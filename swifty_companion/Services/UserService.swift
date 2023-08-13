//
//  UserService.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 17.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//
// curl -X POST --data "grant_type=client_credentials&client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&client_secret=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" https://api.intra.42.fr/oauth/accessToken

import Foundation

protocol IUserService {
    func loadUserData(with login: String, completion: @escaping (Result<UserDetails, Error>) -> Void)
    
    func search(with searchString: String, completion: @escaping (Result<[UserSearchResult], Error>) -> Void)
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
    
    func search(with searchString: String, completion: @escaping (Result<[UserSearchResult], Error>) -> Void) {
        guard let url = URL(string: "https://api.intra.42.fr/v2/users?range[login]=\(searchString),\(searchString)z") else { return }
        var urlRequest = URLRequest(url: url)
        let bearer = "Bearer \(accessToken)"
        urlRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
        
        httpClient.loadData(with: urlRequest) { result in
            switch result {
            case let .success(data):
                let decoder = JSONDecoder()
                do {
                    let decodedUsersArray = try decoder.decode([UserSearchResult].self, from: data)
                    completion(.success(decodedUsersArray))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
   
    func loadUserData(with login: String, completion: @escaping (Result<UserDetails, Error>) -> Void) {
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)") else { return }
        var urlRequest = URLRequest(url: url)
        let bearer = "Bearer \(accessToken)"
        urlRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
        
        httpClient.loadData(with: urlRequest) { result in
            switch result {
            case let .success(data):
                let decoder = JSONDecoder()
                do {
                    let decodedUser = try decoder.decode(UserDetails.self, from: data)
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
