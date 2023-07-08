
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var cityList = [City]()
    
    @IBOutlet weak var citytableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCities()
        citytableView.dataSource = self
        citytableView.delegate = self
    }
    
    func initCities() {
        let pristina = City(id: "1", name: "Pristina", imageName: "prishtina.jpg", info: "Pristina is the capital and largest city of Kosovo. It is a vibrant city with a rich history and diverse cultural scene. The city is home to numerous historical landmarks, such as the Kosovo National Library and the Mother Teresa Cathedral. Pristina also offers a thriving nightlife, with a variety of restaurants, cafes, and clubs for visitors to enjoy.")

        let prizren = City(id: "2", name: "Prizren", imageName: "prizren.jpg", info: "Prizren is a historic city in Kosovo known for its well-preserved Ottoman architecture. It is often referred to as the cultural capital of Kosovo due to its numerous cultural and historical sites. Prizren is home to the beautiful Prizren Castle, the Sinan Pasha Mosque, and the League of Prizren Complex. Visitors can explore the narrow streets of the Old Town, visit local artisan shops, and indulge in traditional cuisine.")

        let gjilan = City(id: "3", name: "Gjilan", imageName: "gjilan.jpg", info: "Gjilan is a city in eastern Kosovo with a rich cultural heritage. The city offers a blend of traditional and modern attractions. Visitors can explore the Gjilan Castle, which dates back to the Ottoman period, and visit the Albanian League Museum to learn about the region's history. Gjilan also hosts various cultural events and festivals throughout the year, showcasing local music, dance, and crafts.")

        let mitrovica = City(id: "4", name: "Mitrovica", imageName: "mitrovica.jpg", info: "Mitrovica is a city divided between ethnic Albanians and Serbs, symbolizing the complex political situation in Kosovo. Despite the division, Mitrovica has a rich cultural scene and offers a range of activities for visitors. The city is home to the Ibar Bridge, a historic landmark that connects the northern and southern parts of the city. Mitrovica also features several parks, cafes, and restaurants where visitors can relax and enjoy the local atmosphere.")

        let ferizaj = City(id: "5", name: "Ferizaj", imageName: "ferizaj.jpg", info: "Ferizaj is an industrial city in Kosovo, known for its economic development. The city has undergone significant growth in recent years and offers a mix of modern amenities and cultural attractions. Visitors can explore the Ferizaj Ethnographic Museum, which showcases the region's traditional crafts and artifacts. The city also boasts a vibrant market, where visitors can find local produce, handmade goods, and traditional food.")

        cityList = [pristina, prizren, gjilan, mitrovica, ferizaj]
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCellID", for: indexPath) as! TableViewCell
        let thisCity = cityList[indexPath.row]
        
        tableViewCell.cityName.text = thisCity.name
        tableViewCell.cityImage.image = UIImage(named: thisCity.imageName)
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue"){
            
            let indexPath = self.citytableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? TableViewDetail
            
            let selectedCity = cityList[indexPath.row]
            
            tableViewDetail!.selectedCity = selectedCity
            
            self.citytableView.deselectRow(at: indexPath, animated: true)
        }    }
}
