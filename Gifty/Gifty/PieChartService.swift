//
//  PieChartService.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-09.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge

class PieChartService: NSObject {
    
    private override init() { }
    
    static let shared = PieChartService()
    
    func getSpendingData() -> [PieData]? {
        //amount spent, group name, number of gifts, averageCost
        guard let frc = PersonFRC.frc(byGroup: true), let sections = frc.sections else { return nil }
        var returnData = [PieData]()
        
        for section in sections {
            let group = section.name

            var amtSpent: Float = 0
            var numGifts: Int = 0
            guard let people = section.objects as? [Person] else { continue }
            
            for person in people {
                guard let events = person.event?.allObjects as? [Event] else { continue }
                
                for event in events where DateHandler.sameComponent(.year, date1: event.date!, date2: DateHandler.localTimeFromUTC(Date())){
                    if event.isComplete {
                        amtSpent += event.actualAmt
                        numGifts += 1
                    }
                }
            }
            if amtSpent > 0 {
                let data = PieData(amtSpent: amtSpent, group: group, numberOfGifts: numGifts)
                returnData.append(data)
            }
        }
        return returnData.count > 0 ? returnData : nil
    }
    
    
    func getBudgetData() -> [PieData]? {

        guard let frc = PersonFRC.frc(byGroup: true), let sections = frc.sections else { return nil }
        var returnData = [PieData]()
        
        for section in sections {
            let group = section.name
            
            var amtBudgetted: Float = 0
            var numGifts: Int = 0
            guard let people = section.objects as? [Person] else { continue }
            
            for person in people {
                guard let events = person.event?.allObjects as? [Event] else { continue }
                
                for event in events where DateHandler.sameComponent(.year, date1: event.date!, date2: DateHandler.localTimeFromUTC(Date())){
                    
                    if !event.isComplete && event.budgetAmt > 0 {
                        amtBudgetted += event.budgetAmt
                        numGifts += 1
                    }
                }
            }
            if amtBudgetted > 0 {
                let data = PieData(amtSpent: amtBudgetted, group: group, numberOfGifts: numGifts)
                returnData.append(data)
            }
        }
        return returnData.count > 0 ? returnData : nil
    }
    
    
}

struct PieData {
    var amtSpent: Float
    var group: String
    var numberOfGifts: Int
    var averageCost: Float {
        return amtSpent / Float(numberOfGifts)
    }
}
