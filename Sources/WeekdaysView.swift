//
//  WeekdaysView.swift
//  DTCalendar
//
//  Created by Dan Jiang on 2016/12/24.
//
//

import UIKit

class WeekdaysView: UIView {

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    var previousLabel: UILabel? = nil
    var firstSpaceView: UIView? = nil
    for symbol in Date.shortWeekdaySymbols {
      let spaceView = UIView()
      
      let label = UILabel()
      label.text = symbol.uppercased()
      label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
      label.textColor = DTCalendar.theme.weekdayLabelColor
      label.textAlignment = .center
            
      addSubview(spaceView)
      addSubview(label)
      
      spaceView.translatesAutoresizingMaskIntoConstraints = false
      label.translatesAutoresizingMaskIntoConstraints = false
      
      var spaceLeading: NSLayoutConstraint
      if let previousLabel = previousLabel, let firstSpaceView = firstSpaceView {
        spaceLeading = NSLayoutConstraint(item: spaceView, attribute: .leading, relatedBy: .equal, toItem: previousLabel, attribute: .trailing, multiplier: 1, constant: 0)
        
        let spaceWidth = NSLayoutConstraint(item: spaceView, attribute: .width, relatedBy: .equal, toItem: firstSpaceView, attribute: .width, multiplier: 2, constant: 0)
        let labelWidth = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: previousLabel, attribute: .width, multiplier: 1, constant: 0)
        
        addConstraints([spaceWidth, labelWidth])
      } else {
        spaceLeading = NSLayoutConstraint(item: spaceView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        let spaceWidth = NSLayoutConstraint(item: spaceView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 1)
        
        spaceView.addConstraint(spaceWidth)
        
        firstSpaceView = spaceView
      }
      let spaceCenterY = NSLayoutConstraint(item: spaceView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
      let spaceHeight = NSLayoutConstraint(item: spaceView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 1)
      
      spaceView.addConstraint(spaceHeight)
      
      let labelLeading = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: spaceView, attribute: .trailing, multiplier: 1, constant: 0)
      let labelCenterY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

      addConstraints([spaceLeading, spaceCenterY, labelLeading, labelCenterY])
      
      previousLabel = label
    }
    
    let spaceView = UIView()
    
    addSubview(spaceView)
    
    spaceView.translatesAutoresizingMaskIntoConstraints = false
    
    let spaceHeight = NSLayoutConstraint(item: spaceView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 1)
    let spaceWidth = NSLayoutConstraint(item: spaceView, attribute: .width, relatedBy: .equal, toItem: firstSpaceView!, attribute: .width, multiplier: 1, constant: 0)
    let spaceLeading = NSLayoutConstraint(item: spaceView, attribute: .leading, relatedBy: .equal, toItem: previousLabel!, attribute: .trailing, multiplier: 1, constant: 0)
    let spaceCenterY = NSLayoutConstraint(item: spaceView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    let spaceTrailing = NSLayoutConstraint(item: spaceView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    
    spaceView.addConstraint(spaceHeight)
    addConstraints([spaceWidth, spaceLeading, spaceCenterY, spaceTrailing])
  }

}
