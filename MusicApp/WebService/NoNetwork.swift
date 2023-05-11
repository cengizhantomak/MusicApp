//
//  NoNetwork.swift
//  MusicApp
//
//  Created by Kerem Tuna Tomak on 11.05.2023.
//

import Foundation
import SystemConfiguration
import UIKit

class NoNetwork {

    static func isInternetAvailable() -> Bool {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "https://api.deezer.com/genre") else { return false }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) { return false }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
    
    static func showAlertIfNoInternet(presenter: UIViewController) {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "No internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                presenter.present(alert, animated: true, completion: nil)
            }
        }
    }
}
