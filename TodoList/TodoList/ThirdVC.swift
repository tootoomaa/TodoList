//
//  ThirdVC.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/23.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

class ThirdVC: UIViewController {
  
  //MARK: - Passed Properties
  var viewTitle: String? {
    didSet {
      guard let viewTitle = viewTitle else { return }
      title = viewTitle
    }
  }
  
  //MARK: - Properties
  var padding:CGFloat = 10
  var deleteIndexPathArray = [IndexPath]()
  var deleteTodoItemArray = [TodoList]()
  var todoList = [TodoList]()
  
  let textField: UITextField = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.placeholder = " 할일을 입력하세요"
    tf.layer.cornerRadius = 10
    tf.autocorrectionType = .no
    tf.clearButtonMode = .whileEditing
    tf.autocapitalizationType = .none
    return tf
  }()
  
  let addButton: UIButton = {
    let bt = UIButton()
    bt.setTitle("add", for: .normal)
    bt.layer.cornerRadius = 10
    bt.backgroundColor = #colorLiteral(red: 0.6522397995, green: 0.8634604812, blue: 0.9384719729, alpha: 1)
    bt.addTarget(self, action: #selector(tabAddButton), for: .touchUpInside)
    return bt
  }()
  
  //MARK: - ContainerView
  lazy var containerView: UIView = {
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
    
    containerView.layer.cornerRadius = 10
    containerView.addSubview(textField)
    containerView.addSubview(addButton)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: padding),
      textField.topAnchor.constraint(equalTo: containerView.topAnchor,constant: padding),
      textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -padding),
      
      addButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      addButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor,constant: padding),
      addButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
      addButton.topAnchor.constraint(equalTo: containerView.topAnchor,constant: padding),
      addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -padding),
      addButton.widthAnchor.constraint(equalTo: textField.widthAnchor, multiplier: 0.2)
    ])
    containerView.backgroundColor = #colorLiteral(red: 0.9564241767, green: 0.9574552178, blue: 0.9221780896, alpha: 1)
    
    return containerView
  }()
  
  // collectionVeiw 인스턴스 생성
  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: layout
  )
  
  // leyout 설정
  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.minimumLineSpacing = 0
    //    layout.minimumInteritemSpacing = 15
    layout.itemSize = .init(width: view.frame.width, height: 50)
    
    //    layout.sectionHeadersPinToVisibleBounds = true // 스크롤시 헤더 고정
    //    layout.sectionFootersPinToVisibleBounds = true // 스크롤시 푸터 고정
    return layout
  }()
  
  //MARK: - configure UI
  fileprivate func configureCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.backgroundColor = .white
    collectionView.register(ThirdCell.self, forCellWithReuseIdentifier: ThirdCell.identifier)
    
    view.addSubview(collectionView)
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
    ])
    
    // setupLongPressGuestureRecognizer
    let gesture = UILongPressGestureRecognizer(
      target: self,
      action: #selector(reorderCollectionViewItem(_:))
    )
    collectionView.addGestureRecognizer(gesture)
  }

  
  fileprivate func fetchData() {
    guard let kinds = viewTitle else { return }
    
    // fetch Data
    todoList = CoreDataManager.shared.fetchKindsTodoList(kinds: kinds)
    
    // reload data
    collectionView.reloadData()
    
  }
  
  
  fileprivate func configureBasicUI() {
    let index = (viewTitle == "아침" ? 0 : (viewTitle == "점심" ? 1 : 2))
    
    view.backgroundColor = SupportData.titleColor[index]
    
    guard let naviController = navigationController else { return }
    naviController.navigationBar.isHidden = false
    naviController.navigationBar.prefersLargeTitles = true
    
    naviController.navigationBar.barTintColor = SupportData.titleColor[index]
    naviController.navigationBar.backgroundColor = SupportData.titleColor[index]
 
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(tabDeleteButton))
  }
  
  //MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureBasicUI()
    
    configureCollectionView()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    guard let kinds = viewTitle else { return }
    todoList = CoreDataManager.shared.fetchKindsTodoList(kinds: kinds)
    tabBarController?.tabBar.isHidden = true
  }
  
  // 할일 입력 창
  override var inputAccessoryView: UIView? {
    get {
      return containerView
    }
  }
  
  //MARK: - API
  
  @objc private func reorderCollectionViewItem(_ sender: UILongPressGestureRecognizer) {
    let location = sender.location(in: collectionView)
    switch sender.state {
    case .began:
      guard let indexPath = collectionView.indexPathForItem(at: location) else {break}
      collectionView.beginInteractiveMovementForItem(at: indexPath)
    case .changed:
      collectionView.updateInteractiveMovementTargetPosition(location)
    case .ended:
      collectionView.endInteractiveMovement()
    case .cancelled:
      collectionView.cancelInteractiveMovement()
    default: break
    }
  }
  
  @objc func tabDeleteButton() {
    guard let kinds = viewTitle else { return }
    
    if !deleteIndexPathArray.isEmpty {
      // indexPath.item수가 큰 이미지부터 제거
      for indexPath in deleteIndexPathArray.sorted(by:>) {
        // DB에서 삭제
        removeTodoItem(indexPath: indexPath)
        
        // 이미지 배열에서 제거
        todoList.remove(at: indexPath.item)
      }
      // collection View에서 제거
      collectionView.deleteItems(at: deleteIndexPathArray)
    }
    
    // fetch Data
    todoList = CoreDataManager.shared.fetchKindsTodoList(kinds: kinds)
    
    // reload data
    collectionView.reloadData()

    // 삭제를 위한 배열 초기화
    deleteTodoItemArray = []
    deleteIndexPathArray = []
  }
  
  @objc func tabAddButton() {
    guard let title = textField.text,
      let kinds = viewTitle else { return }
    
    // Insert New Data
    let creationDate = Int(NSDate().timeIntervalSince1970)
    CoreDataManager.shared.saveTodoItem(createTime: creationDate, title: title, kinds: kinds) {  (onSuccess) in onSuccess ? print("Save Success") : print("Save fail in ThirdVC") }
    
    // fetch Data
    todoList = CoreDataManager.shared.fetchKindsTodoList(kinds: kinds)
    
    // reload data
    collectionView.reloadData()
  }
  
  func removeTodoItem(indexPath : IndexPath) {
    
    guard let cell = collectionView.cellForItem(at: indexPath) as? ThirdCell else { return }
    guard let createTime = cell.todoItem?.createTime else { return }

    CoreDataManager.shared.deleteTodoList(createTime: createTime) { (onSuccess) in
      onSuccess ? print("delete Success") : print("delete fail in ThirdVC") }
  }
  
}

//MARK: - TextFieldDelegate
extension ThirdVC: UITextFieldDelegate {
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.text = nil
  }
  
}


//MARK: - UICollectionViewDataSource
extension ThirdVC: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return todoList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThirdCell.identifier, for: indexPath) as! ThirdCell
    
    cell.todoItem = todoList[indexPath.item]
    cell.isMultipleTouchEnabled = true
    cell.isSelected = false
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    guard sourceIndexPath != destinationIndexPath else { print("Error"); return }
    let destination = destinationIndexPath.item
    let source = sourceIndexPath.item
    
    // 기존 경로 삭제 후 추가
    let elemnet = todoList.remove(at: source)
    todoList.insert(elemnet, at: destination)
    
    // 실제 DB 변경
    CoreDataManager.shared.changeValueMovedItems(todoList: todoList, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    
    if !deleteIndexPathArray.contains(indexPath) {
      // 신규 항목 추가
      deleteIndexPathArray.append(indexPath)
      cell.backgroundColor = .systemGray4
    } else {
      // 중복 항목 제거
      cell.backgroundColor = .white
      if let deleteIndex = deleteIndexPathArray.firstIndex(of: indexPath) {
        deleteIndexPathArray.remove(at: deleteIndex)
      }
    }
  }
  
}
