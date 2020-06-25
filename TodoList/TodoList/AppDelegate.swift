//
//  AppDelegate.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/23.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  lazy var persistentContrainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TodoList")

    container.loadPersistentStores { (storeDescription, error) in
      if let error = error {
        fatalError("Unresolved error, \((error as NSError).userInfo)")
      }
      print(storeDescription.url ?? "")
    }
    return container
  }()
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let firstVC = FirstVC()
    let secondVC = SecondVC()
    let statisticVC = StatisticVC()
    let alarmSettingVC = AlramSettingVC()
    let tabBarController = UITabBarController()
    
    
    let secondNavVC = UINavigationController(rootViewController: secondVC)
    let statisticNavVc = UINavigationController(rootViewController: statisticVC)
    
    //Tab Bar Setting
    firstVC.tabBarItem = UITabBarItem(title: "To-Do List", image: UIImage(systemName: "tray.and.arrow.down"), tag: 0)
    secondVC.tabBarItem = UITabBarItem(title: "Manage List", image: UIImage(systemName: "rectangle.stack.person.crop.fill"), tag: 1)
    statisticVC.tabBarItem = UITabBarItem(title: "Statistic", image: UIImage(systemName: "rosette"), tag: 2)
    alarmSettingVC.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "pencil"), tag: 3)
    
    tabBarController.viewControllers = [firstVC,secondNavVC,statisticNavVc,alarmSettingVC]
    
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()
    
    return true
  }

}


