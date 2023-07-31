import Foundation

class City {
    var id: String!
    var name: String!
    var cityDescription: String!
    var image: Data?
    
    public init(id: String!, name: String!, imageName: String!, info: String!,image: Data?) {
        self.id = id
        self.name = name
        self.cityDescription = info
        self.image = image
    }
}
