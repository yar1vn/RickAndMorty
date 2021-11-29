//
//  NetworkControllerMock.swift
//  RickAndMortyTests
//
//  Created by Yariv Nissim on 4/14/21.
//

import UIKit
@testable import RickAndMorty

class NetworkControllerMock: NetworkController {
    func getImage(for url: URL, completion: (UIImage?) -> Void) {

    }

    func getAllCharacters(completion: @escaping (Result<RickAndMortyResponse, NetworkError>) -> Void) {
        
    }
}
