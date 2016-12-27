//
//  ViewController.swift
//  DTCalendar iOS Example
//
//  Created by Dan Jiang on 2016/12/22.
//
//

import UIKit
import DTCalendar

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  
  fileprivate let formatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.timeStyle = .none
    formatter.dateStyle = .full
    label.text = formatter.string(from: Date())

//    DTCalendar.isMonthControlsHidden = true
//    DTCalendar.isDayControlsHidden = true

//    DTCalendar.highlight = .ovalStroke
//    DTCalendar.theme = MyTheme()
    
    let calendar = DTCalendar()
    calendar.dataSource = self
    calendar.delegate = self
    
    view.addSubview(calendar)
    
    calendar.translatesAutoresizingMaskIntoConstraints = false
    
    let top = NSLayoutConstraint(item: calendar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
    let leading = NSLayoutConstraint(item: calendar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: calendar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
    
    view.addConstraints([top, leading, trailing])
  }

}

extension ViewController: DTCalendarDataSource {
  
  func badge(with date: Date, on calendar: DTCalendar) -> DTBadge? {
    let dateComponents = Calendar.current.dateComponents([.weekday], from: date)
    if let weekday = dateComponents.weekday {
      if weekday == 2 || weekday == 4 || weekday == 6 {
        return EmojiBadge()
      }
    }
    return nil
  }
  
}

extension ViewController: DTCalendarDelegate {
  
  func didSelectedDate(_ date: Date, on calendar: DTCalendar) {    
    label.text = formatter.string(from: date)
  }
  
}

struct MyTheme: DTCalendarTheme {
  
  var dayHighlightColor: UIColor {
    return UIColor(white: 0.26, alpha: 1)
  }
  
  var dayLabelColor: UIColor {
    return UIColor.white
  }
  
  var dayBadgeColor: UIColor {
    return UIColor.white
  }
  
}

class EmojiBadge: DTBadge {
  
  fileprivate let label = UILabel()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label.font = UIFont.systemFont(ofSize: 8)

    addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
    let leading = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    
    addConstraints([top, bottom, leading, trailing])
  }
  
  override func didChangeStyle(_ style: Style) {
    switch style {
    case .normal:
      label.text = "🐶"
    case .today:
      label.text = "🐱"
    case .selected:
      label.text = "🐔"
    }
  }

}
