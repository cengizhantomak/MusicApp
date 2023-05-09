//
//  GenreModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

struct GenreModel: Codable {
    let data: [GenreDataModel]
}

struct GenreDataModel: Codable {
    let id: Int
    let name: String
    let picture_medium: String
}
