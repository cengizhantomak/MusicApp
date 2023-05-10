//
//  ImageLoader.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private var imageCache: [String: UIImage] = [:]
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache[urlString] {
            completion(cachedImage)
        } else {
            URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        self.imageCache[urlString] = image
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
                
            }.resume()
        }
    }
}
