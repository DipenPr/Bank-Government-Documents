import UIKit
import MessageUI

extension UILabel{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

class DeveloperViewController: UIViewController , MFMailComposeViewControllerDelegate {
    @IBOutlet weak var lblAppTitle: UILabel!
    @IBOutlet weak var lblASWDCDes: UILabel!
    @IBOutlet weak var lblcontactemail: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblContactwebsite: UILabel!
    @IBOutlet weak var lblshare: UILabel!
    @IBOutlet weak var lblmore: UILabel!
    @IBOutlet weak var lblrate: UILabel!
    @IBOutlet weak var lbllike: UILabel!
    @IBOutlet weak var lblcheck: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet var lblAboutAswdc: UILabel!
    @IBOutlet var lblContactUs: UILabel!
    @IBOutlet var lblMeetOurTeam: UILabel!
    @IBOutlet var viewMeetOurTeam: UIView!
    @IBOutlet var viewAboutASWDC: UIView!
    @IBOutlet var viewContactUS: UIView!
    @IBOutlet var viewshareAPP: UIView!
    @IBOutlet weak var imgaswdc: UIImageView!
    @IBOutlet weak var imgdarshan: UIImageView!
    @IBOutlet var imgeApp: UIImageView!
    @IBOutlet var lblDevelopedBy: UILabel!
    @IBOutlet var lblMentoredBy: UILabel!
    
    
    //////////////////////////
    //                      //
    // set variable Values  //
    //                      //
    //////////////////////////
    
    var AppName = "Documents"
    var AppIconName = "ICON_180.png"
    var DevelopedByString = "Dipen K. Hirpara (160540107057)"
    var MentoredByString = "Prof. Hardik Doshi"
    var TinyString = "http://tiny.cc/idocuments"
    var ShareMessage = Utility.shareMsg
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblMeetOurTeam.roundedButton()
        lblContactUs.roundedButton()
        lblAboutAswdc.roundedButton()
        
        self.viewMeetOurTeam.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)
        self.viewAboutASWDC.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)
        self.viewContactUS.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)
        self.viewshareAPP.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)
        
        self.navigationItem.title = "About Us"
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        lblAppTitle.text = "\(AppName) (v\(version))"
        imgeApp.image = UIImage(named: AppIconName)
        lblDevelopedBy.text = DevelopedByString
        lblMentoredBy.text = MentoredByString
        let htmlString  = "<html><body align=\"justify\"><font face=\"Arial\" color = \"#969696\">ASWDC is Application, Software and Website Development Center @ Darshan Engineering College run by Students and Staff of Computer Engineering Department.<br><br> Sole purpose of ASWDC is to bridge gap between university curriculum &amp; industry demands. Students learn cutting edge technologies, develop real world application &amp; experiences professional environment @ ASWDC under guidance of industry experts &amp; faculty members.</font></body></html>"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 0.001
        
        
        let attrStr = try!  NSAttributedString(data:  htmlString.data(using: String.Encoding.utf8)!,
                                               options: [.documentType: NSAttributedString.DocumentType.html,
                                                         .characterEncoding: String.Encoding.utf8.rawValue],
                                               documentAttributes: nil)
        lblASWDCDes.attributedText = attrStr
        lblcontactemail.font = UIFont(name: "fontawesome", size: 13)
        lblcontactemail.text = "\u{f0e0}"
        lblContactwebsite.font = UIFont(name: "fontawesome", size: 13)
        lblContactwebsite.text = "\u{f0ac}"
        lblContactNumber.font = UIFont(name: "fontawesome", size: 13)
        lblContactNumber.text = "\u{f095}"
        lblshare.font = UIFont(name: "fontawesome", size: 13)
        lblshare.text = "\u{f1e0}"
        lblrate.font = UIFont(name: "fontawesome", size: 13)
        lblrate.text = "\u{f006}"
        lblmore.font = UIFont(name: "fontawesome", size: 13)
        lblmore.text = "\u{f179}"
        lbllike.font = UIFont(name: "fontawesome", size: 13)
        lbllike.text = "\u{f164}"
        lblcheck.font = UIFont(name: "fontawesome", size: 13)
        lblcheck.text = "\u{f021}"
        let formatter : DateFormatter =  DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: Date())
        lblYear.text = "© \(yearString) Darshan Institute of Engineering & Technology"
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DeveloperViewController.aswdcimageTapped(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(DeveloperViewController.darshanimageTapped(_:)))
        imgaswdc.isUserInteractionEnabled = true
        imgdarshan.isUserInteractionEnabled = true
        imgaswdc.addGestureRecognizer(tap1)
        imgdarshan.addGestureRecognizer(tap2)
        
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    @objc func aswdcimageTapped(_ sender: UITapGestureRecognizer)
    {
        UIApplication.shared.openURL(URL(string:"http://aswdc.in/")!)
    }
    @objc func darshanimageTapped(_ sender: UITapGestureRecognizer)
    {
        UIApplication.shared.openURL(URL(string:"http://www.darshan.ac.in/DIET")!)
    }
    
    
    @IBAction func contactUsEmail(_ sender: UIButton) {
         UIApplication.shared.openURL(URL(string:"mailto://aswdc@darshan.ac.in")!)
    }
    
    @IBAction func ContactUswebsite(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string:"http://www.darshan.ac.in")!)
    }
    
    @IBAction func ContactUsPhone(_ sender: Any) {
        UIApplication.shared.openURL(URL(string:"telprompt://+919727747317")!)
    }
    
    
    
    
    @IBAction func actionshare(_ sender: AnyObject) {
        let textToShare = ShareMessage
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func actionRate(_ sender: AnyObject)
    {
        UIApplication.shared.openURL(URL(string:TinyString)!)
    }
    
    @IBAction func actionmore(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string:"https://itunes.apple.com/in/developer/g-sanghani/id772995906")!)
    }
    
    @IBAction func actionlike(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string:"https://www.facebook.com/DarshanInstitute.Official")!)
    }
    
    @IBAction func actionCheck(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string:TinyString)!)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
