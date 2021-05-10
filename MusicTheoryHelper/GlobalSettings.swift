//
//  GlobalSettings.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 8/12/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import Foundation
import UIKit

struct GlobalSettings {
    static let noteNames1: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    static let noteNames2: [String] = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    static var noteNames: [String] {
        switch noteNameOption {
        case 0:
            return noteNames1
        case 1:
            return noteNames2
        default:
            print("Invalid note name option index")
            return noteNames1
        }
    }
    static var noteNameOption: Int = 0
    static var playAudio: Bool = true
    
    static let version: String = "1.1.4"
    static var showAds: Bool = true
    static var chadHamdan: Bool = false
    
    static func displayIsCompact() -> Bool {
        if UIScreen.main.nativeBounds.height <= 1136 {
            return true
        } else {
            return false
        }
    }
    
    static func deviceIsiPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad { return true }
        return false
    }
    
    static func deviceIs97InchiPad() -> Bool {
        if UIScreen.main.nativeBounds.height <= 2048 && UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
    
    static func deviceIs129InchiPad() -> Bool {
        if UIScreen.main.nativeBounds.height >= 2732 && UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
    
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

/* Swift 3
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}
*/

extension UIColor {
    static func appleBlue() -> UIColor {
        //return UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        return UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
    }
}

func firstTimeLaunchingApp() -> Bool {
    if let _ = UserDefaults.standard.string(forKey: "firstTimeLaunchingApp"){
        return false
    } else {
        UserDefaults.standard.set(true, forKey: "firstTimeLaunchingApp")
        return true
    }
}
