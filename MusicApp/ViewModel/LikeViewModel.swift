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
}
