//
//  ReadingValuesViewController.swift
//  ams-lab1
//
//  Created by Tomasz Frankiewicz on 09/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import UIKit

class ReadingValuesViewController: UITableViewController {

    var readingValues : [ReadingValue]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        readingValues = ReadingValuesService().getReadingValues()
        self.tableView.reloadData()
    }
    
}

extension ReadingValuesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingValues!.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingValueCell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        
        let readingValue = readingValues![indexPath.row]
        cell.textLabel?.text = "\(readingValue.sensor) - \(dateFormatter.string(from: readingValue.timestamp))"
        cell.detailTextLabel?.text = "Value: \(readingValue.value)"
        return cell
    }
}

