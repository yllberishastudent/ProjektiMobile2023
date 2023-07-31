import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cityList = [City]()
    var selectedImage: UIImage? // Variable to store the selected image
    
    @IBOutlet weak var citytableView: UITableView!
    @IBOutlet weak var cityImageView: UIImageView! // An image view in the popup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        citytableView.dataSource = self
        citytableView.delegate = self
        title = "Cities"
        configureItems()
        
        // Handle left click (tap) gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        citytableView.addGestureRecognizer(tapGesture)
        
        // Handle right-click (long press) gesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        citytableView.addGestureRecognizer(longPressGesture)
    }
    
    private var models = [CityItem]()
    
    private func configureItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
    }
    
    @objc private func didTapAdd() {
        presentAddCityAlert()
    }
    
    // Function to present the "Add City" alert
    private func presentAddCityAlert() {
        let alert = UIAlertController(title: "New City", message: "Enter new City", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "City Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "City Description"
        }
        
        // Add a button to choose an image from the gallery
        alert.addAction(UIAlertAction(title: "Choose Image", style: .default, handler: { [weak self] _ in
            self?.showImagePickerForCity()
        }))
        
        // Add a cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a submit button
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak alert] _ in
            guard let nameField = alert?.textFields?.first, let name = nameField.text, !name.isEmpty,
                  let descriptionField = alert?.textFields?.last, let description = descriptionField.text, !description.isEmpty else {
                return
            }
            
            // Check if the image has been selected
            if let selectedImage = self?.selectedImage {
                // If an image is selected, create the city with the image
                self?.createItem(name: name, description: description, image: selectedImage)
            } else {
                // If no image is selected, create the city without the image
                self?.createItem(name: name, description: description)
            }
            
            // Reset selectedImage after use
            self?.selectedImage = nil
        }))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    // Function to show the image picker for selecting an image
    private func showImagePickerForCity() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    // Implement the imagePickerController delegate method to handle the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image // Store the selected image in the 'selectedImage' variable
        }
        
        picker.dismiss(animated: true, completion: nil)
        didTapAdd()
        
    }

       
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellID", for: indexPath) as! TableViewCell
        cell.cityName.text = model.name
        
        // Check if there is image data available for the city
        if let imageData = model.image, let cityImage = UIImage(data: imageData) {
            cell.cityImage.image = cityImage
        } else {
            // Set a default image when there is no image data available
            cell.cityImage.image = UIImage(named: "defaultCityImage")
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let point = gesture.location(in: citytableView)
            if let indexPath = citytableView.indexPathForRow(at: point) {
                let selectedCity = cityList[indexPath.row]
                performSegue(withIdentifier: "detailSegue", sender: selectedCity)
            }
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: citytableView)
            if let indexPath = citytableView.indexPathForRow(at: point) {
                let selectedCity = cityList[indexPath.row]
                showContextMenu(for: selectedCity)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let selectedCity = sender as? City {
                let tableViewDetail = segue.destination as? TableViewDetail
                tableViewDetail?.selectedCity = selectedCity
                
                // Pass the description along with other information
                if let cityItem = getCityItem(for: selectedCity) {
                    tableViewDetail?.selectedCity.cityDescription = cityItem.cityDescription
                    tableViewDetail?.selectedCity.image = cityItem.image // Pass the image data
                }
            }
        }
    }

    private func showContextMenu(for city: City) {
        let alert = UIAlertController(title: "City Options", message: "Choose an action", preferredStyle: .alert)
        
        // Edit action
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] (_) in
            self?.showEditAlert(for: city)
        }))
        
        // Delete action
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (_) in
            if let cityItem = self?.getCityItem(for: city) {
                self?.deleteItem(item: cityItem)
            }
        }))
        
        // Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showEditAlert(for city: City) {
        let alert = UIAlertController(title: "Edit City", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = city.name
        }
        
        alert.addTextField { (textField) in
            textField.text = city.cityDescription
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak alert] (_) in
            if let newName = alert?.textFields?.first?.text,
               let newDescription = alert?.textFields?.last?.text {
                if let cityItem = self?.getCityItem(for: city) {
                    self?.updateItem(item: cityItem, newName: newName, newDescription: newDescription)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func getCityItem(for city: City) -> CityItem? {
        let fetchRequest: NSFetchRequest<CityItem> = CityItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", city.name)
        
        do {
            let cityItems = try context.fetch(fetchRequest)
            return cityItems.first
        } catch {
            print("Error fetching CityItem from Core Data: \(error)")
            return nil
        }
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(CityItem.fetchRequest())
            print("Cities fetched successfully:", models.map { $0.name ?? "Unnamed City" })
            
            // Update this part to pass the cityDescription and image data to City objects
            cityList = models.map {
                City(id: $0.objectID.uriRepresentation().absoluteString,
                     name: $0.name ?? "",
                     imageName: "",
                     info: $0.cityDescription ?? "",
                     image: $0.image) // Use 'image' attribute here
            }
            
            DispatchQueue.main.async {
                self.citytableView.reloadData()
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }

    // ...Existing code...

    // The createItem method with the added 'image' parameter
    // The createItem method with the added 'image' parameter
    func createItem(name: String, description: String, image: UIImage? = nil) {
        let newItem = CityItem(context: context)
        newItem.name = name
        newItem.cityDescription = description
        
        // Check if an image is available
        if let selectedImage = image {
            newItem.image = selectedImage.pngData() // Convert the UIImage to Data and save it
        } else {
            newItem.image = nil // No image selected, set to nil
        }
        
        do {
            try context.save()
            getAllItems()
            print("City saved successfully:", newItem.name)
            print("Description saved successfully:", newItem.cityDescription)
            if newItem.image != nil {
                print("Image saved successfully")
            } else {
                print("No image was selected for the city.")
            }
        } catch {
            print("Error saving data to Core Data: \(error)")
        }
    }

    // ...Rest of your existing code...

    
    func deleteItem(item: CityItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
            print("City deleted successfully:", item.name ?? "Unnamed City")
        } catch {
            print("Error deleting data from Core Data: \(error)")
        }
    }
    
    func updateItem(item: CityItem, newName: String, newDescription: String) {
        item.name = newName
        item.cityDescription = newDescription
        
        do {
            try context.save()
            getAllItems()
            print("City updated successfully:", item.name ?? "Unnamed City")
            print("Description updated successfully:", item.cityDescription ?? "No Description")
        } catch {
            print("Error updating data in Core Data: \(error)")
        }
    }
}
