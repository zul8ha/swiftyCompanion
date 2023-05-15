//
//  HTTPClient.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/15/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

// curl -X POST --data "grant_type=client_credentials&client_id=fd018336ae27ca0008145cf91632254239433a6646ee6441f1c1e28b48962c29&client_secret=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" https://api.intra.42.fr/oauth/token

// curl  -H "Authorization: Bearer d1e32b7ac31f4c92558fc9e4797fdf214ccb9baf2d8fbe95fd287a04ae580f0b" "https://api.intra.42.fr/v2/users/ccade"

import Foundation

enum HTTPClientError: Error {
    case dataTaskError(Error)
    case unknownResponse
    case noDataInResponse
    case badstatusCode(Int)
    case decodingError(DecodingError)
}

protocol IHTTPClient {
    
    @discardableResult
    func load(
}

// MARK: - loadUserdata
  
  func loadUserdata(with login: String?) {
      
      guard let login = login else { return }
      // curl  -H "Authorization: Bearer d1e32b7ac31f4c92558fc9e4797fdf214ccb9baf2d8fbe95fd287a04ae580f0b" "https://api.intra.42.fr/v2/users/ccade"
      if let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)") {
          var urlRequest = URLRequest(url: url)
          let bearer = "Bearer 8571b975f8e276f637b4b04a66b118f03933c4da7f3f5bd7a914fdc11f93d6a2"
          urlRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
          
          let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
              guard let self = self else { return }
              self.handleResult(data: data, response: response, error: error)
          }
          
          let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: completionHandler)
          dataTask.resume()
      }
  }
  
  func handleResult(data: Data?, response: URLResponse?, error: Error?) {
      if (error != nil) {
          showError(error!.localizedDescription)
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
          showError("Wrong response type")
          return
      }
      
      guard 200..<300 ~= httpResponse.statusCode else {
          showError("Wrong status type: \(httpResponse.statusCode)")
          return
      }
      
      guard let data = data else {
          showError("Empty data")
          return
      }
      
      let decoder = JSONDecoder()
      do {
          let decodedUser = try decoder.decode(User.self, from: data)
          DispatchQueue.main.async {
              self.user = decodedUser
              
              self.showUser(decodedUser)
              
          }
      } catch {
          showError("Decoding Error: \(error)")
          print(String(bytes: data, encoding: .utf8)!)
      }
  }
