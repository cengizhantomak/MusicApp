//
//  ArtistDetailViewModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

class ArtistDetailViewModel {
    private let artistId: Int
    private var albumList = [ArtistDetailDataModel]()
    
    var numberOfAlbums: Int {
        return albumList.count
    }
    
    init(artistId: Int) {
        self.artistId = artistId
    }
    
    func album(at index: Int) -> ArtistDetailDataModel {
        return albumList[index]
    }
    
    // MARK: - Networking
    func fetchAlbums(completion: @escaping () -> Void) {
        let urlString = "https://api.deezer.com/artist/\(artistId)/albums"
        APIManager.shared.fetchData(urlString: urlString) { (result: Result<ArtistDetailModel, APIManager.APIError>) in
            switch result {
            case .success(let albumData):
                self.albumList = albumData.data
                completion()
            case .failure(let error):
                print("Failed to fetch data:", error)
            }
        }
    }
    
    // MARK: - Date Conversion
    func convertDate(inputDate: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-dd-mm"
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd.MM.yyyy"
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
