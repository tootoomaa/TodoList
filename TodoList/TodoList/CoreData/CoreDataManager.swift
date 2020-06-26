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
  
  
  func fetchTodoList(ascending: Bool = false) -> [TodoList] {
    var models: [TodoList] = [TodoList]()
    
    if let context = context {
      let idSort: NSSortDescriptor = NSSortDescriptor(key: "createTime", ascending: ascending)
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
  
  func saveTodoItem(createTime: Int, title: String, kinds:String, onSuccess: @escaping ((Bool) -> Void)) {
    if let context = context,
      let entity: NSEntityDescription
      = NSEntityDescription.entity(forEntityName: modelName, in: context) {
      
      if let todoList: TodoList = NSManagedObject(entity: entity, insertInto: context) as? TodoList {
        todoList.createTime = createTime
        todoList.title = title
        todoList.kinds = kinds
        todoList.complete = false
        
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
  
  func deleteTodoList(createTime: Int, onSuccess: @escaping ((Bool) -> Void)) {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(createTime: createTime)
    
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
      let index: NSSortDescriptor = NSSortDescriptor(key: "createTime", ascending: true)
      
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
  
  func changetodoItemData(createTime: Int, title:String? = nil ,onSuccess: @escaping ((Bool) -> Void)) {
    var todoList = [TodoList]()
    
    if let context = context {
      let sortOprion: NSSortDescriptor = NSSortDescriptor(key: "createTime", ascending: true)
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
      
      fetchRequest.predicate = NSPredicate(format: "createTime = %@", NSNumber(value: createTime))
      fetchRequest.sortDescriptors = [sortOprion]
      
      do {
        if let fetchResult: [TodoList] = try context.fetch(fetchRequest) as? [TodoList] {
          todoList = fetchResult
        }
      }catch let error as NSError {
        print("Cound not Fetch todoItem from Database : \(error), \(error.userInfo)")
      }
      
      if let todoItem:TodoList = todoList[0] {
        todoItem.createTime = createTime
        if let title = title {
            todoItem.title = title
        }
      }
    }
    contextSave { success in
      onSuccess(success)
    }
  }
  
  // ThirdVC 에서 컬렉션 뷰의 아이탬의 위치를 변경할때 처리하는 함수
  func changeValueMovedItems(todoList:[TodoList] ,sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
    // 디비 데이터 삭제를 위한 임시값 생성
    
    let sourceCreateTime = todoList[sourceIndexPath.item].createTime
    let destCreateTime = todoList[destinationIndexPath.item].createTime
    
    var destIndex:Int = 0
    var sourceIndex:Int = 0
    for index in 0..<originDataArray.count {
      if originDataArray[index].createTime == destCreateTime {
        destIndex = index
      } else if originDataArray[index].createTime == sourceCreateTime {
        sourceIndex = index
      }
    }
    // 실제 디비 변경
    originDataArray[destIndex].createTime = sourceCreateTime
    originDataArray[sourceIndex].createTime = destCreateTime
    
    // 변경 사항 저장
    CoreDataManager.shared.savedAllTodoList {  (onSuccess) in
      onSuccess ? print("Save All Data Success") : print("Fail to Save All Data in ThirdVC") }
    
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
  fileprivate func filteredRequest(createTime: Int) -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult>
      = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    fetchRequest.predicate = NSPredicate(format: " createTime = %@", NSNumber(value: createTime))
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
