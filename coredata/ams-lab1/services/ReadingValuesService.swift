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
    
    var managedContext: NSManagedObjectContext?
    var sensorsService: SensorsService?
    var sensors: [Sensor]?
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedContext = appDelegate.persistentContainer.viewContext
        sensorsService = SensorsService()
        sensors = sensorsService?.getSensors()
    }
    
    func addRandomReadingValues(count: Int) -> String{
        for _ in 1...count{
            let readingValue = NSEntityDescription.insertNewObject(forEntityName: "ReadingValue", into: managedContext!)

            let timestamp : Date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - Double.random(min: 0.00, max: 31556926))
            let value: Float = Float.random(min: 0, max: 100)
            let sensor = sensors![Int.random(min: 0, max: 19)]
            
            readingValue.setValue(timestamp, forKey: "timestamp")
            readingValue.setValue(sensor, forKey: "sensor")
            readingValue.setValue(value, forKey: "value")
        }
        
        let startTime = NSDate()
        try? managedContext?.save()
        let finishTime = NSDate()
        print("CoreData duration: \(finishTime.timeIntervalSince(startTime as Date))s.")
        return "Added \(count) readings in \(finishTime.timeIntervalSince(startTime as Date))s."
    }
    
    
    func getReadingValues() -> [ReadingValue] {
        let fetchRequest = NSFetchRequest<ReadingValue>(entityName: "ReadingValue")
        
        do {
            let readingValues = try managedContext!.fetch(fetchRequest)
            return readingValues
        } catch {
            print("ERROR FETCHING READING VALUES")
            return []
        }
    }
    
    func deleteAll(){
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue"))
        do {
            try managedContext!.execute(deleteAllRequest)
        }
        catch {
            print("ERROR DELETING READING VALUES")
        }
    }
    
    func getLargestAndSmallestReadingValue() -> String{
        let keypathExp1 = NSExpression(forKeyPath: "value")
        
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExp1])
        let maxDesc = NSExpressionDescription()
        maxDesc.expression = maxExpression
        maxDesc.name = "max"
        maxDesc.expressionResultType = .floatAttributeType
        
        let minExpression = NSExpression(forFunction: "min:", arguments: [keypathExp1])
        let minDesc = NSExpressionDescription()
        minDesc.expression = minExpression
        minDesc.name = "min"
        minDesc.expressionResultType = .floatAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = [maxDesc,minDesc]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let startTime = NSDate()
            let value = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
            let finishTime = NSDate()
            if(value[0]["max"] != nil){
                print("CoreData duration: \(finishTime.timeIntervalSince(startTime as Date))s, largest: \(value[0]["max"]!), smallest: \(value[0]["min"]!)")
                return "Largest value \(value[0]["max"]!), smallest value \(value[0]["min"]!) found in \(finishTime.timeIntervalSince(startTime as Date))s.";
            } else {
                return "Empty readingValues."
            }
        } catch {
            return "ERROR FETCHING READING VALUE"
        }
    }
    func getAvgReadingValue() -> String{
        let keypathExp1 = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "average:", arguments: [keypathExp1])
        let desc = NSExpressionDescription()
        desc.expression = expression
        desc.name = "result"
        desc.expressionResultType = .floatAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = [desc]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let startTime = NSDate()
            let value = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
            let finishTime = NSDate()
            if(value[0]["result"] != nil){
                print("CoreData duration: \(finishTime.timeIntervalSince(startTime as Date))s, result: \(value[0]["result"]!)")
                return "Average value \(value[0]["result"]!) found in \(finishTime.timeIntervalSince(startTime as Date))s."
            } else {
                return "Empty readingValues."
            }
        } catch {
            return "ERROR FETCHING READING VALUE"
        }
    }
    func getCountAndAvgValueForEachSensor() -> String{
        let keypathExp1 = NSExpression(forKeyPath: "value")
        
        let avgExpression = NSExpression(forFunction: "average:", arguments: [keypathExp1])
        let avgDesc = NSExpressionDescription()
        avgDesc.expression = avgExpression
        avgDesc.name = "avg"
        avgDesc.expressionResultType = .floatAttributeType
        
        let countExpression = NSExpression(forFunction: "count:", arguments: [keypathExp1])
        let countDesc = NSExpressionDescription()
        countDesc.expression = countExpression
        countDesc.name = "count"
        countDesc.expressionResultType = .floatAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
        fetchRequest.propertiesToGroupBy = ["sensor"]
        fetchRequest.propertiesToFetch = ["sensor", avgDesc, countDesc]
        
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let startTime = NSDate()
            let groupedAvg = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
            let finishTime = NSDate()
            var responseText = ""
            if (!groupedAvg.isEmpty){
                for sensorAvg in groupedAvg{
                    let sensor : Sensor = managedContext!.object(with: sensorAvg["sensor"]! as! NSManagedObjectID) as! Sensor
                    responseText = "\(responseText)\n\(sensor.name!): count: \(sensorAvg["count"]!), avg: \(sensorAvg["avg"]!)"
                }
                print("CoreData duration: \(finishTime.timeIntervalSince(startTime as Date))s, result: \(responseText)")
                return "Average values found in \(finishTime.timeIntervalSince(startTime as Date))s\(responseText)"
            } else {
                return "Empty readingValues."
            }
        } catch {
            return "ERROR FETCHING READING VALUE"
        }
    }
    
}
