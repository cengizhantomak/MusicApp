//
//  AlbumDetailViewModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

class AlbumDetailViewModel {
    private let albumId: Int
    private var trackList = [AlbumDetailDataModel]()
    
    var numberOfTracks: Int {
        return trackList.count
    }
    
    init(albumId: Int) {
        self.albumId = albumId
    }
    
    func track(at index: Int) -> AlbumDetailDataModel {
        return trackList[index]
    }
    
    func fetchTracks(completion: @escaping () -> Void) {
        let urlString = "https://api.deezer.com/album/\(albumId)/tracks"
        APIManager.shared.fetchData(urlString: urlString) { (result: Result<AlbumDetailModel, APIManager.APIError>) in
            switch result {
            case .success(let trackData):
                self.trackList = trackData.data
                completion()
            case .failure(let error):
                print("Failed to fetch data:", error)
            }
        }
    }
}
