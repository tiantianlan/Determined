//
//  YXHistoryViewController.swift
//  Determined
//
//  Created by duoyi on 16/11/29.
//  Copyright © 2016年 duoyi. All rights reserved.
//

import UIKit

let historyCell : String = "historyCell";
class YXHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.view.addSubview(tableView);
    

    }
    private lazy var tableView : UITableView = {
        let rect : CGRect = CGRect(x: 15, y: 0, width: self.view.frame.width - 30, height: self.view.frame.height);
        let tableView = UITableView.init(frame: rect, style: UITableViewStyle.grouped);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 55.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        tableView.register(YXHistoryMainCell.classForCoder(), forCellReuseIdentifier: historyCell);
        tableView.sectionHeaderHeight = 20;
        tableView.sectionFooterHeight = 0;
        tableView.backgroundColor = UIColor.white;
        return tableView;
    }();
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1 ;
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 20;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : YXHistoryMainCell = tableView.dequeueReusableCell(withIdentifier: historyCell) as! YXHistoryMainCell;
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "DELETE", handler: { (UITableViewRowAction, IndexPath) in
            print("hj")
        })
        deleteAction.backgroundColor = UIColor(hex6: 0xe74c3c)
        return [deleteAction];
    }

}

