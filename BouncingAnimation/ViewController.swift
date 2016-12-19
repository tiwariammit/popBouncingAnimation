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
        
        self.navigationController?.isNavigationBarHidden = false
        setNavigationBarIcon(UIImage(named: "chat_icon"))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBarIcon(_ image: UIImage?){
        
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
    
    
    
    @IBAction func PopOverPresent(_ sender: AnyObject) {
        
        
        if let customView = Bundle.main.loadNibNamed("AnnotationXibView", owner: self, options: nil)?[0] as? MonthYearPickerView {
            
            
            customView.frame = CGRect(x: 20, y: 200, width: self.view.frame.width - 40, height: self.view.frame.height - 400)
            let backGroundViewSize = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            backGroundView1 = UIView(frame: backGroundViewSize)
            
            customView.resetBrightNess = { [weak self] data in
                
                
                self?.backGroundView1?.removeFromSuperview()
            }
            
            customView.dateTranfer = { [weak self]
                date in
                if let mnth = date["month"]{
                    
                    if let m = mnth{
                        
                        if let yrs = date["year"]{
                            if let year = yrs{
                                
                                let str = "\(m)" + " / " + "\(year)"
                                self?.btnDate.setTitle(str, for: UIControlState())
                            }
                        }
                    }
                }
            }
            if let v = backGroundView1{
                
                v.backgroundColor = UIColor.black
                v.alpha = 0.7
                self.view.addSubview(v)
            }
            
            customView.transform = CGAffineTransform(scaleX: 0, y: 0)
            customView.layer.borderWidth = 5
            customView.layer.borderColor = UIColor.red.cgColor
            self.view.addSubview(customView)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4, options: .curveLinear, animations: {() -> Void in
                
                customView.transform = CGAffineTransform.identity
                
                }, completion: { _ in })
        }
    }
}



extension UIColor{
    
    static func messageAlertColor()-> UIColor{
        
        return UIColor.red
    }
    static func customBlueColor(_ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: 23.0/255, green: 167.0/255, blue: 232.0/255, alpha: alpha)
    }
}

extension UIBarButtonItem {
    class func itemWith(_ image: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 51, height: 31) //won't work if you don't set frame
        button.setImage(image, for: UIControlState())
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem()
        barButtonItem.customView = button
        return barButtonItem
    }
}

class NotificationImageMaking{
    
    func mixedImage(_ mainImage: UIImage, notificationNumber: String, notificationNumberCharacter: Int) -> UIImage{
        
        let circleImage = maskRoundedImage(imageFromView(), radius: 7)
        var textImage : UIImage?
        
        if notificationNumberCharacter == 1{
            
            textImage = textToImage(notificationNumber as NSString, inImage: circleImage, atPoint: CGPoint(x: 3.5, y: -0.5))
            
        }else if notificationNumberCharacter == 3{
            
            textImage = textToImage(notificationNumber as NSString, inImage: circleImage, atPoint: CGPoint(x: 0, y: 2),notificationNumberCharacter : 3)
            
        }else{
            
            textImage = textToImage(notificationNumber as NSString, inImage: circleImage, atPoint: CGPoint(x: 0.5, y: -0.5))
        }
        
        return mergeTheImage(mainImage, image2: textImage!)
        
    }
    
    
    func maskRoundedImage(_ image: UIImage, radius: Float) -> UIImage {
        
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
    
    func imageFromView() -> UIImage {
        
        let myView = UIView()
        myView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        myView.backgroundColor = UIColor.red
        UIGraphicsBeginImageContextWithOptions(myView.bounds.size, false, UIScreen.main.scale)
        myView.drawHierarchy(in: myView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func mergeTheImage(_ image1 : UIImage, image2: UIImage)-> UIImage{
        
        let size = CGSize(width: image1.size.width, height: image1.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        [image1.draw(in: CGRect(x: 0,y: 0,width: size.width, height: image1.size.height))];
        [image2.draw(in: CGRect(x: 12, y: 3, width: image2.size.width, height: image2.size.height))];
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func textToImage(_ drawText: NSString, inImage: UIImage, atPoint: CGPoint, notificationNumberCharacter : Int = 1) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.white
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
        
        if notificationNumberCharacter == 3{
            
            let textFont  = UIFont(name: "Helvetica Bold", size: 8)!
            let textFontAttributes = [NSFontAttributeName: textFont,
                                      NSForegroundColorAttributeName: textColor,]
            drawText.draw(in: rect, withAttributes: textFontAttributes)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
            
        }else{
            
            let textFont  = UIFont(name: "Helvetica Bold", size: 12)!
            let textFontAttributes = [NSFontAttributeName: textFont,
                                      NSForegroundColorAttributeName: textColor,]
            
            drawText.draw(in: rect, withAttributes: textFontAttributes)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
            
        }
    }
}
