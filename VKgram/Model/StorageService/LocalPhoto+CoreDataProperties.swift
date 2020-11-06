//
//  LocalPhoto+CoreDataProperties.swift
//  LoginForm
//
//  Created by Andrey on 04/10/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalPhoto> {
        return NSFetchRequest<LocalPhoto>(entityName: "LocalPhoto")
    }

    @NSManaged public var albumID: Int16
    @NSManaged public var date: Int64
    @NSManaged public var id: Int64
    @NSManaged public var ownerID: Int64
    @NSManaged public var hasTags: Bool
    @NSManaged public var height: Int16
    @NSManaged public var photo130: String
    @NSManaged public var photo604: String
    @NSManaged public var photo75: String
    @NSManaged public var photo807: String
    @NSManaged public var text: String
    @NSManaged public var width: Int16

}
