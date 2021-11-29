//
//  NetworkController.swift
//  RickAndMorty
//
//  Created by Yariv Nissim on 4/14/21.
//

import Foundation
import UIKit.UIImage

enum NetworkError: Error {
    case invalidEndpoint
    case invalidResponse
    case invalidData(Error)
    case invalidJSON
}

private enum Endpoint: String {
    case allCharacters = "https://rickandmortyapi.com/api/character/"
}

protocol NetworkController {
    func getAllCharacters(completion: @escaping (Result<RickAndMortyResponse, NetworkError>) -> Void)
    func getImage(for url: URL, completion: (UIImage?) -> Void)
}

final class NetworkControllerImpl {
    
    func getImage(for url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        .resume()
    }
    
    private func get<DataType: Decodable>(endpoint: Endpoint, completion: @escaping (Result<DataType, NetworkError>) -> Void) {
        
        guard let url = URL(string: endpoint.rawValue) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode != 404 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData(error!))) // send error
                return
            }
            
            do {
                let result = try JSONDecoder().decode(DataType.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.invalidJSON))
            }
        }
        .resume()
    }
    
    // Fetch all characters
    func getAllCharacters(completion: @escaping (Result<RickAndMortyResponse, NetworkError>) -> Void) {
        get(endpoint: .allCharacters, completion: completion)
    }
}
