//
//  ArtistModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

struct ArtistModel: Codable {
    let data: [ArtistDataModel]
}

struct ArtistDataModel: Codable {
    let id: Int
    let name: String
    let picture_medium: String
}
