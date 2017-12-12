//
//  ReadingValuesService.swift
//  ams-lab1
//
//  Created by Tomasz Frankiewicz on 09/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ReadingValuesService {
    
    var db: OpaquePointer?
    var sensorsService: SensorsService?
    
    init() {
        sensorsService = SensorsService()

        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("lab1.db")?.path
        
        if sqlite3_open(dbFilePath, &db) != SQLITE_OK {
            print("ERROR CONNECTING TO DB")
        } else {
            let createSQL = """
                            CREATE TABLE IF NOT EXISTS readingValues
                            (id INTEGER PRIMARY KEY AUTOINCREMENT,
                            timestamp TIMESTAMP,
                            value FLOAT,
                            sensor VARCHAR(50),
                            FOREIGN KEY (sensor) REFERENCES sensors(name));
                            """
            sqlite3_exec(db, createSQL, nil, nil, nil)
        }
    }
    
    func addRandomReadingValues(count: Int) -> String{
        let startTime = NSDate()
        for _ in 1...count{
            let timestamp : Date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - Double.random(min: 0.00, max: 31556926))
            let value: Float = Float.random(min: 0, max: 100)
            let sensorName = "S\(Int.random(min: 1, max: 20))"
            addReadingValue(timestamp: timestamp, sensorName: sensorName, value: value)
        }
        let finishTime = NSDate()
        return "Added \(count) readings in \(finishTime.timeIntervalSince(startTime as Date)).";
    }
    
    func addReadingValue(timestamp: Date, sensorName: String, value: Float) {
        let insertSQL = "INSERT INTO readingValues (timestamp, value, sensor) VALUES ('\(timestamp)', '\(value)', '\(sensorName)');"
        sqlite3_exec(db, insertSQL, nil, nil, nil)
    }
    
    func getReadingValues() -> [ReadingValue] {
        var readingValues: [ReadingValue] = []
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT timestamp, value, sensor FROM readingValues;"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let timestamp = String(cString: sqlite3_column_text(stmt, 0))
            let value = Float(String(cString: sqlite3_column_text(stmt, 1)))
            let sensor = String(cString: sqlite3_column_text(stmt, 2))
            
            readingValues.append(ReadingValue(id: nil, sensor: sensor, timestamp: getDateFromString(date: timestamp)!, value: value!))
        }
        sqlite3_finalize(stmt)
        
        return readingValues
    }
    
    public func getDateFromString(date: String?) -> Date? {
        if let date1 = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
            let date: Date? = dateFormatter.date(from: date1)

            return date!
        }
        return nil
    }
    
    func deleteAll(){
        let deleteSQL = "DELETE FROM readingValues;"
        sqlite3_exec(db, deleteSQL, nil, nil, nil)
    }
    
    func getLargestReadingValue() -> String{
        var response: String = "Empty readingValues.";
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT MAX(value) FROM readingValues;"
        let startTime = NSDate()
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let finishTime = NSDate()
            if(sqlite3_column_text(stmt, 0) != nil){
                let value : Float? = Float(String(cString: sqlite3_column_text(stmt, 0)))
                response =  "Largest value \(value!) found in \(finishTime.timeIntervalSince(startTime as Date)).";
            }
        }
        sqlite3_finalize(stmt)
        return response
    }
    func getSmallestReadingValue() -> String{
        var response: String = "Empty readingValues.";
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT MIN(value) FROM readingValues;"
        let startTime = NSDate()
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let finishTime = NSDate()
            if(sqlite3_column_text(stmt, 0) != nil){
                let value : Float? = Float(String(cString: sqlite3_column_text(stmt, 0)))
                response =  "Smallest value \(value!) found in \(finishTime.timeIntervalSince(startTime as Date)).";
            }
        }
        sqlite3_finalize(stmt)
        return response
    }
    func getAvgReadingValue() -> String{
        var response: String = "Empty readingValues.";
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT AVG(value) FROM readingValues;"
        let startTime = NSDate()
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let finishTime = NSDate()
            if(sqlite3_column_text(stmt, 0) != nil){
                let value : Float? = Float(String(cString: sqlite3_column_text(stmt, 0)))
                response =  "Average value \(value!) found in \(finishTime.timeIntervalSince(startTime as Date)).";
            }
        }
        sqlite3_finalize(stmt)
        return response
    }
    func getCountAndAvgValueForEachSensor() -> String{
        var response: String = "";

        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT sensor, AVG(value) FROM readingValues GROUP BY sensor;"
        let startTime = NSDate()
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let sensor = String(cString: sqlite3_column_text(stmt, 0))
            let avg = Float(String(cString: sqlite3_column_text(stmt, 1)))
            response = "\(response)\n\(sensor): \(avg!)"
        }
        let finishTime = NSDate()
        sqlite3_finalize(stmt)
        
        if (response.isEmpty){
            return "Empty readingValues.";
        } else {
            return "Average values found in \(finishTime.timeIntervalSince(startTime as Date))\(response)";
        }
    }
    
}
