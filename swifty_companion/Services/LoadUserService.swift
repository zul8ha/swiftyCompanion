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
        let bearer = "Bearer ce160a03f59ad525d303adedd25771688edbfbf61098dd2df0fb5f693229795e"
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
