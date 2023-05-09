//
//  APIManager.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

class APIManager {
    
    enum APIError: Error {
        case urlError
        case dataFetchError
        case jsonDecodingError
    }
    
    static let shared = APIManager()
    
    private init() { }
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.dataFetchError))
                print("Failed to fetch data:", error)
            }
            
            guard let data = data else {
                completion(.failure(.dataFetchError))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
                completion(.failure(.jsonDecodingError))
            }
        }.resume()
    }
}
