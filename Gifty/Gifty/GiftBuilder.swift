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
        guard self.gift.cost != nil else { completion(false, CustomErrors.createGift.noBudget); return }
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
