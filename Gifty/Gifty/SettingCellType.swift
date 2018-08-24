//
//  SettingCellType.swift
//  Gifty
//
//  Created by Tim Beals on 2017-12-15.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

struct SettingData {
    
    var section: String
    var settingCells: [SettingCellType]
    
    static func getSettingDatasource() -> [SettingData] {
        let output = [SettingData(section: "Categories",
                                  settingCells: [SettingCellType(type: .segue, args: ["Groups"]),
                                                 SettingCellType(type: .segue, args: ["Events"])]),
                      SettingData(section: "Budget & Spending",
                                  settingCells: [SettingCellType(type: .textfield,
                                                                 args: [TFSettingsCellID.budgetAmt.rawValue]),
                                                 SettingCellType(type: .scrollview, args: ["rounding"])]),
                      
                      SettingData(section: "Purchase & Review",
                                  settingCells: [SettingCellType(type: .popOver, args: ["View upgrade options", "popOver"]),
                                                 SettingCellType(type: .segue, args: ["Review this app"])])
        ]
        return output
    }
}

struct SettingCellType {

    var type: CellType

    var args: [String]

    enum CellType {
        case segue
        case popOver
        case textfield
        case scrollview
    }
}

