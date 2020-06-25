//
//  SecondVC.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/23.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
  
  let padding: CGFloat = 10
  
  let morningButton: UIButton = {
    let bt = UIButton()
    bt.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    bt.setTitle("아침", for: .normal)
    bt.layer.cornerRadius = 10
    bt.addTarget(self, action: #selector(tabButtonAction(_:)), for: .touchUpInside)
    return bt
  }()
  
  let afternoonButton: UIButton = {
    let bt = UIButton()
    bt.backgroundColor = #colorLiteral(red: 0.6684702039, green: 0.9410213828, blue: 0.9152187705, alpha: 1)
    bt.setTitle("점심", for: .normal)
    bt.layer.cornerRadius = 10
    bt.addTarget(self, action: #selector(tabButtonAction(_:)), for: .touchUpInside)
    return bt
  }()
  
  let dinnerButton: UIButton = {
    let bt = UIButton()
    bt.backgroundColor = #colorLiteral(red: 0.6370797157, green: 0.8685694337, blue: 0.5887434483, alpha: 1)
    bt.setTitle("저녁", for: .normal)
    bt.layer.cornerRadius = 10
    bt.addTarget(self, action: #selector(tabButtonAction(_:)), for: .touchUpInside)
    return bt
  }()
  
  fileprivate func configureAutolayout() {
    view.addSubview(morningButton)
    view.addSubview(afternoonButton)
    view.addSubview(dinnerButton)
    
    morningButton.translatesAutoresizingMaskIntoConstraints = false
    afternoonButton.translatesAutoresizingMaskIntoConstraints = false
    dinnerButton.translatesAutoresizingMaskIntoConstraints = false
    
    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      morningButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: padding),
      morningButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
      morningButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
      
      afternoonButton.topAnchor.constraint(equalTo: morningButton.bottomAnchor, constant: padding),
      afternoonButton.leadingAnchor.constraint(equalTo: morningButton.leadingAnchor),
      afternoonButton.trailingAnchor.constraint(equalTo: morningButton.trailingAnchor),
      afternoonButton.heightAnchor.constraint(equalTo: morningButton.heightAnchor, multiplier: 1),
      
      dinnerButton.topAnchor.constraint(equalTo: afternoonButton.bottomAnchor, constant: padding),
      dinnerButton.leadingAnchor.constraint(equalTo: morningButton.leadingAnchor),
      dinnerButton.trailingAnchor.constraint(equalTo: morningButton.trailingAnchor),
      dinnerButton.heightAnchor.constraint(equalTo: afternoonButton.heightAnchor, multiplier: 1),
      dinnerButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -padding)
    ])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
  
    configureAutolayout()
    
     
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = false
  }
  

  
  @objc func tabButtonAction(_ sender:UIButton) {
    let thirdVC = ThirdVC()
    thirdVC.viewTitle = sender.currentTitle
    navigationController?.pushViewController(thirdVC, animated: true)
  }
}
