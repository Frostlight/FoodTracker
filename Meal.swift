//
//  Meal.swift
//  FoodTracker
//
//  Created by Vincent on 8/30/17.
//
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    // MARK: - Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    // MARK: - Archive Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    // MARK: - Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        // Fails when name is empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Fails when rating is outside bounds
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode name for meal object.", log: OSLog.default, type: .debug)
            }
            return nil
        }
        
        // Conditional cast for photo since the property is optional
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Call designated initailizer
        self.init(name: name, photo: photo, rating: rating)
    }
}
