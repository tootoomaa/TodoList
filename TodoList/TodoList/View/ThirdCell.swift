//
//  ThirdCell.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/24.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

class ThirdCell: UICollectionViewCell {
  static let identifier = "ThirdCell"
  var todoItem: TodoList? {
    didSet {
      guard let todoTitleName = todoItem?.title,
        let complete = todoItem?.complete else { return }
      
      todoTitle.text = todoTitleName
      
    }
  }
  
  let todoTitle: UILabel = {
    let label = UILabel()
    label.text = "test Todo list Name"
    return label
  }()
  
  let moveKeyImage: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(systemName: "line.horizontal.3")
    return img
  }()
  
  let padding:CGFloat = 20
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(todoTitle)
    addSubview(moveKeyImage)
    
    todoTitle.translatesAutoresizingMaskIntoConstraints = false
    moveKeyImage.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      todoTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      todoTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      moveKeyImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      moveKeyImage.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
