//
//  AlbumDetailViewModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation
import UIKit
import CoreData

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
    
    func secondsToMinutesSeconds(seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    func saveTrackToCoreData(track: AlbumDetailDataModel, albumImageUrl: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Track", in: context)!
        let newTrack = NSManagedObject(entity: entity, insertInto: context)
        
        newTrack.setValue(track.id, forKey: "id")
        newTrack.setValue(track.title, forKey: "title")
        newTrack.setValue(track.duration, forKey: "duration")
        newTrack.setValue(track.preview, forKey: "preview")
        newTrack.setValue(albumImageUrl, forKey: "imageUrl")
        
        do {
            try context.save()
            print("Track saved to Core Data.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func removeTrackFromCoreData(track: AlbumDetailDataModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Track")
        fetchRequest.predicate = NSPredicate(format: "id == %d", track.id)
        
        do {
            let fetchedTracks = try context.fetch(fetchRequest)
            if let trackToRemove = fetchedTracks.first {
                context.delete(trackToRemove)
                try context.save()
                print("Track removed from Core Data.")
            }
        } catch let error as NSError {
            print("Could not remove. \(error), \(error.userInfo)")
        }
    }
    
    func isFavoriteTrack(_ track: AlbumDetailDataModel) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Track")
        fetchRequest.predicate = NSPredicate(format: "id == %d", track.id)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch let error as NSError {
            print("Could not fetch tracks. \(error), \(error.userInfo)")
        }
        
        return false
    }
}
