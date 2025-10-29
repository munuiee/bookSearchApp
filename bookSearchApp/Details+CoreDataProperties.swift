//
//  Details+CoreDataProperties.swift
//  bookSearchApp
//
//  Created by jyeee on 10/29/25.
//
//

public import Foundation
public import CoreData


public typealias DetailsCoreDataPropertiesSet = NSSet

extension Details {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Details> {
        return NSFetchRequest<Details>(entityName: "Details")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var price: String?

}

extension Details : Identifiable {

}
