//
//  tableCell.swift
//  projektiMobile2023
//
//  Created by mady on 27/06/2023.
//
import UIKit
import CoreData

class TableViewCell: UITableViewCell {
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        cityImage.layer.cornerRadius = 50 // Set the desired corner radius value
        cityImage.clipsToBounds = true
    }
}
