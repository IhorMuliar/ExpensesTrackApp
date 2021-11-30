//
//  ExpensesCell.swift
//  NoStoryBoardTestApp
//
//  Created by MacBook on 25.11.2021.
//

import UIKit

class ExpensesCell: UITableViewCell {
    var categoryLabel = UILabel()
    var expensesLabel = UILabel()
    var dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        expensesLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        configureCategoryLabelView()
//        configureExpensesLabelView()
//        configureDateLabelView()
        
        contentView.addSubview(expensesLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        
        let views = [
            "category"  : categoryLabel,
            "date" : dateLabel,
            "amount": expensesLabel,
            ]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[amount]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[category]-[date]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[amount]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[category]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[date]|", options: [], metrics: nil, views: views)
        
         NSLayoutConstraint.activate(allConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been inplement")
    }
    
    func configureCategoryLabelView() {
        categoryLabel.numberOfLines = 0
        categoryLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureExpensesLabelView() {
        expensesLabel.numberOfLines = 0
        expensesLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureDateLabelView() {
        dateLabel.numberOfLines = 0
        dateLabel.adjustsFontSizeToFitWidth = true
    }
}
