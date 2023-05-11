//
//  AlbumDetailModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

struct AlbumDetailModel: Codable {
    let data: [AlbumDetailDataModel]
}

struct AlbumDetailDataModel: Codable {
    let id: Int
    let title: String
    let duration: Int
    let preview: String
    let artist: Artist
}

struct Artist: Codable {
    let name: String
}
