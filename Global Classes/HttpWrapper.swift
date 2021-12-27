import UIKit
import Alamofire

@objc protocol HttpWrapperDelegate{
    @objc optional func HttpWrapperfetchDataSuccess(_ wrapper : HttpWrapper,dicsResponse : NSDictionary)
    
    @objc optional func HttpWrapperfetchDataSuccessWithArray(_ wrapper : HttpWrapper,dicsResponse : [AnyObject])
    
    @objc optional func HttpWrapperfetchDataFail(_ wrapper : HttpWrapper,error : NSError);
}

class HttpWrapper: NSObject {
    
    weak var delegate:HttpWrapperDelegate! = nil
    
    func requestWithparamdictParam(_ url : String ,dicsParams : [String: AnyObject])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        NSLog("Request info url: %@ --: %@",url,dicsParams);
        
        //  let authorize = ""
        //let parametetr = ["API_KEY": GlobalData.service_APIKEY]
        //        let manager = Alamofire.Manager.sharedInstance
        
        //        manager.session.configuration.timeoutIntervalForRequest = 300
        
        Alamofire.request(url, method: .get, parameters: nil, encoding:
            URLEncoding.httpBody, headers: nil)
            .responseString { response in
                if((response.result.error) != nil)
                {
                    //                    AppHelper.hideLoadingSpinner()
                    print("Sucees But Error: \(String(describing: response.result.error))")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseJSON { response in
                print("Response JSON: \n \(String(describing: response.result.value))")
                //                AppHelper.hideLoadingSpinner()
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value {
                        //                        var mydict = NSMutableDictionary()
                        //                        mydict = JSON as! NSMutableDictionary
                        
                        if (self.delegate != nil){
                            //                            self.delegate.HttpWrapperfetchDataSuccess?(self, dicsResponse: mydict)
                            
                            self.delegate.HttpWrapperfetchDataSuccessWithArray?(self, dicsResponse: JSON as! [AnyObject])
                        }
                        
                        let abc = response.result.value
                    }
                    else
                    {
                        
                        //                        AppHelper.showAlertWithTitle("", description1: "Please try again.")
                        print("response not converted to JSON")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate.HttpWrapperfetchDataFail!(self, error: response.result.error! as NSError);
                    }
                }
                
        }
        //            .responseString { response in
        //                NSLog("upload.response : response : %@", response.result.value!)
        //            }
    }
    
    func requestWithGETparamdictParam(_ url : String ,dicsParams : [String: AnyObject])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        NSLog("Request info url: %@ --: %@",url,dicsParams);
        
        //  let authorize = ""
        let parametetr = ["API_KEY": "1234"]
        //        let manager = Alamofire.Manager.sharedInstance
        
        //        manager.session.configuration.timeoutIntervalForRequest = 300
        
        Alamofire.request(url, method: .get, parameters: nil, encoding:
            URLEncoding.httpBody, headers: parametetr)
            .responseString { response in
                if((response.result.error) != nil)
                {
                    //                    AppHelper.hideLoadingSpinner()
                    print("Sucees But Error: \(String(describing: response.result.error))")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseJSON { response in
                print("Response JSON: \n \(String(describing: response.result.value))")
                //                AppHelper.hideLoadingSpinner()
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value {
                                                var mydict = NSMutableDictionary()
                                                mydict = JSON as! NSMutableDictionary
                        
                        if (self.delegate != nil){
                            //                            self.delegate.HttpWrapperfetchDataSuccess?(self, dicsResponse: mydict)
                            
                           self.delegate.HttpWrapperfetchDataSuccess?(self, dicsResponse: mydict)
                        }
                        let abc = response.result.value
                    }
                    else
                    {
                        
                        //                        AppHelper.showAlertWithTitle("", description1: "Please try again.")
                        print("response not converted to JSON")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate.HttpWrapperfetchDataFail!(self, error: response.result.error! as NSError);
                    }
                }
                
        }
        //            .responseString { response in
        //                NSLog("upload.response : response : %@", response.result.value!)
        //            }
    }
    
    func requestWithparamdictParamGetDict(_ url : String ,dicsParams : [String: AnyObject])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        NSLog("Request info url: %@ --: %@",url,dicsParams);
        
        
        let parametetr = ["API_KEY": "1234"]
        //        let manager = Alamofire.Manager.sharedInstance
        
        //        manager.session.configuration.timeoutIntervalForRequest = 300
        
        Alamofire.request(url, method: .get, parameters: nil, encoding:
            URLEncoding.httpBody, headers: parametetr)
            .responseString { response in
                if((response.result.error) != nil)
                {
                    //                    AppHelper.hideLoadingSpinner()
                    print("Sucees But Error: \(String(describing: response.result.error))")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseJSON { response in
                print("Response JSON: \n \(String(describing: response.result.value))")
                //                AppHelper.hideLoadingSpinner()
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value {
                        var mydict = NSDictionary()
                        mydict = JSON as! NSDictionary
                        
                        if (self.delegate != nil){
                            self.delegate.HttpWrapperfetchDataSuccess?(self, dicsResponse: mydict)
                            //                            self.delegate.HttpWrapperfetchDataSuccessWithArray?(self, dicsResponse: JSON as! [AnyObject])
                        }
                    }
                    else
                    {
                        
                        //                        AppHelper.showAlertWithTitle("", description1: "Please try again.")
                        print("response not converted to JSON")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate.HttpWrapperfetchDataFail!(self, error: response.result.error! as NSError);
                    }
                }
                
        }
        //            .responseString { response in
        //                NSLog("upload.response : response : %@", response.result.value!)
        //            }
    }
    
