//
//  ArtistViewModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

class ArtistViewModel {
    private let genreId: Int
    private var artistList = [ArtistDataModel]()
    
    var numberOfArtists: Int {
        return artistList.count
    }
    
    init(genreId: Int) {
        self.genreId = genreId
    }
    
    func artist(at index: Int) -> ArtistDataModel {
        return artistList[index]
    }
    
    func fetchArtists(completion: @escaping () -> Void) {
        let urlString = "https://api.deezer.com/genre/\(genreId)/artists"
        APIManager.shared.fetchData(urlString: urlString) { (result: Result<ArtistModel, APIManager.APIError>) in
            switch result {
            case .success(let artistData):
                self.artistList = artistData.data
                completion()
            case .failure(let error):
                print("Failed to fetch data:", error)
            }
        }
    }
}
