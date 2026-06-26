//
//  Item.swift
//  PushLogic
//
//  Created by Josh Gdovin on 6/25/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
