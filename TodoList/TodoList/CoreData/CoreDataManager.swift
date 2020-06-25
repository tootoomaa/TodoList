//
//  CoreDataManager.Swif.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/23.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
  static let shared: CoreDataManager = CoreDataManager()
  
  let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
  lazy var context = appDelegate?.persistentContrainer.viewContext
  
  let modelName: String = "TodoList"
  
  func getUsers(ascending: Bool = false) -> [TodoList] {
    var models: [TodoList] = [TodoList]()
    
    if let context = context {
      let idSort: NSSortDescriptor = NSSortDescriptor(key: "index", ascending: ascending)
      let fetchRequest: NSFetchRequest<NSManagedObject>
        = NSFetchRequest<NSManagedObject>(entityName: modelName)
      fetchRequest.sortDescriptors = [idSort]
      
      do {
        if let fetchResult: [TodoList] = try context.fetch(fetchRequest) as? [TodoList] {
          models = fetchResult
        }
      } catch let error as NSError {
        print("Could not fetch🥺: \(error), \(error.userInfo)")
      }
    }
    return models
  }
  
  func saveUser(index: Int, title: String, kinds:String, alramTime:String, complete:Bool, onSuccess: @escaping ((Bool) -> Void)) {
    if let context = context,
      let entity: NSEntityDescription
      = NSEntityDescription.entity(forEntityName: modelName, in: context) {
      
      if let todoList: TodoList = NSManagedObject(entity: entity, insertInto: context) as? TodoList {
        todoList.index = index
        todoList.title = title
        todoList.kinds = kinds
        todoList.alarmTime = alramTime
        todoList.complete = complete
        
        contextSave { success in
          onSuccess(success)
        }
      }
    }
  }
  
  func savedAllTodoList(onSuccess: @escaping ((Bool) -> Void)) {
    if let context = context,
      let entity: NSEntityDescription
      = NSEntityDescription.entity(forEntityName: modelName, in: context) {
      
      contextSave { success in
        onSuccess(success)
      }
    }
  }
  
  func deleteUser(index: Int, onSuccess: @escaping ((Bool) -> Void)) {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(index: index)
    
    do {
      if let results: [TodoList] = try context?.fetch(fetchRequest) as? [TodoList] {
        if results.count != 0 {
          context?.delete(results[0])
        }
      }
    } catch let error as NSError {
      print("Could not fatch🥺: \(error), \(error.userInfo)")
      onSuccess(false)
    }
    
    contextSave { success in
      onSuccess(success)
    }
  }
  
  func fetchKindsTodoList(kinds: String) -> [TodoList] {
    var todoList = [TodoList]()
    
    if let context = context {
      let index: NSSortDescriptor = NSSortDescriptor(key: "index", ascending: true)
      
      let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
      
      fetchRequest.predicate = NSPredicate(format: " kinds = %@", NSString(string: kinds))
      
      fetchRequest.sortDescriptors = [index]
      
      do {
        if let fetchResult: [TodoList] = try context.fetch(fetchRequest) as? [TodoList] {
          todoList = fetchResult
        }
      } catch let error as NSError {
        print("Could not fetch🥺: \(error), \(error.userInfo)")
      }
    }
    
    return todoList
  }
  
  func changeSaveData(onSuccess: @escaping ((Bool) -> Void)) {
    if let context = context,
      let entity: NSEntityDescription
      = NSEntityDescription.entity(forEntityName: modelName, in: context) {
      contextSave { success in
        onSuccess(success)
      }
    }
  }
}

//  @discardableResult
//  func deletaAll() {
//    let request: NSFetchRequest<context> = Contact.fetchRequest()
//    let delete = NSBatchDeleteRequest(fetchRequest: request)
//    do {
//      try self.context?.execute(delete)
//      return true
//    } catch {
//      return false
//    }
//  }


extension CoreDataManager {
  fileprivate func filteredRequest(index: Int) -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult>
      = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    fetchRequest.predicate = NSPredicate(format: " index = %@", NSNumber(value: index))
    return fetchRequest
  }
  
  fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
    do {
      try context?.save()
      onSuccess(true)
    } catch let error as NSError {
      print("Could not save🥶: \(error), \(error.userInfo)")
      onSuccess(false)
    }
  }
}
