import UIKit
import SystemConfiguration

class GlobalData: NSObject {
    
    
    ///////////////////////////////////Gloabal Variable////////////////////
    
    //Map API KEY
   static let  MAP_APIKEY = "AIzaSyAaNXGgjVNVpvTKq3aLiFSI-b2Wm2AY8VU"
    
    //label Border Color
    static let lblBordeColor = UIColor.init(displayP3Red: 89/255, green: 89/255, blue: 89/255, alpha: 1.0)
    
    //label Border Thickness
    static let lblBorderThickness = 0.5
    
    //API KEY for Service Call
    static let service_APIKEY = "35ljrh4wu2"
    
    
    //////////////////////local Function variable////////////////////////////////
    
   static var activityIndicator = UIActivityIndicatorView()
   static var messageFrame = UIView()
    
    
     //////////////////////Functions////////////////////////////////

   static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family     = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func displayActivityIndicator(view : UIView,msg : String)
    {
        view.isUserInteractionEnabled = false
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 70, y: view.frame.midY - 70, width: 140, height: 140))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        print(messageFrame.frame.midX)
        activityIndicator.frame = CGRect(x: 60, y: 30, width: 20, height: 20)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        let strLabel = UILabel(frame: CGRect(x: 0, y: 70, width: 140, height: 50))
        strLabel.textAlignment = NSTextAlignment.center
        strLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        
    }
    
   static  func hideActivityIndicator(view : UIView)
    {
        activityIndicator.stopAnimating()
        messageFrame.isHidden = true
        view.isUserInteractionEnabled = true
    }
    
    
    static func showMessage(self1 : UIViewController,message : String)
    {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self1.present(alert, animated: true, completion: nil)
    }
    
//     static func getUUID() -> String {
//        let keychainAccess = KeychainAccess();
//        let Pass = keychainAccess.getPasscode("ApplicationIdentifier")
//        if(Pass!.length == 0) {
//            keychainAccess.setPasscode("ApplicationIdentifier", passcode: UIDevice.current.identifierForVendor!.uuidString)
//        }
//        return keychainAccess.getPasscode("ApplicationIdentifier") as! String
//    }
//
    
    
}
