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
        self.gift.isCompleted = false
    }
    
    private init(dataPersistence: DataPersistence) {
        self.gift = Gift(context: dataPersistence.mainQueueContext!)
        self.gift.id = UUID().uuidString
        self.gift.isCompleted = false
    }
    
    private init(gift: Gift) {
        self.gift = gift
    }
    
    private init(gift: Gift, person: Person) {
        self.gift = Gift(context: DataPersistenceService.shared.mainQueueContext!)
        self.gift.id = UUID().uuidString
        self.gift.person = person
        self.gift.name = gift.name
        self.gift.image = gift.image
        self.gift.cost = gift.cost
        self.gift.detail = gift.detail
        self.gift.isCompleted = false
    }
    
    static func newGift(dataPersistence: DataPersistence) -> GiftBuilder {
        return GiftBuilder(dataPersistence: dataPersistence)
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
    
    static func copyGift(_ gift: Gift, to person: Person) -> GiftBuilder {
        return GiftBuilder(gift: gift, person: person)
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
    
    func addCost(_ cost: Float) {
        self.gift.cost = cost
    }
    
    func addNote(_ text: String?) {
        if text != nil {
            self.gift.detail = text
        }
    }
    
    func addToEvent(_ event: Event) {
        self.gift.eventId = event.id
    }
    
    func addImage(_ image: UIImage) {
        let data = NSData(data: UIImageJPEGRepresentation(image, 0.3)!) as Data
        gift.image = data
    }
    
    func canReturnGift(completion: @escaping(_ success: Bool, _ error: CustomErrors.createGift?) -> ()) {
        guard self.gift.name != nil else { completion(false, CustomErrors.createGift.noName); return }
        guard self.gift.person != nil else { completion(false, CustomErrors.createGift.noPerson); return }
        completion(true, nil)
    }
    
    func returnGift() -> Gift {
        return self.gift
    }
    
    func saveGiftToCoreData(_ dataPersistence: DataPersistence) {
        if let moc = dataPersistence.mainQueueContext {
            dataPersistence.saveToContext(moc, completion: {
                //do nothing
            })
        }
    }
    
    func deleteGiftFromCoreData(_ dataPersistence: DataPersistence) {
        self.gift.managedObjectContext?.delete(self.gift)
        if let moc = dataPersistence.mainQueueContext {
            dataPersistence.saveToContext(moc, completion: {
                //do nothing
            })
        }
    }
}
