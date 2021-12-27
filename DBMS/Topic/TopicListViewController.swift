import UIKit

public extension UIImage {
    public convenience init?(color : UIColor, size : CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

class TopicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchTopic: UISearchBar!
    @IBOutlet weak var tblTopics: UITableView!
    
    var Topics = NSMutableArray()
    var TopicID = Int32()
    var TopicName = String()
    var CategoryID = Int32()
    var CategoryName = String()
    var FilteredArray = NSMutableArray()
    var isFilter = 0
    var fromScreen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dh : DatabaseHelper = DatabaseHelper()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if(fromScreen == "FAV")
        {
            self.navigationItem.title = "Favourites"
            Topics = dh.getFavouriteTopics()
        }
        else
        {
            self.navigationItem.title = CategoryName
            Topics = dh.getTopicsList(CategoryID: CategoryID)
        }
        
        let imageSize = CGSize(width: 1, height: 1)
        let backgroundImage = UIImage(color: #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), size: imageSize)
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        let shadowImage = UIImage(color: #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), size: imageSize)
        self.navigationController?.navigationBar.shadowImage = shadowImage
        
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }

    override func viewWillAppear(_ animated: Bool) {
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        let dh : DatabaseHelper = DatabaseHelper()
        if(fromScreen == "FAV")
        {
            self.navigationItem.title = "Favourites"
            Topics = dh.getFavouriteTopics()
        }
        else
        {
            self.navigationItem.title = CategoryName
            Topics = dh.getTopicsList(CategoryID: CategoryID)
        }
        tblTopics.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isFilter == 1)
        {
            return FilteredArray.count;
        }
        else
        {
            return Topics.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TopicListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! TopicListTableViewCell
        
        var t : Topic = Topic()
        if (isFilter == 1)
        {
            t = FilteredArray.object(at: indexPath.row) as! Topic
        }
        else
        {
            t = Topics.object(at: indexPath.row) as! Topic
        }
        cell.lblTopicNumber.text = "\(indexPath.row + 1)"
        cell.lblTopicName.text = t.TopicName;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var t : Topic = Topic()
        if(isFilter == 1)
        {
            t = FilteredArray.object(at: indexPath.row) as! Topic
        }
        else
        {
            t = Topics.object(at: indexPath.row) as! Topic
        }
        
        let tivc : TopicInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "TopicInfoViewController") as!
        TopicInfoViewController
        
        tivc.TopicID = t.TopicID
        tivc.TopicName = t.TopicName
        searchTopic.resignFirstResponder()
        searchTopic.setShowsCancelButton(false, animated: false)
        self.navigationController?.pushViewController(tivc, animated: true)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchTopic.showsCancelButton = true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchTopic.showsCancelButton = false;
        self.searchTopic.resignFirstResponder();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText != ""){
            isFilter = 1
            FilteredArray.removeAllObjects()
            for i in 0 ..< Topics.count
            {
                let t = Topics.object(at: i) as! Topic
                
                if(t.TopicName.uppercased().range(of: searchText.uppercased()) != nil)
                {
                    FilteredArray.add(t)
                }
            }
        }
        else
        {
            isFilter = 0
        }
        
        self.tblTopics.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
