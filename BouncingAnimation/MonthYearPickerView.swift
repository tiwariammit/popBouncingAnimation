//
//  MonthYearPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//

import UIKit

class MonthYearPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var datePicker: UIPickerView!
    var resetBrightNess : (()->())?
    
    //    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let months : [Int] = [1, 2, 3, 4,5,6,7,8,9,10,11,12]
    
    var years: [Int] = []
    
    var selectedMnth : Int?
    var selectedYear : Int?
    var dateTranfer: (([String:Int?])->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    
    
    func commonSetup() {
        
        var yrs = (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).component(.year, from: Date())
        
        for _ in 1...6 {
            
            years.append(yrs)
            yrs += 1
        }
        
        
        selectedMnth = 1
        selectedYear = years[0]
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(months[row])"
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            
            selectedMnth = months[row]
        }
        if component == 1{
            
            selectedYear = years[row]
        }
    }
    
    
    @IBAction func btnAc(_ sender: AnyObject) {
        
        handleOnDismiss()
    }
    
    
    func handleOnDismiss(){
        
        let dic = ["year": self.selectedYear, "month": self.selectedMnth]
        if let handler = self.dateTranfer{
            
            handler(dic)
        }
        if let handler = self.resetBrightNess{
            
            handler()
        }
        self.removeFromSuperview()
        
    }
}
