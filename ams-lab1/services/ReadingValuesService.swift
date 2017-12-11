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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ReadingValue")
        
        let readingValues : [ReadingValue]
        do {
            try readingValues = managedContext!.fetch(fetchRequest) as! [ReadingValue]
        } catch {
            print("ERROR FETCHING READING VALUES")
            return []
        }
        return readingValues
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
    
}
