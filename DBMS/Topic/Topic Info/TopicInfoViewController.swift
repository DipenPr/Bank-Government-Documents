import UIKit

class TopicInfoViewController: UIViewController, UIWebViewDelegate, UIDocumentInteractionControllerDelegate {
    @IBOutlet weak var wvTopicInfo: UIWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var topic = Topic()
    var TopicID = Int32()
    var TopicName = String()
    var css = "NewCSS.txt"
    var htmlTopicInfo = String()
    var fav = UIBarItem()
    var unFav = UIBarItem()
    var share = UIBarItem()
    var csshtml = String()
    var docController : UIDocumentInteractionController!
    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dh : DatabaseHelper = DatabaseHelper()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        self.navigationItem.title = TopicName
        topic = dh.getTopicInfo(TopicID: TopicID)

        let bundle = Bundle.main
        let path = bundle.path(forResource: "NewCSS", ofType: "txt")
        let content = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        htmlTopicInfo = topic.TopicWEB
        TopicID = topic.TopicID
        csshtml = content! + htmlTopicInfo
        wvTopicInfo.loadHTMLString(csshtml, baseURL: nil)
        
        share = UIBarButtonItem.init(title: "Share", style: .done, target: self, action: #selector(sharePDF(sender: )))
        
        let unFavImage = UIImage(named: "star.png")?.withRenderingMode(.alwaysOriginal)
        unFav = UIBarButtonItem.init(image: unFavImage, style: .done, target: self, action: #selector(Favourite(sender:)))
        let favImage = UIImage(named: "star_solid.png")?.withRenderingMode(.alwaysOriginal)
        fav = UIBarButtonItem.init(image: favImage, style: .done, target: self, action: #selector(Favourite(sender:)))
        
        if (topic.isFavorite == 0)
        {
            self.navigationItem.rightBarButtonItems = [share , unFav] as? [UIBarButtonItem]
        }
        else
        {
            self.navigationItem.rightBarButtonItems = [share , fav] as? [UIBarButtonItem]
        }
        
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let colors = [#colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.2509803922, blue: 0.2196078431, alpha: 1)]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    @objc func sharePDF(sender: UIButton) {
        
        docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("\(topic.TopicName.trimmingCharacters(in: .whitespacesAndNewlines)).pdf")
        convertHtmlToPdf(withHtmlData: topic)
        self.docController = UIDocumentInteractionController.init(url: docURL)
        self.docController.delegate = self
        self.docController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!
    }
    func convertHtmlToPdf(withHtmlData data : Topic) {
        
        let htmlData = "<html><body style=\"font-family: Arial, Helvetica, sans-serif;\"><center><h1 style=\"font-family: Arial, Helvetica, sans-serif; font-size: 40px;\">\(topic.TopicName)</h1></center><h3 style=\"font-size: 35px; font-weight: 100; text-align: justify;\">\(csshtml)</h3></body></html>"
        
        let fmt = UIMarkupTextPrintFormatter(markupText: htmlData)
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        let  page = CGRect(x: 40, y: 0, width: 580, height: 841.8)
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")
        render.headerHeight = 10
        render.footerHeight = 70
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 0..<render.numberOfPages {
            
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        pdfData.write(to: docURL as URL, atomically: true)
    }
    
    @objc func Favourite(sender : Any) {
        
        AddRemoveFavorite()
    }
    
    func AddRemoveFavorite()
    {
        let dh : DatabaseHelper = DatabaseHelper()
        topic = dh.getTopicInfo(TopicID: TopicID)
        
        if (topic.isFavorite == 0)
        {
            let insertFlag : Bool = dh.addToFavourites(topicID: TopicID)
            self.navigationItem.rightBarButtonItems = [share , fav] as? [UIBarButtonItem]
            if(insertFlag == true)
            {
                let successMsg = UIAlertController(title: "Topic", message: "Topic added to favourite", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                successMsg.addAction(defaultAction)
                self.present(successMsg, animated: true, completion: nil)
                
            }
            else
            {
                let successMsg = UIAlertController(title: "Topic", message: "Topic not added.", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                successMsg.addAction(defaultAction)
                self.present(successMsg, animated: true, completion: nil)
            }
        }
        else
        {
            let insertFlag : Bool = dh.removeFromFavourites(topicID: TopicID)
            self.navigationItem.rightBarButtonItems = [share , unFav] as? [UIBarButtonItem]
            if(insertFlag == true)
            {
                let successMsg = UIAlertController(title: "Topic", message: "Topic removed from favorite", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)})
                successMsg.addAction(defaultAction)
                self.present(successMsg, animated: true, completion: nil)
                
            }
            else
            {
                let successMsg = UIAlertController(title: "Topic", message: "Topic not removed.", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                successMsg.addAction(defaultAction)
                self.present(successMsg, animated: true, completion: nil)
            }
        }
    }

}
