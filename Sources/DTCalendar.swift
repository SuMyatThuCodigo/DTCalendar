//
//  DTCalendar.swift
//  DTCalendar
//
//  Created by Dan Jiang on 2016/12/24.
//
//

import UIKit

public protocol DTCalendarTheme {
  var backgroundColor: UIColor { get }
  var controlsColor: UIColor { get }
  var weekdayLabelColor: UIColor { get }
  var dayHighlightColor: UIColor { get }
  var todayHighlightColor: UIColor { get }
  var selectedHighlightColor: UIColor { get }
  var dayLabelColor: UIColor { get }
  var todayLabelColor: UIColor { get }
  var selectedLabelColor: UIColor { get }
  var dayBadgeColor: UIColor { get }
  var todayBadgeColor: UIColor { get }
  var selectedBadgeColor: UIColor { get }
}

public extension DTCalendarTheme {
  
  var backgroundColor: UIColor {
    return UIColor(white: 0.26, alpha: 1)
  }
  
  var controlsColor: UIColor {
    return UIColor.white
  }

  var weekdayLabelColor: UIColor {
    return UIColor.white
  }
  
  var dayHighlightColor: UIColor {
    return UIColor(white: 0.86, alpha: 1)
  }
  
  var todayHighlightColor: UIColor {
    return UIColor(red: 0.95, green: 0.33, blue: 0.17, alpha: 1)
  }
  
  var selectedHighlightColor: UIColor {
    return UIColor(white: 0.57, alpha: 1)
  }
  
  var dayLabelColor: UIColor {
    return UIColor(white: 0.26, alpha: 1)
  }
  
  var todayLabelColor: UIColor {
    return UIColor.white
  }

  var selectedLabelColor: UIColor {
    return UIColor.white
  }

  var dayBadgeColor: UIColor {
    return UIColor(white: 0.26, alpha: 1)
  }
  
  var todayBadgeColor: UIColor {
    return UIColor.white
  }
  
  var selectedBadgeColor: UIColor {
    return UIColor.white
  }
  
}

public protocol DTCalendarDataSource {
  func calendar(_ calendar: DTCalendar, badgeForDate date: Date) -> DTBadge?
}

public protocol DTCalendarDelegate {
  func calendar(_ calendar: DTCalendar, didSelectedDate date: Date, isDifferentMonth: Bool)
}

public class DTCalendar: UIView {
  
  public struct DefaultTheme: DTCalendarTheme {}
  
  public enum Highlight {
    case rectFill
    case rectStroke
    case ovalFill
    case ovalStroke
  }
  
  public static func imageWithName(_ name: String) -> UIImage? {
    let bundle = Bundle(for: DTCalendar.self)
    let url = bundle.url(forResource: "DTCalendar", withExtension: "bundle")!
    let imageBundle = Bundle(url: url)
    return UIImage(named: name, in: imageBundle, compatibleWith: nil)
  }
  
  public static var theme: DTCalendarTheme = DefaultTheme()
  public static var highlight: DTCalendar.Highlight = .rectFill
  public static var isControlsOnTop = true
  public static var isMonthControlsHidden = false
  public static var isDayControlsHidden = false  
  
  public var dataSource: DTCalendarDataSource?
  public var delegate: DTCalendarDelegate? {
    didSet {
      delegate?.calendar(self, didSelectedDate: selectedDate, isDifferentMonth: true)
    }
  }
  
  fileprivate var selectedDate = Date() {
    didSet {
      if !oldValue.isSameMonthOfYear(to: selectedDate) {
        controlsView.reloadMonthButtonTitle()
        daysView.reloadDays()
      } else if !oldValue.isSameDayOfYear(to: selectedDate) {
        daysView.reloadStyle(with: oldValue)
        daysView.reloadStyle(with: selectedDate)
      }
      if !oldValue.isSameDayOfYear(to: selectedDate) {
        delegate?.calendar(self, didSelectedDate: selectedDate, isDifferentMonth: !oldValue.isSameMonthOfYear(to: selectedDate))
      }
    }
  }
  
  private let controlsView = ControlsView()
  private let weekdaysView = WeekdaysView()
  private let daysView = DaysView()
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
   
    backgroundColor = DTCalendar.theme.backgroundColor
    
    if !DTCalendar.isMonthControlsHidden || !DTCalendar.isDayControlsHidden {
      layoutControlsView()
    }
    layoutWeekdaysView()
    layoutDaysView()
    
