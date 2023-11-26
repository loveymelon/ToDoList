//
//  WeekendCollectionViewCell.swift
//  ToDoList
//
//  Created by 김진수 on 2023/10/19.
//

import UIKit

class WeekendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        circleViewSetting()
    }
    
    func circleViewSetting() {
        let circleViewSize = min(circleView.bounds.width, circleView.bounds.height)
        circleView.bounds.size = CGSize(width: circleViewSize, height: circleViewSize)
        let cornerRadius = circleView.bounds.height / 2
        circleView.layer.cornerRadius = cornerRadius
        circleView.clipsToBounds = true
    }
    
    func update(status: Bool?) {
        if let status = status,
           status {
            self.backView.backgroundColor = .gray
        } else {
            self.backView.backgroundColor = .white
        }
    }

}
