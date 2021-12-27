import UIKit
import SkyFloatingLabelTextField

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPhone() -> Bool {
        let phoneNumberRegex = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}

class FeedbackViewController: UIViewController, HttpWrapperDelegate {

    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var txtFeedback: UITextView!
    
    var Name = String()
    var MobileNo = String()
    var Email = String()
    var Feedback = String()
    
    var request : HttpWrapper = HttpWrapper()
    var list : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        self.navigationItem.title = "Feedback"
        
        txtName.becomeFirstResponder()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
        txtFeedback.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)
        txtFeedback.layer.borderWidth = 1
        txtFeedback.layer.cornerRadius = 3
        btnSubmit.layer.cornerRadius = 8
        btnReset.layer.cornerRadius = 8
        
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }

    @objc func handleTap(sender: UITapGestureRecognizer? = nil){
        txtName.resignFirstResponder()
        txtMobileNo.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtFeedback.resignFirstResponder()
    }
    
    @IBAction func Submit(_ sender: Any) {
        
        Name = txtName.text!
        MobileNo = txtMobileNo.text!
        Email = txtEmail.text!
        Feedback = txtFeedback.text!
        
        var msg = ""
        if(Name == "")
        {
            msg = msg + "name"
        }
        if (MobileNo == "" || (!MobileNo.isValidPhone()))
        {
            if msg == ""
            {
                msg = msg + "mobile no"
            }
            else
            {
                msg = msg + ", mobile no"
            }
        }
        if (Email == "" || (!Email.isValidEmail()))
        {
            if msg == ""
            {
                msg = msg + "email"
            }
            else
            {
                msg = msg + ", email"
            }
        }
        if(Feedback == "")
        {
            if msg == ""
            {
                msg = msg + "feedback"
            }
            else
            {
                msg = msg + " and feedback"
            }
        }
        if msg != ""
        {
            msg = "Please enter valid " + msg
            let errorMessageShow : UIAlertView = UIAlertView(title: "Error", message: msg, delegate: nil, cancelButtonTitle: "Ok")
            errorMessageShow.show()
        }
        else
        {
            serviceCall()
        }
    }
    @IBAction func Reset(_ sender: Any) {
        
        txtName.text = ""
        txtMobileNo.text = ""
        txtEmail.text = ""
        txtFeedback.text = ""
        txtName.becomeFirstResponder()
        
    }
    
    //************************** API call *******************************
    
    func serviceCall()
    {
        if(GlobalData.isInternetAvailable())
        {
            GlobalData.displayActivityIndicator(view: self.view, msg: "Loading...")
            let dic: [String: AnyObject] = [
                "AppName" : "Documents" as AnyObject,
                "VersionNo" : "1.0" as AnyObject,
                "Platform" : "IOS" as AnyObject,
                "PersonName" : txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "Mobile" : txtMobileNo.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "Email" : txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "Message" : txtFeedback.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
                
            ]
            var tempUrl = NSString(format: "http://api.aswdc.in/Api/MST_AppVersions/PostAppFeedback/AppPostFeedback" as NSString)
            //tempUrl = tempUrl.replacingOccurrences(of: " ", with: "%20") as NSString
            self.request = HttpWrapper.init()
            self.request.delegate = self as! HttpWrapperDelegate;
            self.request.requestWithparamdictParamPostMethod(tempUrl as String, dicsParams: dic)
        }
        else
        {
//            GlobalData.showMessage(self1: self, message: "Please check your internet connection.")
            let showMessage = UIAlertController(title: "", message: "Please check your internet connection.", preferredStyle: UIAlertController.Style.alert)
            showMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
            self.present(showMessage, animated: true, completion: nil)
        }
    }
    
    func HttpWrapperfetchDataSuccess(_ wrapper: HttpWrapper, dicsResponse: NSDictionary) {
        
        GlobalData.hideActivityIndicator(view: self.view)
        print(dicsResponse)
        if(String(describing: dicsResponse.value(forKey: "IsResult")!) == "1")
        {
            let showMessage = UIAlertController(title: "", message: "Feedback sent successfully.", preferredStyle: UIAlertController.Style.alert)
            showMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
            self.present(showMessage, animated: true, completion: nil)
        }
        else {
            let errorMessageShow : UIAlertView = UIAlertView(title: "Documents", message: "Please try again later.", delegate: nil, cancelButtonTitle: "Ok")
            errorMessageShow.show()
        }
    }
    
    func HttpWrapperfetchDataFail(_ wrapper: HttpWrapper, error: NSError) {
        let errorMessageShow : UIAlertView = UIAlertView(title: "Documents", message: "Please try again later.", delegate: nil, cancelButtonTitle: "Ok")
        errorMessageShow.show()
        GlobalData.hideActivityIndicator(view: self.view)
    }
}
