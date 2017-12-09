//
//  ReadingValuesService.swift
//  ams-lab1
//
//  Created by Tomasz Frankiewicz on 09/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import Foundation

class ReadingValuesService {
    
    static func generateReadingValues() -> [ReadingValue] {
        
        let sensor1 = Sensor(name: "Akcelerometr", description: "Mierzy przyspieszenie liniowe")
        let sensor2 = Sensor(name: "Zyroskop", description: "Mierzy polozenie katowe")
        let sensor3 = Sensor(name: "Magnometr", description: "Mierzy sile, kirunek i zwrot pola magnetycznego")
        
        return [
            ReadingValue(timestamp: Date(), sensor: sensor1, value: 2.59),
            ReadingValue(timestamp: Date(), sensor: sensor2, value: 1.12),
            ReadingValue(timestamp: Date(), sensor: sensor1, value: 4.62),
            ReadingValue(timestamp: Date(), sensor: sensor1, value: 8.45),
            ReadingValue(timestamp: Date(), sensor: sensor1, value: 2.23),
            ReadingValue(timestamp: Date(), sensor: sensor2, value: 5.53),
            ReadingValue(timestamp: Date(), sensor: sensor3, value: 6.94),
        ]
    }
    
}
