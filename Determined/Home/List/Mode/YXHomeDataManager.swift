//
//  YXHomeDataManager.swift
//  Determined
//
//  Created by duoyi on 16/11/29.
//  Copyright © 2016年 duoyi. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import MagicalRecord 

protocol YXHomeDataManagerDelegate
{
    func loadDataSuccess(dataManager : YXHomeDataManager);
}

class YXHomeDataManager: NSObject
{
    var delegate : YXHomeDataManagerDelegate?;
    
    func requestData() -> Void
    {

        let array = UserGroup.mr_findAllSorted(by: "groupString", ascending: true);

        item.removeAllObjects();
        itemTitle.removeAllObjects();
        
        for i in array!
        {
            let group = i as! UserGroup;
            if group.groupItem.count != 0 && group.groupString.characters.count != 0
            {
                item.add(i);
                
                itemTitle.add(group.groupString as Any);
            }

        }
        self.delegate?.loadDataSuccess(dataManager: self);
    }
    
    // 增加删除数据后 对数据进行排序
    func sotrData()
    {
        // 排item
        item.sort(comparator: { (obj1, obj2) -> ComparisonResult in
            let obj1 = obj1 as! UserGroup;
            let obj2 = obj2 as! UserGroup;
            return (obj1.groupString.compare(obj2.groupString));
        })
    
        // 排title
        itemTitle.sort(comparator: { (obj1, obj2) -> ComparisonResult in
            let obj1 = obj1 as! String;
            let obj2 = obj2 as! String;
            return obj1.compare(obj2);
        })
    }
    
    public lazy var item : NSMutableArray = {
        let array = NSMutableArray();
        return array;
    }()
    
    // 返回总共组数
    func numOfSection() -> Int {
        return item.count;
    }
    
    // 返回每组数据
    func rowOfSection(_ section : Int) -> Int {

        if  section < item.count
        {
            let array : UserGroup = item[section] as! UserGroup;
            return (array.groupItem.count);
        }
        else
        {
            return 0;
        }
    }
    
    // 返回model
    func modelWithIndexPath(indexPath : IndexPath) -> User? {
        if  indexPath.section < item.count
        {
            let array : UserGroup = item[indexPath.section] as! UserGroup;
            // 这里不是存的model了
            let uuid : String = array.groupItem[indexPath.row] as! String;
            let userArray = User.mr_find(byAttribute: "uuid", withValue: uuid)! ;
            return userArray[0] as? User;
        }
        return nil;
    }
    
    // 返回右边索引
    public lazy var itemTitle : NSMutableArray = {
        let array = NSMutableArray();
        return array;
    }()
    
    // 删除数据 返回组内还有多少数组
    func remove(user : User) -> UserGroup?
    {
        // 删除model
        for group in item
        {
            let group = group as! UserGroup;
            for i in group.groupItem
            {
                // 找到这个user
                let i = i as! String;
                if  i == user.uuid
                {
                    group.groupItem.remove(i);
                    // 删除实体
                    user.mr_deleteEntity();
                    return group;
                }
            }
        }
        return nil ;
    }
    
    // 删除组和title
    func deleteSection(group : UserGroup) -> Void
    {
        for gr in item
        {
            let gr = gr as! UserGroup;
            if gr == group
            {
                item.remove(group);
                itemTitle.remove(group.groupString);
                group.mr_deleteEntity();
            }
        }
    }
}
