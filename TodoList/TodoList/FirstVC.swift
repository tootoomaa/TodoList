//
//  ViewController.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/22.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit
import CoreData

var dataArray = [[TodoList]]()

class FirstVC: UIViewController, NSFetchedResultsControllerDelegate {
  
  //MARK: - Properties
  
  let tableView = UITableView()
  let titleArray = ["아침","점심","저녁"]
  let completeCheckArray:[Bool] = []
  
  let titleColor = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.6684702039, green: 0.9410213828, blue: 0.9152187705, alpha: 1),#colorLiteral(red: 0.6370797157, green: 0.8685694337, blue: 0.5887434483, alpha: 1)]
  
  enum TodoIndex: String {
    case moring = "아침"
    case afternoon = "점심"
    case dinner = "저녁"
    case etc = "기타"
  }
  
  var todoLists = [TodoList]()
  
  fileprivate func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(FirstCell.self, forCellReuseIdentifier: FirstCell.reuseIdentifier)
    
    view.addSubview(tableView)
    tableView.separatorStyle = .none
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: guide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
    ])
    
  }
  
  
  //MARK: - Init
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    navigationController?.navigationItem.title = "To-Do List"
    
    // tableView 정보 가져옴
    configureTableView()
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // core Data에서 데이터 불러옴
    getAllUsers()
    tableView.reloadData()
  }
  

  
  //MARK: - CoreData API
  
  fileprivate func saveNewUser(index:Int, title:String, kinds:String, alramTime:String, complete:Bool) {
    CoreDataManager.shared
      .saveUser(index: index,title: title, kinds:kinds, alramTime: alramTime, complete: complete, onSuccess: { onSuccess in
        print("saved = \(onSuccess)")
      })
  }
  
  fileprivate func deleteUser(index: Int) {
    CoreDataManager.shared.deleteUser(index: index) { onSuccess in
      print("deleted = \(onSuccess)")
    }
  }
  
  fileprivate func getAllUsers() {
    //데이터를 디비에서 추출
    todoLists = CoreDataManager.shared.getUsers()
    
    // 데이터 형식 변경
    for index in 0..<titleArray.count {
      var tempArray = [TodoList]()
      for todoItem in todoLists {
        if todoItem.kinds == titleArray[index] {
          tempArray.append(todoItem)
        }
      }
      dataArray.append(tempArray)
    }
    print(dataArray[0])
  }
  
  fileprivate func deleteAll() {
    print("hello")
    //    CoreDataManager.deleteAll(request: request)
  }
  
}


//MARK: - UITableViewDelegate
extension FirstVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    let label = UILabel()
    label.text = titleArray[section]
    label.font = .systemFont(ofSize: 20)
    headerView.backgroundColor = titleColor[section]
    headerView.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10 )
    ])
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return titleArray[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FirstCell.reuseIdentifier, for: indexPath) as! FirstCell
    let todoItemArray = dataArray[indexPath.section]
    
    for item in todoItemArray {
      if item.index == indexPath.row {
        cell.todoItem = item
      }
    }
    
    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}


extension FirstVC: FirstCellDelegate {
  func tabCompleteButton(todoItem: TodoList) {
    print(todoItem)
    for item in todoLists {
      if item.index == todoItem.index && item.kinds == todoItem.kinds {
        todoItem.complete.toggle()
//        print(todoItem.complete)
        CoreDataManager.shared.changeSaveData() { onSuccess in
          print("sucess")
        }
      }
    }
  }
}



/* 데이터 생성
 saveNewUser(index: 0, title: "물 마시기0", kinds: "아침", alramTime: "AM 6", complete: false)
 saveNewUser(index: 1, title: "물 마시기1", kinds: "아침", alramTime: "AM 6", complete: false)
 saveNewUser(index: 2, title: "물 마시기2", kinds: "아침", alramTime: "AM 6", complete: false)
 saveNewUser(index: 3, title: "물 마시기3", kinds: "아침", alramTime: "AM 6", complete: false)
 //
 saveNewUser(index: 0, title: "물 마시기0", kinds: "점심", alramTime: "AM 6", complete: false)
 saveNewUser(index: 1, title: "물 마시기1", kinds: "점심", alramTime: "AM 6", complete: false)
 saveNewUser(index: 2, title: "물 마시기2", kinds: "점심", alramTime: "AM 6", complete: false)
 saveNewUser(index: 3, title: "물 마시기3", kinds: "점심", alramTime: "AM 6", complete: false)
 //
 saveNewUser(index: 0, title: "물 마시기0", kinds: "저녁", alramTime: "AM 6", complete: false)
 saveNewUser(index: 1, title: "물 마시기1", kinds: "저녁", alramTime: "AM 6", complete: false)
 saveNewUser(index: 2, title: "물 마시기2", kinds: "저녁", alramTime: "AM 6", complete: false)
 saveNewUser(index: 3, title: "물 마시기3", kinds: "저녁", alramTime: "AM 6", complete: false)
 */
