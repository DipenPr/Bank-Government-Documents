import UIKit

extension CAGradientLayer
{
    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custion(point: CGPoint)
        
        var point: CGPoint {
            switch self {
            case .topRight: return CGPoint(x: 1, y: 0)
            case .topLeft: return CGPoint(x: 0, y: 0)
            case .bottomRight: return CGPoint(x: 1, y: 1)
            case .bottomLeft: return CGPoint(x: 0, y: 1)
            case .custion(let point): return point
            }
        }
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: Point, endPoint: Point) {
        self.init(frame: frame, colors: colors, startPoint: startPoint.point, endPoint: endPoint.point)
    }
    
    func createGradientImage() -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension UINavigationBar
{
    func setGradientBackground(colors: [UIColor], startPoint: CAGradientLayer.Point = .topLeft, endPoint: CAGradientLayer.Point = .bottomLeft) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, startPoint: startPoint, endPoint: endPoint)
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, HttpWrapperDelegate {

    @IBOutlet weak var searchCategory: UISearchBar!
    @IBOutlet weak var tblCategory: UITableView!
    
    var Categories = NSMutableArray()
    var CategoryID = Int32()
    var CategoryName = String()
    var FilteredArray = NSMutableArray()
    var isFilter = 0
    
    var request : HttpWrapper = HttpWrapper()
    var list : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dh : DatabaseHelper = DatabaseHelper()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        self.navigationItem.title = "Documents"
        Categories = dh.getCategories()
        
        let imageSize = CGSize(width: 1, height: 1)
        let backgroundImage = UIImage(color: #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), size: imageSize)
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        let shadowImage = UIImage(color: #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), size: imageSize)
        self.navigationController?.navigationBar.shadowImage = shadowImage
        
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        searchCategory.barTintColor = #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)
        
        serviceCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        searchCategory.barTintColor = #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isFilter == 1) {
            return FilteredArray.count;
        }
        else {
            return Categories.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! CategoryTableViewCell
        
        var c : Category = Category()
        if (isFilter == 1)
        {
            c = FilteredArray.object(at: indexPath.row) as! Category
        }
        else
        {
            c = Categories.object(at: indexPath.row) as! Category
        }
        cell.lblCategoryNumber.text = "\(indexPath.row + 1)"
        cell.lblCategoryName.text = c.CategoryName;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        var c : Category = Category()
        if(isFilter == 1)
        {
            c = FilteredArray.object(at: indexPath.row) as! Category
        }
        else
        {
            c = Categories.object(at: indexPath.row) as! Category
        }
        
        let tlvc : TopicListViewController = self.storyboard?.instantiateViewController(withIdentifier: "TopicListViewController") as!
        TopicListViewController
        tlvc.CategoryID = c.CategoryID
        tlvc.CategoryName = c.CategoryName
        searchCategory.resignFirstResponder()
        searchCategory.setShowsCancelButton(false, animated: false)
        self.navigationController?.pushViewController(tlvc, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchCategory.showsCancelButton = true;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchCategory.showsCancelButton = false;
        self.searchCategory.resignFirstResponder();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText != ""){
            isFilter = 1
            FilteredArray.removeAllObjects()
            for i in 0 ..< Categories.count
            {
                let c = Categories.object(at: i) as! Category
                
                if(c.CategoryName.uppercased().range(of: searchText.uppercased()) != nil)
                {
                    FilteredArray.add(c)
                }
            }
        }
        else
        {
            isFilter = 0
        }
        
        self.tblCategory.reloadData()
    }
    @IBAction func showMenu(_ sender: Any)
    {
        //**********
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Favorite", style: .default, handler: {(UIAlertAction)in
            
            let tlvc : TopicListViewController = self.storyboard?.instantiateViewController(withIdentifier: "TopicListViewController") as! TopicListViewController
            tlvc.fromScreen = "FAV"
            self.navigationController?.pushViewController(tlvc, animated: true)
        }))
        
    
        //**********
        alert.addAction(UIAlertAction(title: "Feedback", style: .default, handler: {(UIAlertAction)in
            
            let fbvc : FeedbackViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.navigationController?.pushViewController(fbvc, animated: true)
        }))
        
        //**********
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: {(UIAlertAction)in
            
            let objectsToShare = [Utility.shareMsg]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }))
        
        //**********
        alert.addAction(UIAlertAction(title: "About Us", style: .default, handler: {(UIAlertAction)in
            
            let dvc : DeveloperViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeveloperViewController") as! DeveloperViewController
            self.navigationController?.pushViewController(dvc, animated: true)
        }))
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        })
        cancelAlert.setValue(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    //************************* API Call *********************************
    
    func serviceCall()
    {
        if(GlobalData.isInternetAvailable())
        {
            GlobalData.displayActivityIndicator(view: self.view, msg: "Loading...")
            let dic: [String: AnyObject] = [:]
            let tempUrl = NSString(format: "http://api.aswdc.in/Api/MST_AppVersions/GetAppDetailByAppNameSystem/Documents" as NSString)
            //tempUrl = tempUrl.replacingOccurrences(of: " ", with: "%20") as NSString
            self.request = HttpWrapper.init()
            self.request.delegate = self as HttpWrapperDelegate;
            self.request.requestWithparamdictParamGetDict(tempUrl as String, dicsParams: dic)
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
        if(dicsResponse.value(forKey: "IsResult") as? Int ?? 0 == 1)
        {
            let appDetails : [AnyObject] = ( dicsResponse.value(forKey: "ResultList")! as! [AnyObject])
            let iPhoneVersion : Int = appDetails[0]["iPhoneVersion"] as? Int ?? 0
            let iPhoneVersionSoft: Int = appDetails[0]["iPhoneVersionSoft"] as? Int ?? 0
            let iPhoneRemarks : String = appDetails[0]["iPhoneRemarks"] as? String ?? ""
            let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
            let version:Int = Int(Double(nsObject as! String)!)
            if(version < iPhoneVersion )
            {
                let alert = UIAlertController(title: "New Version of the App is available. Please update the app.", message:"", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.view.isUserInteractionEnabled = false
                    UIApplication.shared.openURL(URL(string:"http://tiny.cc/iDocuments")!)
                }))

                self.present(alert, animated: true, completion: nil)
            }
            else if(version < iPhoneVersionSoft)
            {

                let alert = UIAlertController(title: "New Version of the App is available. Please update the app.", message:iPhoneRemarks, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction!) in
                    UIApplication.shared.openURL(URL(string:"http://tiny.cc/iDocuments")!)
                }))

                alert.addAction(UIAlertAction(title: "Skip", style: .default, handler: { (action: UIAlertAction!) in

                }))

                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    func HttpWrapperfetchDataFail(_ wrapper: HttpWrapper, error: NSError) {
        let errorMessageShow : UIAlertView = UIAlertView(title: "Documents", message: "Please try again later.", delegate: nil, cancelButtonTitle: "Ok")
        errorMessageShow.show()
        GlobalData.hideActivityIndicator(view: self.view)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
