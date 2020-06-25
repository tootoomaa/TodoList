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
      title = viewTitle
    }
  }
  
  //MARK: - Properties
  var padding:CGFloat = 10
  var mainColor = ["아침":#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),"점심":#colorLiteral(red: 0.6684702039, green: 0.9410213828, blue: 0.9152187705, alpha: 1),"저녁":#colorLiteral(red: 0.6370797157, green: 0.8685694337, blue: 0.5887434483, alpha: 1)]
  
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
    frame: view.frame,
    collectionViewLayout: layout
  )
  
  // leyout 설정
  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.minimumLineSpacing = 0
    //    layout.minimumInteritemSpacing = 15
    layout.itemSize = .init(width: view.frame.width, height: 50)
    
    // width 값은 가로 스크롤 될 경우 적용됨
    //    layout.headerReferenceSize = CGSize(width: 60, height: 60)
    //    layout.footerReferenceSize = CGSize(width: 50, height: 50)
    
    //    layout.sectionHeadersPinToVisibleBounds = true // 스크롤시 헤더 고정
    //    layout.sectionFootersPinToVisibleBounds = true // 스크롤시 푸터 고정
    return layout
  }()
  
  //MARK: - Init
  fileprivate func configureCollectionView() {
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.register(ThirdCell.self, forCellWithReuseIdentifier: ThirdCell.identifier)
    
    view.addSubview(collectionView)
    
    setupLongPressGestureRecognizer()
  }
  
  fileprivate func fetchData() {
    // fetch Data
    if let viewTitle = viewTitle {
      todoList = CoreDataManager.shared.fetchKindsTodoList(kinds: viewTitle)
      print(todoList)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    fetchData()
    
    textField.delegate = self
    
    configureCollectionView()
    
  }
  
  func setupLongPressGestureRecognizer() {
    
    let gesture = UILongPressGestureRecognizer(
      target: self,
      action: #selector(reorderCollectionViewItem(_:))
    )
    collectionView.addGestureRecognizer(gesture)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = true
  }
  
  // 할일 입력 창
  override var inputAccessoryView: UIView? {
    get {
      return containerView
    }
  }
  
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
  
  
  @objc func tabAddButton() {
    print("add Button")
    
    if let todoTitle = textField.text,
      let viewTitle = viewTitle {
      CoreDataManager.shared.saveUser(index: todoList.count, title: todoTitle, kinds: viewTitle, alramTime: "AM 6", complete: false) { (test) in
        if !test { print("Error ")}
      }
      fetchData()
      collectionView.reloadData()
    }
  }
  
  
  func remove(_ index: Int) {

      todoList.remove(at: index)

      let indexPath = IndexPath(row: index, section: 0)

      self.collectionView.performBatchUpdates({
          self.collectionView.deleteItems(at: [indexPath])
      }) { (finished) in
          self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
      }

  }
}


extension ThirdVC: UITextFieldDelegate {
  override var canBecomeFirstResponder: Bool {
    return true
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

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    guard sourceIndexPath != destinationIndexPath else { print("Erro"); return }
    
    let destination = destinationIndexPath.item
    let source = sourceIndexPath.item
    
    todoList[destination].index = source
    todoList[source].index = destination
    
    print("source \(source), dest :\(destination)")
    
    // 기존 경로 삭제 후 추가
    let elemnet = todoList.remove(at: source)
    todoList.insert(elemnet, at: destination)
    
    CoreDataManager.shared.changeSaveData() { onSuccess in
      print("sucess")
    }
  }
  
  /*
  CoreDataManager.shared.deleteUser(id: id) { onSuccess in
      print("deleted = \(onSuccess)")
  }
  */
}
