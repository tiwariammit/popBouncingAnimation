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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnDate: UIButton!
    var noOfNotificationCharacters = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        setNavigationBarIcon(UIImage(named: "chat_icon"))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBarIcon(image: UIImage?){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWith(image, target: self, action: #selector(self.actionClick))
    }
    
    func actionClick(){
   
        let mainImage = UIImage(named: "chat_icon")
        if noOfNotificationCharacters == 1{
            
            print(noOfNotificationCharacters)
           let image = NotificationImageMaking().mixedImage(mainImage!, notificationNumber: "3", notificationNumberCharacter: noOfNotificationCharacters)
            setNavigationBarIcon(image)
            noOfNotificationCharacters += 1
            
        }else if noOfNotificationCharacters == 2{
            
            print(noOfNotificationCharacters)
            let image = NotificationImageMaking().mixedImage(mainImage!, notificationNumber: "33", notificationNumberCharacter: noOfNotificationCharacters)
            setNavigationBarIcon(image)
            noOfNotificationCharacters += 1
            
        }else{
            
            print(noOfNotificationCharacters)
            let image = NotificationImageMaking().mixedImage(mainImage!, notificationNumber: "333"
                , notificationNumberCharacter: noOfNotificationCharacters)
            setNavigationBarIcon(image)
            noOfNotificationCharacters -= 2
        }
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



extension UIColor{
    
    static func messageAlertColor()-> UIColor{
        
        return UIColor.redColor()
    }
    static func customBlueColor(alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: 23.0/255, green: 167.0/255, blue: 232.0/255, alpha: alpha)
    }
}

extension UIBarButtonItem {
    class func itemWith(image: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 51, 31) //won't work if you don't set frame
        button.setImage(image, forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        let barButtonItem = UIBarButtonItem()
        barButtonItem.customView = button
        return barButtonItem
    }
}

class NotificationImageMaking{
    
    func mixedImage(mainImage: UIImage, notificationNumber: String, notificationNumberCharacter: Int) -> UIImage{
        
        let circleImage = maskRoundedImage(imageFromView(), radius: 7)
        var textImage : UIImage?
        
        if notificationNumberCharacter == 1{
            
            textImage = textToImage(notificationNumber, inImage: circleImage, atPoint: CGPoint(x: 3.5, y: -0.5))
            
        }else if notificationNumberCharacter == 3{
            
            textImage = textToImage(notificationNumber, inImage: circleImage, atPoint: CGPoint(x: 0, y: 2),notificationNumberCharacter : 3)
            
        }else{
            
            textImage = textToImage(notificationNumber, inImage: circleImage, atPoint: CGPoint(x: 0.5, y: -0.5))
        }
        
        return mergeTheImage(mainImage, image2: textImage!)
        
    }
    
    
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    func imageFromView() -> UIImage {
        
        let myView = UIView()
        myView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        myView.backgroundColor = UIColor.redColor()
        UIGraphicsBeginImageContextWithOptions(myView.bounds.size, false, UIScreen.mainScreen().scale)
        myView.drawViewHierarchyInRect(myView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func mergeTheImage(image1 : UIImage, image2: UIImage)-> UIImage{
        
        let size = CGSizeMake(image1.size.width, image1.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        [image1.drawInRect(CGRectMake(0,0,size.width, image1.size.height))];
        [image2.drawInRect(CGRect(x: 12, y: 3, width: image2.size.width, height: image2.size.height))];
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint, notificationNumberCharacter : Int = 1) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.whiteColor()
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        let rect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        if notificationNumberCharacter == 3{
            
            let textFont  = UIFont(name: "Helvetica Bold", size: 8)!
            let textFontAttributes = [NSFontAttributeName: textFont,
                                      NSForegroundColorAttributeName: textColor,]
            drawText.drawInRect(rect, withAttributes: textFontAttributes)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
            
        }else{
            
            let textFont  = UIFont(name: "Helvetica Bold", size: 12)!
            let textFontAttributes = [NSFontAttributeName: textFont,
                                      NSForegroundColorAttributeName: textColor,]
            
            drawText.drawInRect(rect, withAttributes: textFontAttributes)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
            
        }
    }
}
