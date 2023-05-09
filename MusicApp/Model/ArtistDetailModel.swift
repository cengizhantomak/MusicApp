//
//  ArtistDetailModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

struct ArtistDetailModel: Codable {
    let data: [ArtistDetailDataModel]
}

struct ArtistDetailDataModel: Codable {
    let id: Int
    let title: String
    let cover_medium: String
    let release_date: String
}
