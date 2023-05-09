//
//  LikeViewModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation
import UIKit
import CoreData

class LikeViewModel {
    
    private(set) var favoriteTracks: [NSManagedObject] = []
    
    var numberOfRows: Int {
        return favoriteTracks.count
    }
    
    func track(at index: Int) -> NSManagedObject {
        return favoriteTracks[index]
    }
    
    func fetchFavoriteTracks() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Track")

        do {
            favoriteTracks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch tracks. \(error), \(error.userInfo)")
        }
    }
    
    func secondsToMinutesSeconds(seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    func deleteTrackFromCoreData(track: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        context.delete(track)

        do {
            try context.save()
            print("Track removed from Core Data.")
        } catch let error as NSError {
            print("Could not delete track. \(error), \(error.userInfo)")
        }
    }
    
    func removeTrack(at index: Int) {
        favoriteTracks.remove(at: index)
    }
    
    func filterTracks(with searchText: String) {
        if searchText.isEmpty {
            fetchFavoriteTracks()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Track")
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            do {
                favoriteTracks = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch tracks. \(error), \(error.userInfo)")
            }
        }
    }
}
