//
//  WeekDayTableViewCell.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit

class WeekDayTableViewCell: UITableViewCell {
    
    @IBOutlet var weatherDataViews: [UIView]! {
        didSet {
            for view in weatherDataViews {
                view.isHidden = true
            }
        }
    }
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = .black
            dateLabel.font = .smallFont
        }
    }
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.tintColor = .base
        }
    }
    @IBOutlet var dayLabel: UILabel! {
            didSet {
        dayLabel.textColor = .base
        dayLabel.font = .regularFont
        }
    }
    @IBOutlet var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.textColor = .black
            temperatureLabel.font = .smallFont
        }
    }
    @IBOutlet var windSpeedLabel: UILabel!
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(with representable: WeekDayRepresentable, count: Int) {
        if count == 0 {
            dayLabel.text = "Today"
        } else {
            dayLabel.text = representable.day
        }
        dateLabel.text = representable.date
        iconImageView.image = representable.image
        windSpeedLabel.text = representable.windSpeed
        temperatureLabel.text = representable.temperature
    }

}
