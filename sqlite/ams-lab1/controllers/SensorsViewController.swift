//
//  SensorsViewController.swift
//  ams-lab1
//
//  Created by Tomasz Frankiewicz on 09/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import UIKit

class SensorsViewController: UITableViewController {

    var sensors : [Sensor]?
    var sensorsService: SensorsService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sensorsService = SensorsService()
        sensors = sensorsService!.getSensors()
    }
    
}

extension SensorsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors!.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SensorCell", for: indexPath)
        
        let sensor = sensors![indexPath.row]
        cell.textLabel?.text = sensor.name
        cell.detailTextLabel?.text = sensor.descr
        return cell
    }
}
