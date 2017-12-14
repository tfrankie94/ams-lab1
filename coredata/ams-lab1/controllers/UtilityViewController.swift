//
//  UtilityViewController.swift
//  ams-lab1
//
//  Created by Tomasz Frankiewicz on 09/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import UIKit

class UtilityViewController: UIViewController {
    
    @IBOutlet weak var readingCountTextField: UITextField!
    @IBOutlet weak var utilityTextArea: UITextView!
    var readingValuesService: ReadingValuesService?
    
    @IBAction func addStatedNumberOfReadings(_ sender: UIButton) {
        guard let text = readingCountTextField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Warning", message: "Fill number of readings input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let response = readingValuesService!.addRandomReadingValues(count: Int(readingCountTextField.text!)!);
        utilityTextArea.text = "\(utilityTextArea.text!)\n\(response)"
    }
    
    @IBAction func deleteAllReadings(_ sender: UIButton) {
        readingValuesService!.deleteAll()
        utilityTextArea.text = "\(utilityTextArea.text!)\nDeleted all readings."
    }
    
    @IBAction func findLargestAndSmallestValue(_ sender: UIButton) {
        let text = readingValuesService!.getLargestAndSmallestReadingValue()
        utilityTextArea.text = "\(utilityTextArea.text!)\n\(text)"
    }
    @IBAction func calculateAvgReadingValue(_ sender: UIButton) {
        let text = readingValuesService!.getAvgReadingValue()
        utilityTextArea.text = "\(utilityTextArea.text!)\n\(text)"
    }
    @IBAction func calculateReadingsCountAndAvgForEachSensor(_ sender: UIButton) {
        let text = readingValuesService!.getCountAndAvgValueForEachSensor()
        utilityTextArea.text = "\(utilityTextArea.text!)\n\(text)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readingValuesService = ReadingValuesService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

public extension Int {
    
    /// Returns a random Int point number between 0 and Int.max.
    public static var random: Int {
        return Int.random(n: Int.max)
    }
    
    /// Random integer between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random Int point number between 0 and n max
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    ///  Random integer between min and max
    ///
    /// - Parameters:
    ///   - min:    Interval minimun
    ///   - max:    Interval max
    /// - Returns:  Returns a random Int point number between 0 and n max
    public static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
        
    }
}

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

public extension Float {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
