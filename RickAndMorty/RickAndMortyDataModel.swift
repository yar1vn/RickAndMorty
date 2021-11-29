//
//  RickAndMortyDataModel.swift
//  RickAndMorty
//
//  Created by Yariv Nissim on 4/14/21.
//

import Foundation

struct RickAndMortyResponse: Codable {
    let info: PageInfo
    let results: [Character]

    enum CodingKeys: String, CodingKey {
        case info
        case results
    }
}

// MARK: - Info
struct PageInfo: Codable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?

    enum CodingKeys: String, CodingKey {
        case count
        case pages
        case next
        case prev
    }
}

// MARK: - Result
struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: URL?
    let episode: [String]
    let url: URL?
    let created: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case image
        case episode
        case url
        case created
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
