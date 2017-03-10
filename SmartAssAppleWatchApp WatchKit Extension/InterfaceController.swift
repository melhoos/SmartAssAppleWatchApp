//
//  InterfaceController.swift
//  SmartAssAppleWatchApp WatchKit Extension
//
//  Created by Marianne Melhoos on 10/03/17.
//  Copyright © 2017 Marianne Melhoos. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var timer = Timer()

    @IBOutlet var notifySlackButton: WKInterfaceButton!
    
    @IBOutlet var tempLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func ActionForButton() {
        print("triggered button")
        //makePOSTcall()
        //makeGETcall()
        tempLabelInterval()
        //tempLabelInterval()
        //tempLabel.setText("test")
    }
    
    func makePOSTcall() {
        
        let json: [String: Any] = ["text": "test"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: URL(string: "https://hooks.slack.com/services/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")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")

            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    func tempLabelInterval() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(makeGETcall), userInfo: nil, repeats: true)
    }
    
    func makeGETcall() {
        print("kommer hit! 11 gang")
        var request = URLRequest(url: URL(string: "http://10.59.2.228:1880/temperature")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let currentConditions = parsedData as! [String:Any]
                    
                    print(currentConditions)
                    
                    let currentTemperature = currentConditions["temperature"] as! String?
                    print(currentTemperature)
                    self.tempLabel.setText(currentTemperature)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        /*
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // convert String to NSData
            var nsData: NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
            var error: NSError?
            
            // convert NSData to 'AnyObject'
            let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),
                                                                            error: &error)
            /*
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
            }
            
            let responseString = String(data: data, encoding: .utf8)
            */
            print("responseString = \(responseString)")
            self.tempLabel.setText(responseString)
        }
        task.resume()
        */
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    
    

}
