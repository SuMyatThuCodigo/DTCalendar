//
//  DateExtension.swift
//  DTCalendar
//
//  Created by Dan Jiang on 2016/12/26.
//
//

import Foundation

extension Date {
  
  fileprivate static let formatter = DateFormatter()
  
  static var todaySymbol: String {
    Date.formatter.doesRelativeDateFormatting = true
    Date.formatter.dateStyle = .short
    Date.formatter.timeStyle = .none
    let symbol = Date.formatter.string(from: Date())
    Date.formatter.doesRelativeDateFormatting = false
    return symbol
  }
  
  static var shortWeekdaySymbols: [String] {
    return Date.formatter.shortWeekdaySymbols
  }
  
  func isSameDayOfYear(to date: Date) -> Bool {
    let calendar = Calendar.current
    var dateComponents1 = calendar.dateComponents([.day, .month, .year], from: self)
    var dateComponents2 = calendar.dateComponents([.day, .month, .year], from: date)
    guard let year1 = dateComponents1.year, let year2 = dateComponents2.year,
      let month1 = dateComponents1.month, let month2 = dateComponents2.month,
      let day1 = dateComponents1.day, let day2 = dateComponents2.day else {
      return false
    }
    return year1 == year1 && month1 == month2 && day1 == day2
  }
  
  func isSameMonthOfYear(to date: Date) -> Bool {
    let calendar = Calendar.current
    var dateComponents1 = calendar.dateComponents([.day, .month, .year], from: self)
    var dateComponents2 = calendar.dateComponents([.day, .month, .year], from: date)
    guard let year1 = dateComponents1.year, let year2 = dateComponents2.year,
      let month1 = dateComponents1.month, let month2 = dateComponents2.month else {
        return false
    }
    return year1 == year1 && month1 == month2
  }

  var shortDayOfMonth: String {
    return string(from: "d")
  }
  
  var shortMonthOfYear: String {
    return string(from: "MMM yyyy")
  }

  var longMonthOfYear: String {
    return string(from: "MMMM yyyy")
  }
  
  func string(from format: String) -> String {
    Date.formatter.dateFormat = format
    return Date.formatter.string(from: self)
  }
  
  var previousMonth: Date? {
    var dateComponents = DateComponents()
    dateComponents.month = -1
    return Calendar.current.date(byAdding: dateComponents, to: self)
  }
  
  var nextMonth: Date? {
    var dateComponents = DateComponents()
    dateComponents.month = 1
    return Calendar.current.date(byAdding: dateComponents, to: self)
  }
  
  var yesterday: Date? {
    var dateComponents = DateComponents()
    dateComponents.day = -1
    return Calendar.current.date(byAdding: dateComponents, to: self)
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

  var weekday: Int? {
    let dateComponents = Calendar.current.dateComponents([.weekday], from: self)
    return dateComponents.weekday
  }

  var numberOfDaysInMonth: Int {
    return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
  }

}
