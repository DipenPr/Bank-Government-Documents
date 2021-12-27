import UIKit

class Utility: NSObject {

    static let dbName : String = "DBMS.db"
    static let shareMsg : String = "Want to issue bank and government related documents but don't know what is required try this app Documents is a must have for quick referral! Use the below link to get it on your phone.\nAvailable on \nApp Store: http://tiny.cc/iDocuments"
    
    class func getPath(_ fileName: String) -> String
    {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    class func copyFile(_ fileName: NSString) {
        let dbPath: String = getPath(fileName as String) //Destination path of DB file
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)   //Source path of DB file
            
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            if (error != nil) {
                print("Error Occured")
                //alert.message = error?.localizedDescription
            } else {
                print("Successfully Copy")
            }
        }
    }
}
