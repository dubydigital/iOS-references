//
//  File.swift
//  PackageReference
//
//  Created by Mark Dubouzet on 10/30/24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
}

class WebService {
    
    func fetch<T: Codable>(url: URL, parse: @escaping (Data) -> T?, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else {
                completion(.failure(.badRequest))
                return
            }
            let result = parse(data)
            completion(.success(result))
            
        }.resume()
        
    }
}
