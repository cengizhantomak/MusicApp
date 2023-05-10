//
//  LikeViewModel.swift
//  MusicApp
//
//  Created by Cengizhan Tomak on 9.05.2023.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class LikeViewModel {
    private(set) var favoriteTracks: [NSManagedObject] = []
    
    private(set) var audioPlayer: AVPlayer?
    private(set) var isPlaying: Bool = false
    
    var numberOfRows: Int {
        return favoriteTracks.count
    }
    
    func track(at index: Int) -> NSManagedObject {
        return favoriteTracks[index]
    }
    
    // MARK: - Time Conversion
    func secondsToMinutesSeconds(seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    // MARK: - Core Data
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
    
    // MARK: - Audio Player
    func playPauseTrack(at index: Int) {
        let track = favoriteTracks[index]
        let previewUrl = track.value(forKey: "preview") as! String
        
        if let currentURL = audioPlayer?.currentItem?.asset as? AVURLAsset, currentURL.url.absoluteString == previewUrl {
            if isPlaying {
                audioPlayer?.pause()
                isPlaying = false
            } else {
                audioPlayer?.play()
                isPlaying = true
            }
        } else {
            if let previewURL = URL(string: previewUrl) {
                let playerItem = AVPlayerItem(url: previewURL)
                audioPlayer = AVPlayer(playerItem: playerItem)
                audioPlayer?.play()
                isPlaying = true
            }
        }
    }
    
    func stopPlaying() {
        audioPlayer?.pause()
        audioPlayer = nil
    }
    
    // MARK: - Search Tracks
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
