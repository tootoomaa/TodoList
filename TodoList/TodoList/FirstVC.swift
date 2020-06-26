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
var originDataArray = [TodoList]()

class FirstVC: UIViewController, NSFetchedResultsControllerDelegate {
  
  //MARK: - Properties
  
  let tableView = UITableView()
  
  let completeCheckArray:[Bool] = []
  
  
  
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
    // fetch All user
    SupportData.reFetchDataSet(reloadDataView: tableView)
  }
}


//MARK: - UITableViewDelegate
extension FirstVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return SupportData.titleArray.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
  {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    let label = UILabel()
    label.text = SupportData.titleArray[section]
    label.font = .systemFont(ofSize: 20)
    headerView.backgroundColor = SupportData.titleColor[section]
    headerView.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10 )
    ])
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return SupportData.titleArray[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FirstCell.reuseIdentifier, for: indexPath) as! FirstCell

    let itemArray = dataArray[indexPath.section]
    cell.todoItem = itemArray[indexPath.row]
    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}


extension FirstVC: FirstCellDelegate {
  func tabCompleteButton(todoItem: TodoList) {
    for item in originDataArray {
      if item.createTime == todoItem.createTime {
        item.complete.toggle()
      }
    }
    
    CoreDataManager.shared.savedAllTodoList { (onSuccess) in
      onSuccess ? print("Save Success") : print("Save fail in firstVC")
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
