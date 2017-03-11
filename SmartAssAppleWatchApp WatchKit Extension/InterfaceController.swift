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
    
    @IBOutlet var tempLabel: WKInterfaceLabel!
    
    @IBOutlet var showImage: WKInterfaceImage!
    
    @IBOutlet var diaperLabel: WKInterfaceLabel!
    
    @IBOutlet var cameraButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
       
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    @IBAction func ActionCameraButton () {
        print("click camera button!")
        getImage()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        tempLabelInterval()
        diaperLabelInterval()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    /*func makePOSTcall() {
        
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
        
    }*/
    
    func diaperLabelInterval() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getDiaperCall), userInfo: nil, repeats: true)    }
    
    func tempLabelInterval() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(makeGETcall), userInfo: nil, repeats: true)
    }
    
    func makeGETcall() {
        
        var request = URLRequest(url: URL(string: "http://10.59.2.228:1880/temperature")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject (with: data!, options: []) as! [[String:Any]]
                    let array = parsedData[0] as! [String:Any]
                    let temp = array["temperature"] as! Double
                    var tempString = (String(format:"Temp: %.1fºC ", temp))
                    if (temp > 37) { tempString.append("🔥") }
                    else if ( temp == 37 ) { tempString.append("👌🏼") }
                    else if (temp < 37) { tempString.append("❄️") }
                    self.tempLabel.setText(tempString)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func getDiaperCall() {
        
        var request = URLRequest(url: URL(string: "http://10.59.2.228:1880/diaper")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject (with: data!, options: []) as! [[String:Any]]
                    let array = parsedData[0] as! [String:Any]
                    let diaper = array["wet"] as! Double
                    var diaperString = ""
                    if (diaper == 1) { diaperString.append("💩💦💩💦") }
                    else if (diaper == 0) { diaperString.append("👶🏼👶🏼👶🏼") }
                    self.diaperLabel.setText(diaperString)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func getImage() {
        
        var request = URLRequest(url: URL(string: "http://10.59.2.228:1880/image")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
            } else {
                do {
                    print("data=\(data)")
                    print("response=\(response)")
                    //let parsedData = try JSONSerialization.jsonObject (with: data!, options: []) as! [[String:Any]]
                    //let array = parsedData[0] as! [String:Any]
                    self.showImage.setImageData(data)
 
                } catch let error as NSError {
                    //print(error)
                }
            }
            
            }.resume()
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
