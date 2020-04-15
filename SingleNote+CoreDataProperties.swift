//
//  SingleNote+CoreDataProperties.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/4/15.
//  Copyright © 2020 Yurii. All rights reserved.
//
//

import Foundation
import CoreData


extension SingleNoteMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleNoteMO> {
        return NSFetchRequest<SingleNoteMO>(entityName: "SingleNoteMO")
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var creationTimeStamp: Date!

}
