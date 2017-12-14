//
//  SensorsService.swift
//  ams-lab1
//
//  Created by Tomasz Frankiewicz on 09/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SensorsService {
    
    var db: OpaquePointer? = nil

    init() {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("lab1.db")?.path
        
        if sqlite3_open(dbFilePath, &db) != SQLITE_OK {
            print("ERROR CONNECTING TO DB")
        } else {
            let createSQL = "CREATE TABLE IF NOT EXISTS sensors (name VARCHAR(50) PRIMARY KEY, descr VARCHAR(250));"
            sqlite3_exec(db, createSQL, nil, nil, nil)
            print("SQL: \(createSQL)")
        }
    }
    
    func addSensor(name: String, description: String) {
        let insertSQL = "INSERT INTO sensors (name, descr) VALUES ('\(name)', '\(description)');"
        sqlite3_exec(db, insertSQL, nil, nil, nil)
    }
    
    func getSensors() -> [Sensor] {
        var sensors: [Sensor] = []
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT name, descr FROM sensors;"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let descr = String(cString: sqlite3_column_text(stmt, 1))

            sensors.append(Sensor(name: name, descr: descr))
        }
        sqlite3_finalize(stmt)
        
        return sensors
    }
    
    func getSensorByName(sensorName: String) -> Sensor?{
        var sensor : Sensor?
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT name, descr FROM sensors WHERE name='\(sensorName)';"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let descr = String(cString: sqlite3_column_text(stmt, 1))
            
            sensor = Sensor(name: name, descr: descr)
        }
        sqlite3_finalize(stmt)
        
        return sensor
    }
    
}
