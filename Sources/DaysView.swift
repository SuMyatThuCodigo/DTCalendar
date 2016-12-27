//
//  DaysView.swift
//  DTCalendar
//
//  Created by Dan Jiang on 2016/12/24.
//
//

import UIKit

protocol DaysViewDataSource {
  var numberOfDays: Int { get }
  var numberOfOffsets: Int { get }
  func date(with day: Int, and offset: Int) -> Date
  func isSelectedDate(_ date: Date) -> Bool
  func badge(with date: Date) -> DTBadge?
}

protocol DaysViewDelegate {
  func didSelect(date: Date, on daysView: DaysView)
}

class DaysView: UIView {
  
  var dataSource: DaysViewDataSource?
  var delegate: DaysViewDelegate?
  
  fileprivate let space: CGFloat = 1
  fileprivate var dayViews = [DayView]()
  
  // MARK: - Actions
  
  func reloadDays() {
    guard let dataSource = dataSource else {
      return
    }
    
    for dayView in dayViews {
      dayView.removeFromSuperview()
    }
    dayViews.removeAll()
    
    let numberOfDays = dataSource.numberOfDays
    let numberOfOffsets = dataSource.numberOfOffsets
    let total = numberOfDays + numberOfOffsets
    
    var firstDayView: UIView? = nil
    var previousDayView: UIView? = nil
    var topDayView: UIView? = nil
    
    for day in 1...total {
      let dayView: DayView
      
      if day <= numberOfOffsets {
        dayView = DayView()
      } else {
        let date = dataSource.date(with: day, and: numberOfOffsets)
        dayView = DayView(date: date)
      }
      dayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDayView(recognizer:))))
      
      dayViews.append(dayView)
      addSubview(dayView)
      
      dayView.translatesAutoresizingMaskIntoConstraints = false
      
      let dayHeight = NSLayoutConstraint(item: dayView, attribute: .height, relatedBy: .equal, toItem: dayView, attribute: .width, multiplier: 1, constant: 0)
      addConstraint(dayHeight)
      
      if let firstDayView = firstDayView {
        let dayWidth = NSLayoutConstraint(item: dayView, attribute: .width, relatedBy: .equal, toItem: firstDayView, attribute: .width, multiplier: 1, constant: 0)
        addConstraint(dayWidth)
      } else {
        firstDayView = dayView
      }
      
      if let previousDayView = previousDayView {
        let dayLeading = NSLayoutConstraint(item: dayView, attribute: .leading, relatedBy: .equal, toItem: previousDayView, attribute: .trailing, multiplier: 1, constant: space * 2)
        addConstraint(dayLeading)
      } else {
        let dayLeading = NSLayoutConstraint(item: dayView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: space)
        addConstraint(dayLeading)
      }
      
      if let topDayView = topDayView {
        let dayTop = NSLayoutConstraint(item: dayView, attribute: .top, relatedBy: .equal, toItem: topDayView, attribute: .bottom, multiplier: 1, constant: space * 2)
        addConstraint(dayTop)
      } else {
        let dayTop = NSLayoutConstraint(item: dayView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(dayTop)
      }
      
      if day == total {
        let dayBottom = NSLayoutConstraint(item: dayView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -space * 2)
        addConstraint(dayBottom)
      }
      
      if day % 7 == 0 {
        let dayTrailing = NSLayoutConstraint(item: dayView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -space)
        addConstraint(dayTrailing)
        
        previousDayView = nil
        topDayView = dayView
      } else {
        previousDayView = dayView
      }
    }
  }
  
  func reloadDatas() {
    for dayView in dayViews {
      if let date = dayView.date {
        reloadDayView(dayView, with: date)
      }
    }
  }
  
  func reloadData(with date: Date) {
    for dayView in dayViews {
      if let eachDate = dayView.date {
        if eachDate.isSameDayOfYear(to: date) {
          reloadDayView(dayView, with: date)
          break
        }
      }
    }
  }
  
  func tapDayView(recognizer: UIGestureRecognizer) {
    guard let dayView = recognizer.view as? DayView,
      let date = dayView.date else {
      return
    }
    delegate?.didSelect(date: date, on: self)
  }
  
  // MARK: - Private
  
  fileprivate func reloadDayView(_ dayView: DayView, with date: Date) {
    guard let dataSource = dataSource else {
      return
    }
    
    dayView.badge = dataSource.badge(with: date)

    if dataSource.isSelectedDate(date) {
      dayView.style = .selected
    } else if date.isSameDayOfYear(to: Date()) {
      dayView.style = .today
    } else {
      dayView.style = .normal
    }
  }

}

class DayView: UIView {
  
  let date: Date?
  
  private let label = UILabel()
  private let highlightView = HighlightView()
  
  var badge: DTBadge? {
    didSet {
      oldValue?.removeFromSuperview()
      if let badge = badge {
        addSubview(badge)
        
        badge.translatesAutoresizingMaskIntoConstraints = false
        
        let badgeCenterX = NSLayoutConstraint(item: badge, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let badgeCenterY = NSLayoutConstraint(item: badge, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.5, constant: 0)
        
        addConstraints([badgeCenterX, badgeCenterY])
      }
    }
  }
  
  var style: DTBadge.Style = .normal {
    didSet {
      switch style {
      case .normal:
        highlightView.highlightColor = DTCalendar.theme.dayHighlightColor
        label.textColor = DTCalendar.theme.dayLabelColor
      case .today:
        highlightView.highlightColor = DTCalendar.theme.todayHighlightColor
        label.textColor = DTCalendar.theme.todayLabelColor
      case .selected:
        highlightView.highlightColor = DTCalendar.theme.selectedHighlightColor
        label.textColor = DTCalendar.theme.selectedLabelColor
      }
      badge?.didChangeStyle(style)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(date: Date? = nil) {
    self.date = date
    
    super.init(frame: .zero)
    
    guard let date = date else {
      return
    }
    
    addSubview(highlightView)
    
    highlightView.translatesAutoresizingMaskIntoConstraints = false
    
    let highlightLeading = NSLayoutConstraint(item: highlightView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    let highlightTrailing = NSLayoutConstraint(item: highlightView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    let highlightTop = NSLayoutConstraint(item: highlightView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    let highlightBottom = NSLayoutConstraint(item: highlightView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)

    addConstraints([highlightLeading, highlightTrailing, highlightTop, highlightBottom])

    label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
    label.text = date.shortDayOfMonth

    addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let labelCenterX = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
    let labelCenterY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    addConstraints([labelCenterX, labelCenterY])
  }
  
}

class HighlightView: UIView {
  
  var highlightColor = UIColor() {
    didSet {
      setNeedsDisplay()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = DTCalendar.theme.backgroundColor
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    
    context.setFillColor(highlightColor.cgColor)
    context.setStrokeColor(highlightColor.cgColor)
    context.setLineWidth(2)
    
    switch DTCalendar.highlight {
    case .rectFill:
      context.fill(rect)
    case .rectStroke:
      context.stroke(rect.insetBy(dx: 1, dy: 1))
    case .ovalFill:
      context.fillEllipse(in: rect.insetBy(dx: 2, dy: 2))
    case .ovalStroke:
      context.strokeEllipse(in: rect.insetBy(dx: 2, dy: 2))
    }
  }
  
}
