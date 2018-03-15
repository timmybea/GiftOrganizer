//
//  GiftBuilder.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-15.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge

class GiftBuilder {
    
    //Factory methods
    private init() {
        self.gift.id = UUID().uuidString
    }
    
    static func newGift() -> GiftBuilder {
        return GiftBuilder()
    }
    
    static func newGift(for event: Event) -> GiftBuilder {
        let gb = GiftBuilder()
        gb.addToEvent(event)
        gb.addToPerson(event.person!)
        return gb
    }
    
    static func updateGift(_ gift: Gift) -> GiftBuilder {
        let gb = GiftBuilder()
        gb.gift = gift
        return gb
    }
    
    private var gift = Gift()
    
    func addName(_ name: String) {
        self.gift.name = name
    }
    
    func addToPerson(_ person: Person) {
        person.addToGift(self.gift)
    }
    
    func addToEvent(_ event: Event) {
        self.gift.eventId = event.id
    }
    
    func canReturnGift() -> Bool {
        guard self.gift.id != nil else { return false }
        guard self.gift.name != nil else { return false }
        guard self.gift.person != nil else { return false }
        return true
    }
    
    func returnCompletedGift() -> Gift {
        return self.gift
    }
    
    func deleteGiftFromCoreData(_ dataPersistence: DataPersistence) {
        self.gift.managedObjectContext?.delete(self.gift)
        if let moc = dataPersistence.mainQueueContext {
            dataPersistence.saveToContext(moc)
        }
    }
}
