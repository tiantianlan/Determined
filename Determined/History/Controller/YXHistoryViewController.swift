//
//  YXHistoryViewController.swift
//  Determined
//
//  Created by duoyi on 16/11/29.
//  Copyright © 2016年 duoyi. All rights reserved.
//

import UIKit

let historyCell : String = "historyCell";

class YXHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YXHistoryDataManagerDelegate
{
    override func viewDidLoad()
    {   
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.view.addSubview(tableView);
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        tableView.addSubview(refreshControl);
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        dataManager.requestData();
    }
    
    // MARK: - 懒加载
    
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(YXHistoryViewController.refreshHead), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        return refreshControl;
    }()
    
    private lazy var tableView : UITableView = {
        let rect : CGRect = CGRect(x: 5, y: 0, width: self.view.frame.width - 10, height: self.view.frame.height - 49);
        let tableView = UITableView.init(frame: rect, style: UITableViewStyle.grouped);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 55.0;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        tableView.register(YXHistoryMainCell.classForCoder(), forCellReuseIdentifier: historyCell);
        tableView.sectionHeaderHeight = 5;
        tableView.sectionFooterHeight = 0;
        tableView.backgroundColor = UIColor.white;
        tableView.showsVerticalScrollIndicator = false;
        return tableView;
    }();
    
    private lazy var dataManager : YXHistoryDataManager = {
        let data = YXHistoryDataManager();
        data.delegate = self;
        return data;
    }()
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return dataManager.numOfRow();
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : YXHistoryMainCell = tableView.dequeueReusableCell(withIdentifier: historyCell) as! YXHistoryMainCell;
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        let model = dataManager.modelWithRow(indexPath.section);
        cell.reloadData(model!);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "DELETE", handler: { [weak weakSelf = self](UITableViewRowAction, IndexPath) in
            let model = weakSelf?.dataManager.modelWithRow(indexPath.row);
            if model != nil
            {
                weakSelf?.dataManager.delete(model: model!);
               
            }
           tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: UITableViewRowAnimation.fade);
        })
        deleteAction.backgroundColor = UIColor(hex6: 0xe74c3c)
        return [deleteAction];
    }

    // MARK: - YXHistoryDataManagerDelegate
    func reloadData(_ manager: YXHistoryDataManager)
    {
        self.tableView.reloadData()
    }
    
    // MARK: - Void
    func refreshHead()
    {
        dataManager.refreshData();
        refreshControl.endRefreshing();
    }
}

