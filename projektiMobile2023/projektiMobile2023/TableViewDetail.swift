import Foundation
import UIKit
import CoreData

class TableViewDetail: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var info: UITextView!
    
    var selectedCity: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     name.text = selectedCity.name
        if let imageData = selectedCity.image, let cityImage = UIImage(data: imageData) {
            image.image = cityImage
        } else {
            // Set a default image when there is no image data available
            image.image = UIImage(named: "defaultCityImage")
        }

        info.text=selectedCity.cityDescription
        
        // Set image view properties
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
    
    }
}
