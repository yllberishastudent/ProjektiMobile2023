//
//  CityItem+CoreDataProperties.swift
//  projektiMobile2023
//
//  Created by Arlind Nimani on 30.7.23.
//
//

import Foundation
import CoreData


extension CityItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityItem> {
        return NSFetchRequest<CityItem>(entityName: "CityItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var cityDescription: String?
    @NSManaged public var image: Data?
    
}

extension CityItem : Identifiable {

}
