//
//  ControlsView.swift
//  DTCalendar
//
//  Created by Dan Jiang on 2016/12/24.
//
//

import UIKit

protocol ControlsViewDataSource {
  var shortMonthOfYear: String { get }
  var longMonthOfYear: String { get }
}

protocol ControlsViewDelegate {
  func didTapPreviousMonth(on view: ControlsView)
  func didTapNextMonth(on view: ControlsView)
  func didTapYesterday(on view: ControlsView)
  func didTapTomorrow(on view: ControlsView)
  func didTapToday(on view: ControlsView)
}

class ControlsView: UIView {

  var dataSource: ControlsViewDataSource?
  var delegate: ControlsViewDelegate?

  fileprivate let monthButton =  UIButton()

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    if !DTCalendar.isMonthControlsHidden {
      layoutPreviousMonthButton()
      layoutMonthButton()
      layoutNextMonthButton()
    }
    if !DTCalendar.isDayControlsHidden {
      layoutYesterdayButton()
      layoutTodayButton()
      layoutTomorrowButton()
    }
  }
  
  // MARK: - Private
  
  fileprivate func layoutPreviousMonthButton() {
    let previousMonthButton = UIButton()
    previousMonthButton.tintColor = DTCalendar.theme.controlsColor
    previousMonthButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    previousMonthButton.setImage(DTCalendar.imageWithName("left-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
    previousMonthButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
    
    addSubview(previousMonthButton)
    
    previousMonthButton.translatesAutoresizingMaskIntoConstraints = false
    
    let leading = NSLayoutConstraint(item: previousMonthButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    let centerY = NSLayoutConstraint(item: previousMonthButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

    addConstraints([leading, centerY])
  }
  
  fileprivate func layoutMonthButton() {
    monthButton.addTarget(self, action: #selector(month), for: .touchUpInside)
    
    addSubview(monthButton)
    
    monthButton.translatesAutoresizingMaskIntoConstraints = false

    let multiplier: CGFloat = DTCalendar.isDayControlsHidden ? 1 : 0.5
    let centerX = NSLayoutConstraint(item: monthButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: multiplier, constant: 0)
    let centerY = NSLayoutConstraint(item: monthButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    addConstraints([centerX, centerY])
  }
  
  fileprivate func layoutNextMonthButton() {
    let nextMonthButton = UIButton()
    nextMonthButton.tintColor = DTCalendar.theme.controlsColor
    nextMonthButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    nextMonthButton.setImage(DTCalendar.imageWithName("right-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
    nextMonthButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
    
    addSubview(nextMonthButton)
    
    nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
    
    let attribute: NSLayoutAttribute = DTCalendar.isDayControlsHidden ? .trailing : .centerX
    let trailing = NSLayoutConstraint(item: nextMonthButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
    let centerY = NSLayoutConstraint(item: nextMonthButton, attribute:.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    addConstraints([trailing, centerY])
  }
  
  fileprivate func layoutYesterdayButton() {
    let yesterdayButton = UIButton()
    yesterdayButton.tintColor = DTCalendar.theme.controlsColor
    yesterdayButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    yesterdayButton.setImage(DTCalendar.imageWithName("left-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
    yesterdayButton.addTarget(self, action: #selector(yesterday), for: .touchUpInside)
    
    addSubview(yesterdayButton)
    
    yesterdayButton.translatesAutoresizingMaskIntoConstraints = false
    
    let attribute: NSLayoutAttribute = DTCalendar.isMonthControlsHidden ? .leading : .centerX
    let leading = NSLayoutConstraint(item: yesterdayButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
    let centerY = NSLayoutConstraint(item: yesterdayButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    addConstraints([leading, centerY])
  }
  
  fileprivate func layoutTodayButton() {
    let todayButton = UIButton()
    todayButton.setAttributedTitle(buttonTitle(with: Date.todaySymbol), for: .normal)
    todayButton.addTarget(self, action: #selector(today), for: .touchUpInside)

    addSubview(todayButton)
    
    todayButton.translatesAutoresizingMaskIntoConstraints = false
    
    let multiplier: CGFloat = DTCalendar.isMonthControlsHidden ? 1 : 1.5
    let centerX = NSLayoutConstraint(item: todayButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: multiplier, constant: 0)
    let centerY = NSLayoutConstraint(item: todayButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    addConstraints([centerX, centerY])
  }
  
  fileprivate func layoutTomorrowButton() {
    let tomorrowButton = UIButton()
    tomorrowButton.tintColor = DTCalendar.theme.controlsColor
    tomorrowButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    tomorrowButton.setImage(DTCalendar.imageWithName("right-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
    tomorrowButton.addTarget(self, action: #selector(tomorrow), for: .touchUpInside)
    
    addSubview(tomorrowButton)
    
    tomorrowButton.translatesAutoresizingMaskIntoConstraints = false
    
    let trailing = NSLayoutConstraint(item: tomorrowButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    let centerY = NSLayoutConstraint(item: tomorrowButton, attribute:.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    addConstraints([trailing, centerY])
  }

  fileprivate func buttonTitle(with text: String) -> NSAttributedString {
    return NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: DTCalendar.theme.controlsColor,
                                                  NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)])
  }
  
  // MARK: - Actions
  
  func reloadMonthButtonTitle() {
    guard let dataSource = dataSource else {
      return
    }
    if !DTCalendar.isMonthControlsHidden {
      let monthOfYear = DTCalendar.isDayControlsHidden ? dataSource.longMonthOfYear : dataSource.shortMonthOfYear
      monthButton.setAttributedTitle(buttonTitle(with: monthOfYear), for: .normal)
    }
  }
  
  func previousMonth() {
    delegate?.didTapPreviousMonth(on: self)
  }
  
  func nextMonth() {
    delegate?.didTapNextMonth(on: self)
  }
  
  func month() {
    // TODO: Choose year and month quickly
  }
  
  func yesterday() {
    delegate?.didTapYesterday(on: self)
  }
  
  func tomorrow() {
    delegate?.didTapTomorrow(on: self)
  }
  
  func today() {
    delegate?.didTapToday(on: self)
  }
  
}
