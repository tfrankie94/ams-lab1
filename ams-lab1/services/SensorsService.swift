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
    
    var managedContext: NSManagedObjectContext?

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    //use NSFetchedResultsController later
//    init(fetchRequest: NSFetchRequest<ResultType>,
//         managedObjectContext context: NSManagedObjectContext,
//         sectionNameKeyPath: String?,
//         cacheName name: String?)
    
    func addSensor(name: String, description: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: managedContext!)
        let sensor = NSManagedObject(entity: entity!, insertInto: managedContext)
        sensor.setValue(name, forKey: "name")
        sensor.setValue(description, forKey: "descr")
        try? managedContext?.save()
    }
    
    func getSensors() -> [Sensor] {
        let fetchRequest = NSFetchRequest<Sensor>(entityName: "Sensor")
        
        let sensors : [Sensor]
        do {
            try sensors = managedContext!.fetch(fetchRequest)
        } catch {
            print("ERROR FETCHING SENSORS")
            return []
        }
        return sensors
    }
    
    func getSensorById(sensorId: Int) -> Sensor?{
        let name = "S\(sensorId)"
        let fetchRequest = NSFetchRequest<Sensor>(entityName: "Sensor")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        let sensors : [Sensor]
        do {
            sensors = try managedContext!.fetch(fetchRequest)
        } catch {
            print("ERROR FETCHING SENSOR BY ID")
            return nil
        }
        return sensors[0]
    }
    
    /*
     let fr = NSFetchRequest<NSFetchRequestResult>  (entityName: "Person")
     fr.resultType = .dictionaryResultType
     let ed = NSExpressionDescription()
     ed.name = "MinimumAge"
     ed.expression = NSExpression(format: "@min.age")
     ed.expressionResultType = .integer16AttributeType
     fr.propertiesToFetch = [ed]
     try? result = moc.fetch(fr)
     */
    
    //update:
//    let someMafia = mafias.first
//    someMafia?.setValue("Cosa Nostra", forKey: "name")
//    try? moc?.save()
    
    //delete:
//    let someMafia = mafias.first
//    moc?.delete(someMafia!)
//    try? moc?.save()
    
}
