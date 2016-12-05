//
//  YXHistoryMainCell.swift
//  Determined
//
//  Created by duoyi on 16/12/1.
//  Copyright © 2016年 duoyi. All rights reserved.
//

import UIKit

class YXHistoryMainCell: UITableViewCell
{

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.contentView.backgroundColor = UIColor.init(hex6: 0xEBF4F5);
        self.contentView.layer.cornerRadius = 2;
        self.contentView.clipsToBounds = true;
        self.contentView.addSubview(timeLabel);
        self.contentView.addSubview(nameLabel);
        self.contentView.addSubview(iconView);
        self.addLayout();
    }
    
    // MARK: - 懒加载
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var timeLabel : UILabel = {
            let timeLabel = UILabel();
            timeLabel.text = "2016年12月1日 19:45 星期四";
            timeLabel.font = UIFont(name: "SourceHanSansCN-Light", size: 14);
            timeLabel.textColor = UIColor(hex6: 0x888888);
            return timeLabel;
    }()
    
    private lazy var nameLabel : UILabel = {
        let nameLabel = UILabel();
        nameLabel.text = "天天天蓝";
        nameLabel.font = UIFont(name: "SourceHanSansCN-Light", size: 20);
        nameLabel.textColor = UIColor(hex6: 0x2c2c2c);
        return nameLabel;
    }()
    
    private lazy var iconView : UIImageView =
        {
            let iconView = UIImageView();
            iconView.image = #imageLiteral(resourceName: "qq_space");
            return iconView;
    }()
    
    func addLayout() -> Void
    {
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(14);
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-14);
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel);
            make.top.equalTo(timeLabel.snp.bottom).offset(15);
            make.right.equalTo(timeLabel);
            make.bottom.equalTo(self.contentView).offset(-14);
            
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-14);
            make.width.height.equalTo(16);
        }
    }
    
    

}