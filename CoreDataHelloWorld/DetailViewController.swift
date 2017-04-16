import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    func configureView() {
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        guard let context = detailItem?.managedObjectContext else { return }
        let ev = Event(context: context)
        ev.timestamp = NSDate()
        
        do { 
            try context.save()
        } catch {
            print("Error saving context")
        }
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

