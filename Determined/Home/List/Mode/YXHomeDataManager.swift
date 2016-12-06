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

class YXHomeDataManager: NSObject
{

    func requestData() -> Void
    {
        let array = [UserGroup.mr_findAllSorted(by: "groupString", ascending: true)];
        item.removeAllObjects();
        for i in array[0]!
        {
            item.add(i);
            let group : UserGroup = i as! UserGroup; 
            itemTitle.add(group.groupString!);
        }
        
    }
    
    // 增加删除数据后 对数据进行排序
    func sotrData()
    {
        // 排item
        item.sort(comparator: { (obj1, obj2) -> ComparisonResult in
            let obj1 = obj1 as! UserGroup;
            let obj2 = obj2 as! UserGroup;
            return (obj1.groupString?.compare(obj2.groupString!))!;
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
            return (array.groupItem[indexPath.row] as! User);
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
                let i = i as! User;
                if  i == user
                {
                    group.groupItem.remove(user);
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
                itemTitle.remove(group.groupString!);
            }
        }
    }
    
    // 添加数据和title 返回section Index
    func addModel(user : User) -> (Int, String)
    {
        // 判断属于哪一组
        let groupTitle = self.firstCharactor(str: user.name!);
        // 组存在和不存在
        for group in item
        {
            let group = group as! UserGroup;
            if groupTitle.isEqual(group.groupString)
            {
                // 存在 添加进item,添加进coreData
                group.groupItem.add(user);
                self.sotrData();
                NSManagedObjectContext.mr_default().mr_save(blockAndWait: { (cxt) in
                    print("保存完成 \(user.name)");
                })
                self.sotrData();
                return (item.index(of: group), "row");
            }
        }
        // 不存在 添加组，添加item,添加coreData
        let group = UserGroup.mr_createEntity();
        group?.groupString = groupTitle as String;
        group?.groupItem.add(user);

        itemTitle.add(group?.groupString! as Any);
        NSManagedObjectContext.mr_default().mr_save(blockAndWait: { (cxt) in
            print("保存完成 \(user.name)");
        })
        item.add(group!);
        self.sotrData();
        return (item.index(of: group!), "section");
    }
    
    // 获取首字母
    func firstCharactor( str : String) -> NSString
    {
        let s = NSMutableString(string: str) as CFMutableString;
        CFStringTransform(s, nil, kCFStringTransformMandarinLatin, false);
        //再转换为不带声调的拼音
        CFStringTransform(s, nil, kCFStringTransformStripDiacritics, false);
        //转化为大写拼音
        let  pinYin : NSString = s as NSString;
        //获取并返回首字母
        return (pinYin.substring(to: 1) as NSString).uppercased as NSString;
    }
}
