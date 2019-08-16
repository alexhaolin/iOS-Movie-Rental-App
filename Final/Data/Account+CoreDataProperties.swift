//
//  Account+CoreDataProperties.swift
//  Final
//
//  Created by Alex on 4/26/19.
//  Copyright © 2019 Alex. All rights reserved.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var headImage: NSData?

}
