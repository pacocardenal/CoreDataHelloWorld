import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    let coreDataManager = CoreDataManager()
    var context: NSManagedObjectContext?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self

        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        
        let persistentContainer: NSPersistentContainer = self.coreDataManager.persistentContainer(dbName: "CoreDataHelloWorld")
        self.context = persistentContainer.viewContext
        
        controller.managedObjectContext = self.context
        
        testZone()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.coreDataManager.saveContext(context: self.context!)
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            return true
        }
        return false
    }
    
    func testZone() {
        
        guard let context = self.context else { return }
        
        // Add objects
        let event1 = Event(context: context)
        event1.timestamp = NSDate()
        
        let event2 = Event(context: context)
        event2.timestamp = NSDate()
        
        let paco = Person(context: context)
        paco.name = "Paco"
        paco.address = "Los Sauces"
        
        let manolo = Person(context: context, name: "Manolo")
        
        // Insert pending objects
        print("🍎 \(context.insertedObjects.count)")
        
        self.coreDataManager.saveContext(context: context)
        
        // Delete objects
        context.delete(manolo)
        print("🍋 \(manolo.isDeleted)")
        self.coreDataManager.saveContext(context: context)
        
        // Fetch objects
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
          
        fetchRequest.fetchBatchSize = 10
        
        let orderByName = NSSortDescriptor(key: "name", ascending: true)
        let orderByAddress = NSSortDescriptor(key: "address", ascending: true)
        fetchRequest.sortDescriptors = [orderByName, orderByAddress]
        
        do {
            let result = try context.fetch(fetchRequest)
            print("Num records \(result.count)")
            
            for person in result {
                print("Name \(person.name), address \(person.address)")
            }
        } catch {
            print("Error in fetch")
        }
        
    }

}

