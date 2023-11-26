//
//  TodoTableViewCell.swift
//  ToDoList
//
//  Created by 김진수 on 2023/10/22.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var timeVIew: UIView!
    @IBOutlet weak var todoView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkLabel: UILabel!
    
    var checkBool: Bool = false
    
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func todoTableCellSetting() {
        checkLabel.text = "완"
    }
    
    func checkLabelAddGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedCheckLabel))
        checkLabel.isUserInteractionEnabled = true
        checkLabel.addGestureRecognizer(gesture)
    }
    
    @objc func tappedCheckLabel() {
        
        checkLabel.textColor = .green
        checkBool.toggle()
        
        if checkBool {
            checkLabel.text = "완"
        } else {
            checkLabel.text = ""
        }
        
    }
}
