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
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedContext = appDelegate.persistentContainer.viewContext
        sensorsService = SensorsService()
    }
    
    func addRandomReadingValues(count: Int) -> String{
        let startTime = NSDate()
        for _ in 1...count{
            let timestamp : Date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - Double.random(min: 0.00, max: 31556926))
            let value: Float = Float.random(min: 0, max: 100)
            let sensorId = Int.random(min: 1, max: 20)
            addReadingValue(timestamp: timestamp, sensorId: sensorId, value: value)
        }
        let finishTime = NSDate()
        return "Added \(count) readings in \(finishTime.timeIntervalSince(startTime as Date)).";
    }
    
    func addReadingValue(timestamp: Date, sensorId: Int, value: Float) {
        let entity = NSEntityDescription.entity(forEntityName: "ReadingValue", in: managedContext!)
        let readingValue = NSManagedObject(entity: entity!, insertInto: managedContext)
        let sensor = sensorsService!.getSensorById(sensorId: sensorId)
        
        readingValue.setValue(timestamp, forKey: "timestamp")
        readingValue.setValue(sensor, forKey: "sensor")
        readingValue.setValue(value, forKey: "value")
        try? managedContext?.save()
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
    
    func getLargestReadingValue() -> String{
        let keypathExp1 = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "max:", arguments: [keypathExp1])
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
            return "Largest value \(value[0]["result"]!) found in \(finishTime.timeIntervalSince(startTime as Date)).";
        } catch {
            return "ERROR FETCHING READING VALUE"
        }
    }
    func getSmallestReadingValue() -> String{
        let keypathExp1 = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "min:", arguments: [keypathExp1])
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
            return "Smallest value \(value[0]["result"]!) found in \(finishTime.timeIntervalSince(startTime as Date)).";
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
            return "Average value \(value[0]["result"]!) found in \(finishTime.timeIntervalSince(startTime as Date))"
        } catch {
            return "ERROR FETCHING READING VALUE"
        }
    }
    func getCountAndAvgValueForEachSensor() -> String{
        let keypathExp1 = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "average:", arguments: [keypathExp1])
        let desc = NSExpressionDescription()
        desc.expression = expression
        desc.name = "result"
        desc.expressionResultType = .floatAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingValue")
//        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToGroupBy = ["sensor"]
        fetchRequest.propertiesToFetch = ["sensor", desc]
        
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let startTime = NSDate()
            let groupedAvg = try managedContext!.fetch(fetchRequest) as! [NSDictionary]
            let finishTime = NSDate()
            var responseText = ""
            for sensorAvg in groupedAvg{
                let sensor : Sensor = managedContext!.object(with: sensorAvg["sensor"]! as! NSManagedObjectID) as! Sensor
                responseText = "\(responseText)\n\(sensor.name!): \(sensorAvg["result"]!)"
            }
            return "Average values found in \(finishTime.timeIntervalSince(startTime as Date))\(responseText)"
        } catch {
            return "ERROR FETCHING READING VALUE"
        }
    }
    
}
