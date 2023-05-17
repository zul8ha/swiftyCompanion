//
//  IURLSession.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 17.05.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation


protocol IURLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: IURLSession {}
