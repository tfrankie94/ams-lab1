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
//        let keypathExp1 = NSExpression(forKeyPath: "value")
//        let expression = NSExpression(forFunction: "max:", arguments: [keypathExp1])
//        let desc = NSExpressionDescription()
//        desc.expression = expression
//        desc.name = "result"
//        desc.expressionResultType = .floatAttributeType
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.propertiesToFetch = [desc]
//        fetchRequest.resultType = .dictionaryResultType
//
//        do {
//            let startTime = NSDate()
//            let value = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
//            let finishTime = NSDate()
//            return "Largest value \(value[0]["result"]!) found in \(finishTime.timeIntervalSince(startTime as Date)).";
//        } catch {
//            return "ERROR FETCHING READING VALUE"
//        }
        return "implementing"
    }
    func getSmallestReadingValue() -> String{
//        let keypathExp1 = NSExpression(forKeyPath: "value")
//        let expression = NSExpression(forFunction: "min:", arguments: [keypathExp1])
//        let desc = NSExpressionDescription()
//        desc.expression = expression
//        desc.name = "result"
//        desc.expressionResultType = .floatAttributeType
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.propertiesToFetch = [desc]
//        fetchRequest.resultType = .dictionaryResultType
//
//        do {
//            let startTime = NSDate()
//            let value = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
//            let finishTime = NSDate()
//            return "Smallest value \(value[0]["result"]!) found in \(finishTime.timeIntervalSince(startTime as Date)).";
//        } catch {
//            return "ERROR FETCHING READING VALUE"
//        }
        return "implementing"
    }
    func getAvgReadingValue() -> String{
//        let keypathExp1 = NSExpression(forKeyPath: "value")
//        let expression = NSExpression(forFunction: "average:", arguments: [keypathExp1])
//        let desc = NSExpressionDescription()
//        desc.expression = expression
//        desc.name = "result"
//        desc.expressionResultType = .floatAttributeType
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.propertiesToFetch = [desc]
//        fetchRequest.resultType = .dictionaryResultType
//
//        do {
//            let startTime = NSDate()
//            let value = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
//            let finishTime = NSDate()
//            return "Average value \(value[0]["result"]!) found in \(finishTime.timeIntervalSince(startTime as Date))"
//        } catch {
//            return "ERROR FETCHING READING VALUE"
//        }
        return "implementing"
    }
    func getCountAndAvgValueForEachSensor() -> String{
//        let keypathExp1 = NSExpression(forKeyPath: "value")
//        let expression = NSExpression(forFunction: "average:", arguments: [keypathExp1])
//        let desc = NSExpressionDescription()
//        desc.expression = expression
//        desc.name = "result"
//        desc.expressionResultType = .floatAttributeType
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
//        fetchRequest.propertiesToGroupBy = ["sensor"]
//        fetchRequest.propertiesToFetch = ["sensor", desc]
//
//        fetchRequest.resultType = .dictionaryResultType
//
//        do {
//            let startTime = NSDate()
//            let groupedAvg = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
//            let finishTime = NSDate()
//            var responseText = ""
//            for sensorAvg in groupedAvg{
//                let sensor : Sensor = managedContext!.object(with: sensorAvg["sensor"]! as! NSManagedObjectID) as! Sensor
//                responseText = "\(responseText)\n\(sensor.name!): \(sensorAvg["result"]!)"
//            }
//            return "Average values found in \(finishTime.timeIntervalSince(startTime as Date))\(responseText)"
//        } catch {
//            return "ERROR FETCHING READING VALUE"
//        }
        return "implementing"
    }
    
}
