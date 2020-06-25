//
//  StatisticVC.swift
//  TodoList
//
//  Created by 김광수 on 2020/06/23.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class StatisticVC: UIViewController, ChartViewDelegate, IAxisValueFormatter {
  
  var numbers: [Double] = [86,68,100,60,65,80,90]
  var dayArary: [String] = ["월요일","화요일","수요일","목요일","금요일","토요일","일요일"]
  var monthArray: [Double] = []
  
  let segCon: UISegmentedControl = {
    let sc = UISegmentedControl(items: ["Day","Month","Year"])
    sc.backgroundColor = UIColor.white
    sc.tintColor = UIColor.white
    sc.addTarget(self, action: #selector(segconChanged(_:)), for: .valueChanged)
    return sc
  }()
  
  let displayDurationLabel:UILabel = {
    let label = UILabel()
    label.text = "20년 6월 1주차"
    label.font = .systemFont(ofSize: 20)
    label.backgroundColor = .white
    label.textAlignment = .center
    return label
  }()
  
  let defaultCharView:UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray4
    return view
  }()
     
  
  //MARK: - BuildUI
  fileprivate func configureMainUI() {
    let guide = view.safeAreaLayoutGuide
    [segCon,displayDurationLabel,defaultCharView].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
      $0.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
      
    }
    
    NSLayoutConstraint.activate([
      segCon.topAnchor.constraint(equalTo: guide.topAnchor ),
      segCon.heightAnchor.constraint(equalToConstant: 35),
      
      displayDurationLabel.topAnchor.constraint(equalTo: segCon.bottomAnchor),
      displayDurationLabel.heightAnchor.constraint(equalToConstant: 60),
      
      defaultCharView.topAnchor.constraint(equalTo: displayDurationLabel.bottomAnchor),
      defaultCharView.heightAnchor.constraint(equalToConstant: view.frame.size.width)
      
    ])
  }
  
  //MARK: - init

  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.backgroundColor = .white
    navigationItem.title = "Statistic"
    
    // 초기 셋팅
    segCon.selectedSegmentIndex = 0
    setupCharView(selectedSegmentIndex: segCon.selectedSegmentIndex)
    
    // 오토 레이아웃
    configureMainUI()
    
  }
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return dayArary[Int(value)]
  }
  
  @objc func segconChanged(_ segcon:UISegmentedControl) {
    
    configureStaticView(selectedSegmentIndex: segcon.selectedSegmentIndex)
    
  }
  
  func configureStaticView(selectedSegmentIndex number:Int) {
    print(number)
    // top : displayDurationLabel Setting
    setDisplayDurationLabel(selectedSegmentIndex: number)
    
    // mid : deafaultCharView Setting
    setupCharView(selectedSegmentIndex: number)
    
    // bottom : textLabel? text Field?
    
  }
  
  func setDisplayDurationLabel(selectedSegmentIndex number:Int) {
    var text:String = ""
    
    switch number {
    case 0: text = "20년 6월 1주차"
    case 1: text = "20년 6월"
    case 2: text = "2020년"
    default: text = ""
    }
    
    displayDurationLabel.text = text
  }
  
  func setupCharView(selectedSegmentIndex number:Int) {
  
    let chartView = BarChartView()     // 인스턴스 생성
    var barChartEntry = [BarChartDataEntry]()
    var count: Int = 0 // 임시
    
    chartView.delegate = self
//    axisFormatDelegate = self
    
    // [임시] 데이터 저장
    if number == 0 {
      count = 7
      
    } else if number == 1 {
      count = 30
    } else {
      count = 365
    }
    
    for i in 0..<count {
      let value = BarChartDataEntry(x: Double(i), y: Double((1...100).randomElement()!))
         barChartEntry.append(value)
    }
    
    // Chart 기본 설정
    chartView.backgroundColor = .white
    chartView.chartDescription?.enabled = false
    chartView.dragEnabled = true
    chartView.setScaleEnabled(true)
    chartView.pinchZoomEnabled = false
    chartView.maxVisibleCount = 60
    
    // x 축 설정
    let xAxis = chartView.xAxis
    xAxis.labelPosition = .bottom
    xAxis.labelFont = .systemFont(ofSize: 10)
    //    xAxis.granularity = 1
    xAxis.labelCount = count // x축 라벨 수
    //        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView)
    xAxis.valueFormatter = IndexAxisValueFormatter(values: dayArary)
    xAxis.granularity = 1
    
    
    // 왼쪽 Y축
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.minimumFractionDigits = 0
    leftAxisFormatter.maximumFractionDigits = 0
    //    leftAxisFormatter.negativeSuffix = " 회"
    leftAxisFormatter.positiveSuffix = " %"
    
    let leftAxis = chartView.leftAxis
    leftAxis.labelFont = .systemFont(ofSize: 10)
    leftAxis.labelCount = 10
    leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    leftAxis.labelPosition = .outsideChart   //.insideChart
    leftAxis.spaceTop = 0.15
    leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
    leftAxis.axisMaximum = 100
    
    // 오른쪽 Y축
    let rightAxis = chartView.rightAxis
    rightAxis.enabled = false
    
    // 데이터 저장
    let bar1 = BarChartDataSet(entries: barChartEntry, label: "완료 수")
    bar1.colors = [NSUIColor.init(cgColor: #colorLiteral(red: 0.9345774055, green: 0.7326899171, blue: 0.3023572266, alpha: 1))]
    
    let data = BarChartData()
    data.addDataSet(bar1)
    
    chartView.data = data
    
    defaultCharView.addSubview(chartView)
    chartView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      chartView.topAnchor.constraint(equalTo: defaultCharView.topAnchor),
      chartView.leadingAnchor.constraint(equalTo: defaultCharView.leadingAnchor),
      chartView.trailingAnchor.constraint(equalTo: defaultCharView.trailingAnchor),
      chartView.bottomAnchor.constraint(equalTo: defaultCharView.bottomAnchor)
    ])
  }
  
}

