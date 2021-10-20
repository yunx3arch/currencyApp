//
//  ViewController.swift
//  currencyApp
//
//  Created by Yun Xu on 10/19/21.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var from: UIPickerView!
    @IBOutlet weak var to: UIPickerView!
    var currencyArray:[String] = []
    var rateArray:[Double] = []
    let baseURL = "http://api.exchangeratesapi.io/v1/latest?"
    let apiKey = "2e0f7eccf59db55804f527f00713108d&format=1"
    var currencyFrom:String = ""
    var currencyTo:String = ""
    var valueFrom:Double = 0
    var valueTo:Double = 0
    var values:[Double] = []

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencyArray.sort()
        return currencyArray[row]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //connect
        to.delegate=self
        to.dataSource=self
        from.dataSource=self
        from.delegate=self
        // api request
        let session = URLSession(configuration: .default)
        let url = baseURL + "access_key=" + apiKey
        var request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request) {(data, response, error) in
            
            if error != nil{
                print("network nerror")
            }
            else if let data = data {
                do {
                    let r = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    let rates = r["rates"] as! NSDictionary
                    
                    for (key, value) in rates {
                        self.currencyArray.append((key as? String)!)
                        self.rateArray.append(value as! Double)
                    }
                    self.currencyFrom = self.currencyArray[0]
                    self.valueFrom = self.rateArray[0]
                    self.currencyTo = self.currencyArray[0]
                    self.valueTo = self.rateArray[0]
                    print(self.currencyArray)
              
                } catch {
                    print("error")
                    return
                }
            }
            self.from.reloadAllComponents()
            self.to.reloadAllComponents()
        }
        task.resume()

        
    }
  
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if (pickerView.tag == 1) {
                currencyFrom = currencyArray[row]
                valueFrom = rateArray[row]
                print(currencyFrom, valueFrom)
            }
            if (pickerView.tag == 2) {
                currencyTo = currencyArray[row]
                valueTo = rateArray[row]
            }
        }

    @IBAction func getResult(_ sender: Any) {
        
        SwiftSpinner.show("loading")
        SwiftSpinner.hide()
        
        // currency calculation
        let rst:Double = 1/valueFrom * valueTo
        let rstStr = String(format: "%.02f", rst)
        self.result.text = rstStr

    }

}

