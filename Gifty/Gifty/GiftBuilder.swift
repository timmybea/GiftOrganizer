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
        self.gift = Gift(context: DataPersistenceService.shared.mainQueueContext!)
        self.gift.id = UUID().uuidString
    }
    
    private init(dataPersistence: DataPersistence) {
        self.gift = Gift(context: dataPersistence.mainQueueContext!)
        self.gift.id = UUID().uuidString
    }
    
    private init(gift: Gift) {
        self.gift = gift
    }
    
    static func newGift(dataPersistence: DataPersistence) -> GiftBuilder {
        return GiftBuilder()
    }
    
    static func newGift(for event: Event, dataPersistence: DataPersistence) -> GiftBuilder {
        let gb = GiftBuilder(dataPersistence: dataPersistence)
        gb.addToEvent(event)
        gb.addToPerson(event.person!)
        return gb
    }
    
    static func updateGift(_ gift: Gift) -> GiftBuilder {
        return GiftBuilder(gift: gift)
    }
    
    private var gift: Gift
    
    func addName(_ name: String?) {
        self.gift.name = name
    }
    
    func addToPerson(_ person: Person?) {
        if let p = person {
            p.addToGift(self.gift)
        }
    }
    
    func addToEvent(_ event: Event) {
        self.gift.eventId = event.id
    }
    
    func canReturnGift(completion: (_ success: Bool, _ error: CustomErrors.createGift?) -> ()) {
        if self.gift.name == nil { completion(false, CustomErrors.createGift.noName) }
        if self.gift.person == nil { completion(false, CustomErrors.createGift.noPerson) }
        completion(true, nil)
    }
    
    func returnGift() -> Gift {
        return self.gift
    }
    
    func saveGiftToCoreData(_ dataPersistence: DataPersistence) {
        if let moc = dataPersistence.mainQueueContext {
            dataPersistence.saveToContext(moc)
        }
    }
    
    func deleteGiftFromCoreData(_ dataPersistence: DataPersistence) {
        self.gift.managedObjectContext?.delete(self.gift)
        if let moc = dataPersistence.mainQueueContext {
            dataPersistence.saveToContext(moc)
        }
    }
}