    controlsView.reloadMonthButtonTitle()
    daysView.reloadDays()

  }
  
  // MARK: - Actions
  
  public func goPreviousMonth() {
    selectedDate = selectedDate.previousMonth!
  }
  
  public func goNextMonth() {
    selectedDate = selectedDate.nextMonth!
  }
  
  public func goYesterday() {
    selectedDate = selectedDate.yesterday!
  }
  
  public func goTomorrow() {
    selectedDate = selectedDate.tomorrow!
  }

  public func goToday() {
    selectedDate = Date()
  }
  
  public func goDate(_ date: Date) {
    selectedDate = date
  }
  
  public func reloadBadges() {
    daysView.reloadBadges()
  }
  
  public func reloadBadge(with date: Date) {
    daysView.reloadBadge(with: date)
  }
  
  // MARK: - Private
  
  private func layoutControlsView() {
    controlsView.dataSource = self
    controlsView.delegate = self

    addSubview(controlsView)
    
    controlsView.translatesAutoresizingMaskIntoConstraints = false
    
    let height = NSLayoutConstraint(item: controlsView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 46)
    let leading = NSLayoutConstraint(item: controlsView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: controlsView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    if DTCalendar.isControlsOnTop {
      let top = NSLayoutConstraint(item: controlsView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
      addConstraint(top)
    } else {
      let bottom = NSLayoutConstraint(item: controlsView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
      addConstraint(bottom)
    }
    
    controlsView.addConstraint(height)
    addConstraints([leading, trailing])
  }
  
  private func layoutWeekdaysView() {
    addSubview(weekdaysView)
    
    weekdaysView.translatesAutoresizingMaskIntoConstraints = false
    
    let height = NSLayoutConstraint(item: weekdaysView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 26)
    let leading = NSLayoutConstraint(item: weekdaysView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: weekdaysView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    
    weekdaysView.addConstraint(height)
    addConstraints([leading, trailing])
    
    var top: NSLayoutConstraint
    if DTCalendar.isControlsOnTop && (!DTCalendar.isMonthControlsHidden || !DTCalendar.isDayControlsHidden) {
      top = NSLayoutConstraint(item: weekdaysView, attribute: .top, relatedBy: .equal, toItem: controlsView, attribute: .bottom, multiplier: 1, constant: 0)
    } else {
      top = NSLayoutConstraint(item: weekdaysView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    }
    addConstraint(top)
  }
  
  private func layoutDaysView() {
    daysView.dataSource = self
    daysView.delegate = self

    addSubview(daysView)
    
    daysView.translatesAutoresizingMaskIntoConstraints = false
    
    let leading = NSLayoutConstraint(item: daysView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: daysView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    let top = NSLayoutConstraint(item: daysView, attribute: .top, relatedBy: .equal, toItem: weekdaysView, attribute: .bottom, multiplier: 1, constant: 0)
    
    var bottom: NSLayoutConstraint
    if !DTCalendar.isControlsOnTop && (!DTCalendar.isMonthControlsHidden || !DTCalendar.isDayControlsHidden) {
      bottom = NSLayoutConstraint(item: daysView, attribute: .bottom, relatedBy: .equal, toItem: controlsView, attribute: .top, multiplier: 1, constant: 0)
    } else {
      bottom = NSLayoutConstraint(item: daysView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
    }
    
    addConstraints([leading, trailing, top, bottom])
  }

}

open class DTBadge: UIView {
  
  public enum Style {
    case normal
    case today
    case selected
  }
  
  open func didChangeStyle(_ style: Style) {}
  
}

public class DTCircleBadge: DTBadge {
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 3
  }
  
  override public var intrinsicContentSize: CGSize {
    return CGSize(width: 6, height: 6)
  }
  
  override public func didChangeStyle(_ style: Style) {
    switch style {
    case .normal:
      backgroundColor = DTCalendar.theme.dayBadgeColor
    case .today:
      backgroundColor = DTCalendar.theme.todayBadgeColor
    case .selected:
      backgroundColor = DTCalendar.theme.selectedBadgeColor
    }
  }
  
}

// MARK: - Internal

extension DTCalendar: ControlsViewDataSource {
  
  var shortMonthOfYear: String {
    return selectedDate.shortMonthOfYear
  }
  
  var longMonthOfYear: String {
    return selectedDate.longMonthOfYear
  }

}

extension DTCalendar: DaysViewDataSource {
  
  var numberOfDays: Int {
    return selectedDate.numberOfDaysInMonth
  }
  
  var numberOfOffsets: Int {
    let firstDayOfMonth = selectedDate.firstDayOfMonth!
    let weekday = firstDayOfMonth.weekday!
    return weekday - 1
  }
  
  func date(with day: Int, and offset: Int) -> Date {
   return selectedDate.dayOfMonth(with: day - offset)!
  }
  
  func isSelectedDate(_ date: Date) -> Bool {
    return date.isSameDayOfYear(to: selectedDate)
  }
  
  func badge(with date: Date) -> DTBadge? {
    return dataSource?.calendar(self, badgeForDate: date)
  }
  
}

extension DTCalendar: ControlsViewDelegate {
  
  func didTapPreviousMonth(on view: ControlsView) {
    goPreviousMonth()
  }
  
  func didTapNextMonth(on view: ControlsView) {
    goNextMonth()
  }
  
  func didTapYesterday(on view: ControlsView) {
    goYesterday()
  }
  
  func didTapTomorrow(on view: ControlsView) {
    goTomorrow()
  }
  
  func didTapToday(on view: ControlsView) {
    goToday()
  }

}

extension DTCalendar: DaysViewDelegate {

  func didSelect(date: Date, on daysView: DaysView) {
    selectedDate = date
  }
  
}
