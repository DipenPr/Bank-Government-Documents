import UIKit

class DatabaseHelper: NSObject {

    func getCategories() -> NSMutableArray
    {
        let Categories : NSMutableArray = NSMutableArray()
        
        let query = "select CategoryID, CategoryName from Category"
        
        let dbconn = FMDatabase(path: Utility.getPath(Utility.dbName))
        
        if (dbconn.open())
        {
            let results : FMResultSet = (dbconn.executeQuery(query, withArgumentsIn: []))!
            
            while (results.next())
            {
                let c : Category = Category()
                
                c.CategoryID = results.int(forColumn: "CategoryID")
                c.CategoryName = results.string(forColumn: "CategoryName")!
                Categories.add(c)
            }
        }
        else
        {
            print("Database not connected")
        }
        dbconn.close()
        return Categories
    }
    
    func getTopicsList(CategoryID : Int32) -> NSMutableArray
    {
        let Topics : NSMutableArray = NSMutableArray()
        
        let query = "select TopicID, TopicName, TopicWEB from Topic where CategoryID = \(CategoryID)"
        
        let dbconn = FMDatabase(path: Utility.getPath(Utility.dbName))
        
        if (dbconn.open())
        {
            let results : FMResultSet = (dbconn.executeQuery(query, withArgumentsIn: []))!
            
            while (results.next())
            {
                let t : Topic = Topic()
                
                t.TopicID = results.int(forColumn: "TopicID")
                t.TopicName = results.string(forColumn: "TopicName")!
                t.TopicWEB = results.string(forColumn: "TopicWEB")!
                Topics.add(t)
            }
        }
        else
        {
            print("Database not connected")
        }
        dbconn.close()
        return Topics
    }
    
    func getTopicInfo(TopicID : Int32) -> Topic
    {
        let topic : Topic = Topic()
        
        let query = "select TopicID, TopicName, TopicWEB, isFavorite from Topic where TopicID = \(TopicID)"
        
        let dbconn = FMDatabase(path: Utility.getPath(Utility.dbName))
        
        if (dbconn.open())
        {
            let results : FMResultSet = (dbconn.executeQuery(query, withArgumentsIn: []))!
            
            while (results.next())
            {
                topic.TopicID = results.int(forColumn: "TopicID")
                topic.TopicName = results.string(forColumn: "TopicName")!
                topic.TopicWEB = results.string(forColumn: "TopicWEB")!
                topic.isFavorite = results.int(forColumn: "isFavorite")
            }
        }
        else
        {
            print("Database not connected")
        }
        dbconn.close()
        return topic
    }
    
    func addToFavourites(topicID : Int32) -> Bool
    {
        let query = "Update Topic set isFavorite = 1 where  TopicID = \(topicID)"
        
        var insertFlag : Bool = Bool()
        let dbConn = FMDatabase(path: Utility.getPath(Utility.dbName))
        if (dbConn.open())
        {
            insertFlag = dbConn.executeUpdate(query, withArgumentsIn: [])
        }
        else
        {
            print("Database not connected")
        }
        
        dbConn.close()
        return insertFlag
    }
    
    func removeFromFavourites(topicID : Int32) -> Bool
    {
        let query = "Update Topic set isFavorite = 0 where TopicID = \(topicID)"
        
        var insertFlag : Bool = Bool()
        let dbConn = FMDatabase(path: Utility.getPath(Utility.dbName))
        if (dbConn.open())
        {
            insertFlag = dbConn.executeUpdate(query, withArgumentsIn: [])
        }
        else
        {
            print("Database not connected")
        }
        
        dbConn.close()
        return insertFlag
    }
    
    func getFavouriteTopics() -> NSMutableArray {
        let topics : NSMutableArray = NSMutableArray()
        
        let query = "select TopicID, TopicName from Topic where isFavorite = 1"
        
        let dbconn = FMDatabase(path: Utility.getPath(Utility.dbName))
        
        if (dbconn.open())
        {
            let results : FMResultSet = (dbconn.executeQuery(query, withArgumentsIn: []))!
            
            while (results.next())
            {
                let t : Topic = Topic()
                
                t.TopicID = results.int(forColumn: "TopicID")
                t.TopicName = results.string(forColumn: "TopicName")!
                topics.add(t)
            }
        }
        else
        {
            print("Database not connected")
        }
        dbconn.close()
        return topics;
    }
}
