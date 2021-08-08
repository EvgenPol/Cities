//
//  CityViewCell.swift
//  Cities
//
//  Created by Евгений Полюбин on 07.08.2021.
//

import UIKit

class CityViewCell: UITableViewCell {
    weak var tempLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let tempLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        tempLabel.textColor = UIColor.blue
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        
        self.tempLabel = tempLabel
        self.accessoryView = tempLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
