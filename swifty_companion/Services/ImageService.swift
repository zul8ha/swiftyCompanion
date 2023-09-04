//
//  ImageService.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 27.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

protocol IImageService {
    func loadImage(with imageURLString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageService: IImageService {
    private var imageDataTask: URLSessionDataTask?
    static let shared = ImageService()
    
    init() {
        
    }
    
    func loadImage(with imageURLString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: imageURLString) else { return }
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data,
               !data.isEmpty,
               let image = UIImage(data: data) {
                completion(.success(image))
            }
        }
//        imageDataTask?.cancel()
        imageDataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        
        imageDataTask?.resume()
    }
}
