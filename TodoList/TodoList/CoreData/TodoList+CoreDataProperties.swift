//
//  TodoList+CoreDataProperties.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/23.
//  Copyright © 2020 김광수. All rights reserved.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var createTime:Int
    @NSManaged public var title: String?
    @NSManaged public var kinds: String?
    @NSManaged public var complete: Bool

}
