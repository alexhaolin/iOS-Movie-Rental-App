//
//  Reminder+CoreDataProperties.swift
//  Final
//
//  Created by Alex on 4/26/19.
//  Copyright © 2019 Alex. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var remIdea: String?
    @NSManaged public var remTitle: String?

}
