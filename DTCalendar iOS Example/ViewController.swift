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
  
  fileprivate let calendar = DTCalendar()

  fileprivate let formatter = DateFormatter()
  fileprivate var emojis = [Emoji]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.timeStyle = .none
    formatter.dateStyle = .full
    label.text = formatter.string(from: Date())

//    DTCalendar.isMonthControlsHidden = true
//    DTCalendar.isDayControlsHidden = true

//    DTCalendar.highlight = .ovalStroke
//    DTCalendar.theme = MyTheme()
    
    calendar.dataSource = self
    calendar.delegate = self
    
    view.addSubview(calendar)
    
    calendar.translatesAutoresizingMaskIntoConstraints = false
    
    let top = NSLayoutConstraint(item: calendar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
    let leading = NSLayoutConstraint(item: calendar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: calendar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
    
    view.addConstraints([top, leading, trailing])
  }
  
  func listAnimals(with date: Date) {
    guard let firstDayOfMonth = date.firstDayOfMonth else { return }
  
    emojis.removeAll()
    
    var eachDate = firstDayOfMonth
    while eachDate.isSameMonthOfYear(to: date) {
      if let emoji = emoji(with: eachDate) {
        emojis.append(emoji)
      }
      eachDate = eachDate.tomorrow!
    }
    
    calendar.reloadBadges()
  }
  
  func emoji(with date: Date) -> Emoji? {
    let randomNum = arc4random_uniform(4)
    let num = Int(randomNum)
    switch num {
    case 1:
      return Emoji(date: date, text: "🐶")
    case 2:
      return Emoji(date: date, text: "🐱")
    case 3:
      return Emoji(date: date, text: "🐔")
    default:
      return nil
    }
  }

}

extension ViewController: DTCalendarDataSource {
  
  func calendar(_ calendar: DTCalendar, badgeForDate date: Date) -> DTBadge? {
    return emojis.first { date.isSameDayOfYear(to: $0.date) }.map { emoji -> DTBadge in
      let badge = EmojiBadge()
      badge.label.text = emoji.text
      return badge
    }
  }
  
}

extension ViewController: DTCalendarDelegate {
  
  func calendar(_ calendar: DTCalendar, didSelectedDate date: Date, isDifferentMonth: Bool) {
    label.text = formatter.string(from: date)
    if isDifferentMonth {
      listAnimals(with: date)
    }
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
  
  let label = UILabel()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
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
      label.font = UIFont.systemFont(ofSize: 8)
    case .today:
      label.font = UIFont.systemFont(ofSize: 8)
    case .selected:
      label.font = UIFont.systemFont(ofSize: 16)
    }
  }

}

struct Emoji {
  let date: Date
  let text: String
}

extension Date {
  
  func isSameDayOfYear(to date: Date) -> Bool {
    let calendar = Calendar.current
    var dateComponents1 = calendar.dateComponents([.day, .month, .year], from: self)
    var dateComponents2 = calendar.dateComponents([.day, .month, .year], from: date)
    guard let year1 = dateComponents1.year, let year2 = dateComponents2.year,
      let month1 = dateComponents1.month, let month2 = dateComponents2.month,
      let day1 = dateComponents1.day, let day2 = dateComponents2.day else {
        return false
    }
    return year1 == year2 && month1 == month2 && day1 == day2
  }
  
  func isSameMonthOfYear(to date: Date) -> Bool {
    let calendar = Calendar.current
    var dateComponents1 = calendar.dateComponents([.day, .month, .year], from: self)
    var dateComponents2 = calendar.dateComponents([.day, .month, .year], from: date)
    guard let year1 = dateComponents1.year, let year2 = dateComponents2.year,
      let month1 = dateComponents1.month, let month2 = dateComponents2.month else {
        return false
    }
    return year1 == year2 && month1 == month2
  }

  var tomorrow: Date? {
    var dateComponents = DateComponents()
    dateComponents.day = 1
    return Calendar.current.date(byAdding: dateComponents, to: self)
  }
  
  var firstDayOfMonth: Date? {
    return dayOfMonth(with: 1)
  }
  
  func dayOfMonth(with day: Int) -> Date? {
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.day, .month, .year], from: self)
    dateComponents.day = day
    return calendar.date(from: dateComponents)
  }
  
}
