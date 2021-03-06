//
//  YXAddHometownTableViewCell.swift
//  Determined
//
//  Created by duoyi on 16/12/8.
//  Copyright © 2016年 duoyi. All rights reserved.
//

import UIKit

typealias home = (_ homeValue : String) -> Void;

class YXAddHometownTableViewCell: UITableViewCell
{
    var ht : home?;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.init(hex6: 0xecf0f1);
        self.contentView.addSubview(titleField);
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: .UITextFieldTextDidChange, object: nil);
        self.addLayout();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleField : YXTextField = {
        let field = YXTextField();
        field.placeholder = "家乡";
//        field.layer.borderColor = UIColor.init(hex6: 0xebebeb).cgColor;
        field.backgroundColor = UIColor.white;
//        field.layer.borderWidth = 1;
        return field;
    }()
    
    func addLayout()
    {
        titleField.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.height.equalTo(50);
            make.left.equalTo(self.contentView).offset(25);
            make.right.equalTo(self.contentView).offset(-25);
        }
    }
    func change()
    {
        ht!(titleField.text!);
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self);
    }

}
