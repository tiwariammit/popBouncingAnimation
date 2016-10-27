//
//  ViewController.swift
//  BouncingAnimation
//
//  Created by Amrit on 10/26/16.
//  Copyright © 2016 Amrit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var backGroundView1 : UIView?

    @IBOutlet weak var btnDate: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func PopOverPresent(sender: AnyObject) {
        
        
        if let customView = NSBundle.mainBundle().loadNibNamed("AnnotationXibView", owner: self, options: nil)[0] as? MonthYearPickerView {
            
            
            customView.frame = CGRect(x: 20, y: 150, width: self.view.frame.width - 40, height: self.view.frame.height - 300)
            let backGroundViewSize = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            backGroundView1 = UIView(frame: backGroundViewSize)
            
            customView.resetBrightNess = {
                
                self.backGroundView1?.removeFromSuperview()
            }
            
            customView.dateTranfer = {
                date in
                if let mnth = date["month"]{
                    
                    if let m = mnth{
                        
                        if let yrs = date["year"]{
                            if let year = yrs{
                                
                                let str = "\(m)" + " / " + "\(year)"
                                self.btnDate.setTitle(str, forState: UIControlState.Normal)
                            }
                        }
                    }
                }
            }
            if let v = backGroundView1{
                
                v.backgroundColor = UIColor.blackColor()
                v.alpha = 0.7
                self.view.addSubview(v)
            }
            
            customView.transform = CGAffineTransformMakeScale(0, 0)
            customView.layer.borderWidth = 5
            customView.layer.borderColor = UIColor.redColor().CGColor
            self.view.addSubview(customView)
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4, options: .CurveLinear, animations: {() -> Void in
                
                customView.transform = CGAffineTransformIdentity
                
                }, completion: { _ in })
        }
        

    }

}

