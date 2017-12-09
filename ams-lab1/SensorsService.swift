//
//  SensorsService.swift
//  ams-lab1
//
//  Created by Tomasz Frankiewicz on 09/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import Foundation

class SensorsService {
    
    static func generateSensors() -> [Sensor] {
        return [
            Sensor(name: "Akcelerometr", description: "Mierzy przyspieszenie liniowe"),
            Sensor(name: "Zyroskop", description: "Mierzy polozenie katowe"),
            Sensor(name: "Magnometr", description: "Mierzy sile, kirunek i zwrot pola magnetycznego")
        ]
    }
    
}
