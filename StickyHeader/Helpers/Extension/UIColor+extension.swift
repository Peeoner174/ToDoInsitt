
import UIKit

public extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static var customRedColor: UIColor = {
        return UIColor(r: 217, g: 48, b: 80)
    }()

    static var customMainRedColor: UIColor = {
        return UIColor(r: 235, g: 96, b: 91)
    }()
    
    static var customStatusBarColor: UIColor = {
        return UIColor(r: 251, g: 203, b: 202)
    }()
    
    static var customWhiteColor: UIColor = {
       return UIColor(r: 233, g: 233, b: 241)
    }()
    
    static var customBlueColor: UIColor = {
        return UIColor(r: 96, g: 103, b: 184)
    }()
    
    static var customPinkColor: UIColor = {
        return UIColor(r: 227, g: 89, b: 149)
    }()
    
    static var customGrayColor: UIColor = {
        return UIColor(r: 158, g: 159, b: 166)
    }()
    
    static var customVeryWhiteColor: UIColor = {
        return UIColor(r: 247, g: 247, b: 247)
    }()
    
}
