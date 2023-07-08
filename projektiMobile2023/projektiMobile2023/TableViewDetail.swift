import Foundation
import UIKit

class TableViewDetail: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var info: UITextView!
    
    var selectedCity: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = selectedCity.name
        image.image = UIImage(named: selectedCity.imageName)
        info.text=selectedCity.info
        
        
        // Set image view properties
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
    
    }
}
