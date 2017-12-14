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
        
        print("DB path: \(dbFilePath!)")
        
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
            print("SQL: \(createSQL)")
            
        }
    }
    
    func addRandomReadingValues(count: Int) -> String{
        var values : [String] = []
        for _ in 1...count{
            let timestamp : Date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - Double.random(min: 0.00, max: 31556926))
            let value: Float = Float.random(min: 0, max: 100)
            let sensorName = "S\(Int.random(min: 1, max: 20))"
            
            values.append("('\(timestamp)', '\(value)', '\(sensorName)')")
        }
        return addReadingValues(count: count, values: values)
    }
    
    func addReadingValues(count: Int, values: [String]) -> String {
        let startTime = NSDate()
        let insertSQL = "INSERT INTO readingValues (timestamp, value, sensor) VALUES \(values.joined(separator: ", "));"
        sqlite3_exec(db, insertSQL, nil, nil, nil)
        let finishTime = NSDate()
//        print("SQL: \(insertSQL)")
        print("SQL duration: \(finishTime.timeIntervalSince(startTime as Date))s")
        return "Added \(count) readings in \(finishTime.timeIntervalSince(startTime as Date))s.";

    }
    
    func getReadingValues() -> [ReadingValue] {
        var readingValues: [ReadingValue] = []
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT timestamp, value, sensor FROM readingValues;"
        print("SQL: \(selectSQL)")
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
        print("SQL: \(deleteSQL)")
        sqlite3_exec(db, deleteSQL, nil, nil, nil)
    }
    
    func getLargestAndSmallestReadingValue() -> String{
        var response: String = "Empty readingValues.";
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT MAX(value), MIN(value) FROM readingValues;"
        print("SQL: \(selectSQL)")
        let startTime = NSDate()
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let finishTime = NSDate()
            if(sqlite3_column_text(stmt, 0) != nil){
                let max : Float? = Float(String(cString: sqlite3_column_text(stmt, 0)))
                let min : Float? = Float(String(cString: sqlite3_column_text(stmt, 1)))
                print("SQL duration: \(finishTime.timeIntervalSince(startTime as Date))s, largest: \(max!), smallest: \(min!)")
                response =  "Largest value \(max!), smallest value \(min!) found in \(finishTime.timeIntervalSince(startTime as Date))s.";
            }
        }
        sqlite3_finalize(stmt)
        return response
    }
    func getAvgReadingValue() -> String{
        var response: String = "Empty readingValues.";
        
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT AVG(value) FROM readingValues;"
        print("SQL: \(selectSQL)")
        let startTime = NSDate()
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let finishTime = NSDate()
            if(sqlite3_column_text(stmt, 0) != nil){
                let value : Float? = Float(String(cString: sqlite3_column_text(stmt, 0)))
                print("SQL duration: \(finishTime.timeIntervalSince(startTime as Date))s, result: \(value!)")
                response =  "Average value \(value!) found in \(finishTime.timeIntervalSince(startTime as Date))s.";
            }
        }
        sqlite3_finalize(stmt)
        return response
    }
    func getCountAndAvgValueForEachSensor() -> String{
        var response: String = "";

        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT sensor, count(sensor), AVG(value) FROM readingValues GROUP BY sensor;"
        print("SQL: \(selectSQL)")
        let startTime = NSDate()
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let sensor = String(cString: sqlite3_column_text(stmt, 0))
            let count =  sqlite3_column_int(stmt, 1)
            let avg = Float(String(cString: sqlite3_column_text(stmt, 2)))
            response = "\(response)\n\(sensor): count: \(count), avg: \(avg!)"
        }
        let finishTime = NSDate()
        sqlite3_finalize(stmt)
        
        if (response.isEmpty){
            return "Empty readingValues.";
        } else {
            print("SQL duration: \(finishTime.timeIntervalSince(startTime as Date))s, result: \(response)")
            return "Average values found in \(finishTime.timeIntervalSince(startTime as Date))s\(response)";
        }
    }
    
}
