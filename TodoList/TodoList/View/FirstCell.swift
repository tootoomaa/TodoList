//
//  FirstCell.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/22.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

class FirstCell: UITableViewCell {
  static var reuseIdentifier = "FirstCell"
  
  var todoItem: TodoList? {
    didSet {
      guard let todoTitleName = todoItem?.title,
        let setTime = todoItem?.alarmTime,
        let complete = todoItem?.complete else { return }
      
      timeLabel.text = setTime
      checkButton.isSelected = complete
      
      let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todoTitleName)
      if checkButton.isSelected == true {
        // 취소선 추가
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
      }
      todoTitle.attributedText = attributeString
      
    }
  }
  
  lazy var checkButton: UIButton = {
    let bt = UIButton()
    let circleImage = UIImage(systemName: "circle")
    bt.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
    
    bt.setImage(circleImage, for: .normal)
    bt.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
    bt.addTarget(self, action: #selector(tabCheckButton(_:)), for: .touchUpInside)
    bt.backgroundColor = .white
    bt.isSelected = false
    return bt
  }()
  
  let todoTitle: UILabel = {
    let label = UILabel()
    label.text = "test Todo list Name"
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.text = "AM 6:00"
    return label
  }()
  
  var delegate: FirstCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    
    addSubview(checkButton)
    addSubview(todoTitle)
    addSubview(timeLabel)
    
    checkButton.translatesAutoresizingMaskIntoConstraints = false
    todoTitle.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      todoTitle.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
      todoTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      
      timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
      timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func tabCheckButton(_ sender:UIButton) {
    sender.isSelected.toggle()
    
    guard let string = self.todoTitle.text else { return }
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: string)
    if sender.isSelected == true {
      // 취소선 추가
      attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    }
    todoTitle.attributedText = attributeString
    
    guard let todoItem = todoItem else {return}
    delegate?.tabCompleteButton(todoItem: todoItem)
  }
  
}
