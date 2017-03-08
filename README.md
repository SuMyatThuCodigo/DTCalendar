# DTCalendar

[![Swift](https://img.shields.io/badge/Swift-3.0-ff3f26.svg?style=flat)](https://swift.org/)
[![Platform](https://img.shields.io/cocoapods/p/DTCalendar.svg?style=flat)](http://cocoadocs.org/docsets/DTCalendar)
[![CocoaPods](http://img.shields.io/cocoapods/v/DTCalendar.svg)](https://cocoapods.org/pods/DTCalendar)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Introduction

Simple calendar control.

![Demo](Demo.gif)

Full controls.

![Full controls](rect_fill.jpg)

Hide day controls.

![Hide day controls](hide_day_controls.jpg)

Hide month controls.

![Hide month controls](hide_month_controls.jpg)

Hide both controls.

![Hide both controls](hide_both_controls.jpg)

Highlight is rect fill.

![Rect fill](rect_fill.jpg)

Highlight is rect stroke.

![Rect stroke](rect_stroke.jpg)

Highlight is oval fill.

![Oval fill](oval_fill.jpg)

Highlight is oval stroke.

![Oval stroke](oval_stroke.jpg)

Customize badge with emoji.

![Emoji badge](emoji_badge.jpg)

## Installation

### Requirement

iOS 8.4+

### [CocoaPods](http://cocoapods.org)

To install DTCalendar add a dependency to your Podfile:

```
pod "DTCalendar"
```

### [Carthage](https://github.com/Carthage/Carthage)

To install DTCalendar add a dependency to your Cartfile:

```
github "danjiang/DTCalendar"
```

```
carthage update --platform ios
```

## Usage

### Import

```swift
import DTCalendar
```

### Use

```swift
class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  
  fileprivate let formatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.timeStyle = .none
    formatter.dateStyle = .full
    label.text = formatter.string(from: Date())
    
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
  
  func calendar(_ calendar: DTCalendar, badgeForDate date: Date) -> DTBadge? {
    let dateComponents = Calendar.current.dateComponents([.weekday], from: date)
    if let weekday = dateComponents.weekday {
      if weekday == 2 || weekday == 4 || weekday == 6 {
        return DTCircleBadge()
      }
    }
    return nil
  }
  
}

extension ViewController: DTCalendarDelegate {
  
  func calendar(_ calendar: DTCalendar, didSelectedDate date: Date, isDifferentMonth: Bool) {
    label.text = formatter.string(from: date)
    if isDifferentMonth {
      calendar.reloadBadges()
    }
  }
  
}
```

### Customize

#### Controls

```swift
DTCalendar.isMonthControlsHidden = true // Hide month controls
DTCalendar.isDayControlsHidden = true // Hide day controls

// Write your own controls. Control calendar through following public methods:

public func goPreviousMonth()
public func goNextMonth()
public func goYesterday()
public func goTomorrow()
public func goToday()
public func goDate(_ date: Date)
```

#### Highlight

```swift
DTCalendar.highlight = .rectFill // Rect Fill is default highlight
DTCalendar.highlight = .rectStroke
DTCalendar.highlight = .ovalFill
DTCalendar.highlight = .ovalStroke
```

#### Theme

```swift
struct MyTheme: DTCalendarTheme {
  
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

DTCalendar.theme = MyTheme()
```

#### Badge

```swift
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

extension ViewController: DTCalendarDataSource {
  
  func calendar(_ calendar: DTCalendar, badgeForDate date: Date) -> DTBadge? {
    let dateComponents = Calendar.current.dateComponents([.weekday], from: date)
    if let weekday = dateComponents.weekday {
      if weekday == 2 || weekday == 4 || weekday == 6 {
        let badge = EmojiBadge()
        badge.label.text = "⭐️"
        return badge
      }
    }
    return nil
  }
  
}

extension ViewController: DTCalendarDelegate {
  
  func calendar(_ calendar: DTCalendar, didSelectedDate date: Date, isDifferentMonth: Bool) {
    label.text = formatter.string(from: date)
    if isDifferentMonth {
      calendar.reloadBadges()
    }
  }
  
}
```