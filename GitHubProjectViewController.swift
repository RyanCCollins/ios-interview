import UIKit

class GitHubProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // project UI
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completionPercentage: UILabel!
    @IBOutlet weak var openIssues: UILabel!
    @IBOutlet weak var closedIssues: UILabel!
    @IBOutlet weak var allIssuesTable: UITableView!
    @IBOutlet weak var contributorsCollection: UICollectionView!
    
    // new issue UI
    
    @IBOutlet weak var newIssueName: UITextField!
    @IBOutlet weak var newIssueDescription: UITextView!
    @IBOutlet weak var postNewIssueButton: UIButton!
    
    // data model
    // We will be using our Model classes, so we don't need seperate variables anymore :)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCallsToGithubAPI()
        
        allIssuesTable.delegate = self
        allIssuesTable.dataSource = self
        
        contributorsCollection.delegate = self
        contributorsCollection.dataSource = self
        
        newIssueName.hidden = true
        newIssueDescription.hidden = true
        postNewIssueButton.hidden = true
    }
    
    func makeCallsToGithubAPI() {
        // All of the network calls happen in the github API and we can access them through the API Singleton
    }
    
    
    @IBAction func newIssueButtonPressed(sender: AnyObject) {
        newIssueName.hidden = false
        newIssueDescription.hidden = false
        postNewIssueButton.hidden = false
    }
    
    @IBAction func postNewIssueButtonPressed(sender: AnyObject) {
        postNewIssue()
        //Update the UI here
    }
    
    func postNewIssue() {
        GitHubAPI.postNewIssue(success, error in {
            if error != nil {
                // Handle the error
            } else {
                //update the UI
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IssueCell") as! IssueCell
        // [code that stylizes the cell]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // The comments and other data are being loaded by the GitHubAPI class, so we can access them via the Singleton
        // [code that pushes a new view controller with comment data]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contributors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = contributorsCollection.dequeueReusableCellWithReuseIdentifier("ContributorCell", forIndexPath: indexPath) as! ContributorCell
        // [code that stylizes the cell]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        // The code for the network Query happens in the GitHubAPI and we can access the model objects when needed.
        // [code that pushes a new view controller with contributor data]
    }
}

import CoreData

@objc(Project)

class Project {
    @NSManaged var name: NSString
    @NSManaged var completionPercentage: NSNumber
    @NSManaged var issues: [Issue]?
    @NSManaged var contributors: [Contributor]?
    
    /* Mandatory override of init for inserting into ManageObjectContext */
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    /* Our keys will let us get the stored data.  Issues and contributors stored seperately and accessed with NSPredicate 1 -> M */
    struct Keys {
        static let name = "name"
        static let completionPercentage = "completionPercentage"
        static let issues = "issues"
        static let contributors = "contributors"
    }

    /* Custom init */
    init(dictionary: [String: AnyObject?], context: NSManagedObjectContext) {
        
        /* Get associated entity from our context */
        let entity = NSEntityDescription.entityForName("Project", inManagedObjectContext: context)!
        
        /* Super, get to work! */
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        /* Assign our properties */
        name = dictionary[Keys.name] as! NSString
        completionPercentage = dictionary[Keys.completionPercentage] as! NSNumber
        
    }
    
    /* Other various model methods here for storing the data fetched */
    
}

class Issue {
    /* Standard CoreData ManageObject methods and properties */
}

class Contributor {
     /* Standard CoreData ManageObject methods and properties */
}

class GitHubAPI {
    
    typealias CompletionHandler = (result: AnyObject!, error: NSError?) -> Void
    
    /* This class is responsible for making the API network calls to Github and returns callbacks with the results.  */
    func taskForGETMethod(var urlString: String, parameters: [String : AnyObject]?, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        /* Make parameters for the network call
         * Create a session and task.
         * Check our status code
         * Proceed with Parsing the JSON
         * Return the task
        */
        /* GUARD: For a successful status respose*/
        
    }
    
    func taskForPostMethod(var urlString: String, parameters: [String : AnyObject]?, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        /* Make parameters for the network call
        * Create a session and task.
        * Check our status code
        * Proceed with Parsing the JSON
        * Return the task
        */
        /* GUARD: For a successful status respose*/
    }
    
    class func parseJSONDataWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        //Parse JSON and return it via the completion handler
    }
    

}

class GitHubAPI {
    //Convenience methods for getting data from the GithubAPI
}


