### iOS Interview Dry Run

### __Question 1__
I have recently mastered the use of many of the more advanced features of the Swift programming language.

I find that having an understanding of the more advanced language features of Swift is extremely powerful.  As a Swift developer, you can essentially tailor the programming language to suit your needs by using such design patterns as class extensions, delegation, protocols, typealises, et. al.  This lets you focus on building your own reusable code that can be used for all of your work.

I use a great dependency manager called Cocoapods that lets me package up my components into reusable modules that I can load into any project, making me a more efficient developer.  Mastering the intricacies of the Swift programming language has changed for the better the way that I build software.

Another thing that I have learned within the past year is how to apply best practices to my work.  This has taught me to be a better developer and has prepared me to apply my knowledge to solve complex issues in a team environment.  One such example is how I document my work and how I use Git for my iOS and web development.  I now use Git to its full advantage by writing incredibly detailed commit messages, committing often and early, rebasing / squashing my commits, etc. All of this not only helps me to create better software, but it also benefits the people I work with.

### __Question 2__
Most recently, I used the CoreData and Realm data persistence frameworks.  I learned to use them the same way that I learn to use anything, by reading the documentation and by practicing using the API in sample applications.  

What I do like about CoreData is how powerful it is.  I like it because it has an incredibly powerful API for large-scale desktop and mobile applications. That said, I dislike the fact that the power comes at a large cost.  The learning curve is high and even a full understanding of the CoreData Stack and the thread safety precautions that must be taken is not always enough to build perfect software.  I realize the power of CoreData, but I think that there are better solutions for many mobile applications.

I really like the Realm persistence framework because it was built specifically for the mobile platform.  You can run your persistence model classes on multiple threads without fear of bad access or data corruption (and the obscure CoreData bugs that only NSZombies will help you to track down.)  I plan to use both frameworks when appropriate, but am very interested in using Realm for smaller applications.

### __Question 3__
I believe that the first step to writing good software is to break down the requirements and specifications in a highly detailed manner.  Once the specifications are mapped out, I would then want to structure the application's data structs and classes following the **Model View Controller** paradigm. An example architecture is shown below.

### Model
The Model classes are responsible for downloading data from the Twitter API, storing tweets, account and organization data, and persisting the data using CoreData.  There is a CoreDataStackManager class for all CoreData operations and also an ImageCache class for caching any images downloaded.

| Class                 |  Inherits From |
|-----------------------|----------------|
| Tweet                 | NSManagedObject|
| Account               | NSMangedObject |
| TwitterAPI            | NSObject       |
| Organization          | NSManageObject |
| ImageCache            | NSObject       |
| CoreDataStackManager  | N/A            |

### View
For custom views, there is a custom table view cell for showing the detail of each tweet in the feed.  To customize the UI, there is a **like** button for liking a tweet, a Twitter login button and custom views for the settings and login views. There are also other various custom UI elements, such as the action buttons within each tweet cell in the feed.

|  Class       | Parent Class   |
|--------------|----------------|
| LikeButton   | UIButton       |
| TweetTableViewCell | UITableViewCell |
| LoginButton  | UIButton       |
| SettingsView | UIView         |
| LoginView    | UIView         |

### Controller
The controller classes are responsible for controlling the UI for the various components of the app. There is a tab view for navigating between scenes from the main view, a navigation controller for drilling down to the detail of a tweet, a detail view for showing a single tweet, and a view controller for the account and organization views.

| Class                      | Parent Class          |
|----------------------------|-----------------------|
| AccountViewController      | UIViewController      |
| TweetViewController        | UIViewController      |
| AccountViewController      | UIViewController      |
| TweetViewController        | UIViewController      | 
| FeedViewController         | UITableViewController |
| OrganizationViewController | UIViewController      |
| NavigationController       | UINavigationController|
| TabBarViewController       | UITabBarController    |
| LoginViewController        | UIViewController      |
| ComposeTweetViewController | UIViewController      |
| SettingsViewController     | UIViewController      |

### Other
There are also other custom classes, such as the TransitionDelegate, PhotoAnimator, and others, which will help to build a cohesive custom UI with beautiful transition animations.


|    Class                 | Parent Class                          |
|--------------------------|---------------------------------------|
|TransitionDelegate        | UIViewControllerTransitioningDelegate |
|PhotoPresentationAnimator | UIViewControllerAnimatedTransitioning |

Although the above list is not completely exhaustive, it outlines a great start to building a fantastic Twitter app.

### __Questions 4__:
This is a great question.  Developers often forget to think about one of the most crucial aspects of building great software: performance.  I am absolutely a performance oriented developer, so I will tell you a bit about how I would go about designing and testing my UITableView to display at least 60 FPS.

First of all, Apple Engineers have put a lot of time and effort into creating a user interface library with fantastic performance.  Their method for dequeuing reusable cells is a fantastic approach.  The basic idea here is that instead of performing complex operations to create a new cell every time we need one, we simply recycle cells and other table components when they are no longer in view, update the state of the view elements with new data and reuse it. 

