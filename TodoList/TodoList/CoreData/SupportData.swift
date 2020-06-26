//
//  SupportData.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/26.
//  Copyright © 2020 김광수. All rights reserved.
//

import Foundation
import UIKit

class SupportData {
  
  static let titleColor = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.6684702039, green: 0.9410213828, blue: 0.9152187705, alpha: 1),#colorLiteral(red: 0.6370797157, green: 0.8685694337, blue: 0.5887434483, alpha: 1)]
  
  static let titleArray = ["아침","점심","저녁"]
  
  static func reFetchDataSet(reloadDataView: UIView) {
  
    originDataArray = CoreDataManager.shared.fetchTodoList(ascending: true)
    dataArray = [[TodoList]]()
    for kinds in titleArray {
      var tempArray = [TodoList]()
      for item in originDataArray {
        if item.kinds == kinds {
          tempArray.append(item)
        }
      }
      dataArray.append(tempArray)
    }
    
    if let view = reloadDataView as? UITableView {
      view.reloadData()
    } else if let view = reloadDataView as? UICollectionView {
      view.reloadData()
    } else {
      fatalError("Error typecasting View")
    }
    
  }
}
