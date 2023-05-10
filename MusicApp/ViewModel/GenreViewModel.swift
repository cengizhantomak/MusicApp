//
//  GenreViewModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation

class GenreViewModel {
    private var genreList = [GenreDataModel]()
    
    var numberOfGenres: Int {
        return genreList.count
    }
    
    func genre(at index: Int) -> GenreDataModel {
        return genreList[index]
    }
    
    // MARK: - Networking
    func fetchGenres(completion: @escaping () -> Void) {
        let urlString = "https://api.deezer.com/genre"
        APIManager.shared.fetchData(urlString: urlString) { (result: Result<GenreModel, APIManager.APIError>) in
            switch result {
            case .success(let genreData):
                self.genreList = genreData.data
                completion()
            case .failure(let error):
                print("Failed to fetch data:", error)
            }
        }
    }
}