    func requestWithparamdictParamPostMethod(_ url : String ,dicsParams : Parameters)
    {
        if !self.checkInternetConnection()
        {
            return
        }
        NSLog("Request info url: %@ --: %@",url,dicsParams);
     
        let headers = ["API_KEY": "1234"]
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 500
        
        //        let manager = Alamofire.Manager.sharedInstance
        //        Alamofire.Manager.sharedInstance.session.configuration.timeoutIntervalForRequest = 300
        
        
        
        Alamofire.request(url, method: .post, parameters: dicsParams, encoding:
            URLEncoding.httpBody,headers: headers)
            .responseString { response in
                if((response.result.error) != nil)
                {
                    //                    AppHelper.hideLoadingSpinner()
                    print("Sucees But Error: \(response.result.error)")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseJSON { response in
                //                AppHelper.hideLoadingSpinner()
                print("Response JSON: \n \(response.result.value)")
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value
                    {
                        var mydict = NSDictionary()
                        mydict = JSON as! NSDictionary
                        
                        if (self.delegate != nil){
                            self.delegate.HttpWrapperfetchDataSuccess?(self, dicsResponse: mydict as NSDictionary)
                        }
                    }
                    else
                    {
                        //                        AppHelper.hideLoadingSpinner()
                        print("response not converted to JSON")
                        //                        AppHelper.showAlertWithTitle("", description1: "Please try again.")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate.HttpWrapperfetchDataFail!(self, error: response.result.error! as NSError);
                    }
                }
        }
        //            .responseString { response in
        //                NSLog("upload.response : response : %@", response.result.value!)
        //            }
    }
    
    func requestWithparamdictParamPostHeaderMethod(_ url : String ,dicsParams : [String : Any])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        NSLog("Request info url: %@ --: %@",url,dicsParams);
        
        
        let authorize = ""
        let parametetr = ["Content-Type":"application/json","Authorization":"Bearer \(authorize)"]
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(authorize)"
        ]
        
        
        
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 300
        
        
        Alamofire.request(url, method: .post, parameters: dicsParams, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                if((response.result.error) != nil)
                {
                    //                    AppHelper.hideLoadingSpinner()
                    print("Sucees But Error: \(response.result.error)")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseJSON { response in
                //                AppHelper.hideLoadingSpinner()
                print("Response JSON: \n \(response.result.value)")
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value
                    {
                        var mydict = NSDictionary()
                        mydict = JSON as! NSDictionary
                        
                        if (self.delegate != nil){
                            self.delegate.HttpWrapperfetchDataSuccess?(self, dicsResponse: mydict as NSDictionary)
                        }
                    }
                    else
                    {
                        //                        AppHelper.hideLoadingSpinner()
                        print("response not converted to JSON")
                        //                        AppHelper.showAlertWithTitle("", description1: "Please try again.")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate.HttpWrapperfetchDataFail!(self, error: response.result.error! as NSError);
                    }
                }
        }
        //            .responseString { response in
        //                NSLog("upload.response : response : %@", response.result.value!)
        //            }
    }
    
    func requestWithPostHeaderMethod(_ url : String ,dicsParams : [String : Any])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        NSLog("Request info url: %@ --: %@",url,dicsParams);
        
        
        let authorize = ""
        let parametetr = ["Content-Type":"application/json","Authorization":"Bearer \(authorize)"]
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(authorize)"
        ]
        
        
        
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 300
        
        
        Alamofire.request(url, method: .post, parameters: dicsParams, encoding: JSONEncoding.default, headers: parametetr)
            .responseString { response in
                if((response.result.error) != nil)
                {
                    //                    AppHelper.hideLoadingSpinner()
                    print("Sucees But Error: \(response.result.error)")
                    //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
                }
            }
            .responseJSON { response in
                //                AppHelper.hideLoadingSpinner()
                print("Response JSON: \n \(response.result.value)")
                if((response.result.error) == nil)
                {
                    if let JSON = response.result.value
                    {
                        var mydict = NSDictionary()
                        mydict = JSON as! NSDictionary
                        
                        if (self.delegate != nil){
                            self.delegate.HttpWrapperfetchDataSuccess?(self, dicsResponse: mydict as NSDictionary)
                        }
                    }
                    else if let JSON = response.result.value
                    {
                        var mydict = [AnyObject]()
                        mydict = JSON as! [AnyObject]
                        
                        if (self.delegate != nil){
                            self.delegate.HttpWrapperfetchDataSuccessWithArray!(self, dicsResponse: mydict as [AnyObject])
                        }
                    }
                    else
                    {
                        //                        AppHelper.hideLoadingSpinner()
                        print("response not converted to JSON")
                        //                        AppHelper.showAlertWithTitle("", description1: "Please try again.")
                    }
                }
                else
                {
                    if (self.delegate != nil){
                        self.delegate.HttpWrapperfetchDataFail!(self, error: response.result.error! as NSError);
                    }
                }
        }
        //            .responseString { response in
        //                NSLog("upload.response : response : %@", response.result.value!)
        //            }
    }
    
   
    func checkInternetConnection() -> Bool
    {
        //        let reachability = Reachability.forInternetConnection() as Reachability;
        //        let internetStatus : Int = reachability.currentReachabilityStatus().rawValue
        //        if ((internetStatus == 0) || (reachability.connectionRequired() == true)) {
        //            AppHelper.hideLoadingSpinner()
        //            AppHelper.showAlertWithTitle(key_NO_INTERNET_TITAL, description1: key_NO_INTERNET)
        //            return false;
        //        }
        return true;
    }
    
    
}