Apple's delegate pattern comes into focus here.  By utilizing the UITableViewDelegate and Datasource methods in an intelligent manner, we can harness the power and optimization that thousands of Apple employees have spent countless hours creating.  For example, instead of binding data to the entire table view, we use the tableView:willDisplayCell:forRowAtIndexPath method to compute changes to our the data in each cell.  

We have to be smart when using these delegate and datasource methods, because the performance of the table view depends on them.  Although the reuse pattern is fantastic, it can be costly if you perform heavy calculations from within the delegate and datasource methods.  Complex data operations need to happen on background threads.  It is also best to keep the tableview simple as far as the dimensions are concerned because the calculations for heightForRowAtIndexPath: and other related methods are done on each pass when new table view cells are created. 

I would also want to use the least computationally expensive graphics operations when considering the view drawing life cycle for any custom views rendered within the tableview cell.  This would mean avoiding heavy animations using Apple's Core Animation framework.  Instead, we can perform our view rendering with the CoreGraphics drawRect method.  The drawRect method is responsible for rendering custom static content via the CPU.  As I understand it, this frees up the GPU to handle the more complex operations that UIKit is performing for us.

To test that my theories are sound, I would use the Apple Instruments application to measure the speed at which our table view cells were rendering and I would tweak it until I got it above 60 FPS.

### __Question 5__:
If I were given this project, I would consider a few separate approaches.  If part of the requirement was to use NSUserDefaults, I would consider using the NSUserDefaults.sharedUserDefaults method because it is a singleton that automatically synchronizes the persisted data with the in memory properties.  That way, any time I need to use the data in a separate view controller, I could access any of the persisted properties in any view by just accessing the NSUserDefaults.standardUserDefaults properties.

That said, I would probably suggest a different approach. I would definitely refactor it because it does not follow the "Model View Controller" paradigm.  Why not create a seperate Model class for the Actor?  The class could be accessed through a singleton and the methods for reading and writing the data to NSUserDefaults could happen within the singleton.

Below is a bit of psuedocode for how this could be done.

```

class Actor: NSObject {
    var actorBio: String
    var actorName: String
    var actorImage: UIImage

    /* We want to create a singleton of the Actor class available from Actor.sharedInstance() */
    
    class func sharedInstance() -> Actor {
        struct singleton {
            static var sharedInstance = Actor()
        }
        return singleton.sharedInstance
    }
    
    
    func saveActor (actorBio: String, ...){
		 // Save our actor object to the NSUserDefaults.
        // and set our properties to be accessed through the Singleton
    }

}

// New we can access the properties via the 
actorNameLabel.text = Actor.sharedInstance().actorName

// And save a new Actor like so
Actor.sharedInstance().saveActor(actorBio: ...)
```

__Question 6__:
If someone I was working with gave me a file for a ViewController that contained code for fetching and storing data from a network to the local device, I would likely recommend that they take the Udacity iOS Developer Nanodegree and I would help them to understand what they could do to improve their code.

For starters, I would refactor the code into separate classes.  I would create a Model class for storing the data to a persistent store.  I would also create a separate GithubAPI model class that handled the network requests and data parsing.  By the time I was done, the code would be very well abstracted to abide by the Model View Controller paradigm, making the code much more reusable, decoupled and easier to test and debug.

I created a bit of pseudocode that I saved in the GitHubProjectViewController.swift file.

__Question 7__:
If I were to start my iOS Developer position today, my goals a year from now would be to have an even better grasp on the Swift and Objective-C languages and the Apple Frameworks.  I plan to spend the rest of my life mastering software development and I believe that the education process is a lifelong pursuit.  I would constantly be reading and talking to other developers to learn their techniques to apply best practices to all of my work.

Also, my goal would be to have a library of all of the reusable components that I use for my development so that I could be incredibly efficient.  I would combine the best of my code, along with the best of the Apple frameworks into a reusable library that would grow with me.

### Questions
Question 1 - What have you learned recently about iOS development? How did you learn it? Has it changed your approach to building apps?

Question 2 - Can you talk about a framework that you've used recently (Apple or third-party)? What did you like/dislike about the framework?

Question 3 - Describe how you would construct a Twitter feed application (here is an example of Udacity's Twitter feed) that at minimum can display a company's Twitter page. Please include information about any classes/structs that you would use in the app. Which classes/structs would be the model(s), the controller(s), and the view(s)?

Question 4 - Describe some techniques that can be used to ensure that a UITableView containing many UITableViewCell is displayed at 60 frames per second.

Question 5 - Imagine that you have been given a project that has this ActorViewController. The ActorViewController should be used to display information about an actor. However, to send information to other ViewControllers, it uses NSUserDefaults. Does this make sense to you? How would you send information from one ViewController to another one?

Question 6 - Imagine that you have been given a project that has this GithubProjectViewController. The GithubProjectViewController should be used to display high-level information about a GitHub project. However, it’s also responsible for finding out if there’s network connectivity, connecting to GitHub, parsing the responses and persisting information to disk. It is also one of the biggest classes in the project.

How might you improve the design of this view controller?

Before answering the final question, insert a job description for an iOS developer position of your choice!

Your answer for Question 7 should be targeted to the company/job-description you chose.

Question 7 - If you were to start your iOS developer position today, what would be your goals a year from now?


