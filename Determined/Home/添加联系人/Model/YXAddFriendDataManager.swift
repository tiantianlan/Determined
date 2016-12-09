//
//  YXAddFriendDataManager.swift
//  Determined
//
//  Created by duoyi on 16/12/7.
//  Copyright © 2016年 duoyi. All rights reserved.
//

import UIKit
import MagicalRecord

protocol YXAddFriendDataManagerDelegate
{
    // User增加成功
    func addUserSuccess(dataManager : YXAddFriendDataManager);
}

class YXAddFriendDataManager: NSObject
{
    var delegate : YXAddFriendDataManagerDelegate?;
    
//    lazy var item : NSMutableArray = {
//        let array = NSMutableArray();
//        array.addObjects(from: ["Email", "生日", "公司名称", "公司地址"]);
//        return array;
//    }()
//    
//    func numofRow(index : Int) -> String?
//    {
//        if index < item.count
//        {
//            return item[index] as? String;
//        }
//        return nil;
//    }
    
//    func num() -> Int
//    {
//        return item.count;
//    }
    
    func addUser(_ imagePath : String, _ name : String, _ phoneNumber : String,_ birthday : String,_ homeTown : String,_ remark : String)
    {
        let user = User.mr_createEntity();
        user?.uuid = NSUUID().uuidString;
        user?.name = deleteBettwnSpace(name);
        user?.birthday = birthday; // 这里应该是时间搓
        user?.homeTown = deleteBettwnSpace(homeTown);
        user?.remark = deleteBettwnSpace(remark);
        user?.icon = imagePath;
        
        // 根据情况添加组
        let groupTitle = self.firstCharactor(str: (user?.name)!);
        let item = UserGroup.mr_findAllSorted(by: "groupString", ascending: true);
        if (item?.count)! > 0
        {
            for group  in item!
            {
                let group = group as! UserGroup;
                if groupTitle.isEqual(to: group.groupString)
                {
                    // 存在组 修改数据 并保存
                    let array : NSMutableArray = [UserGroup .mr_find(byAttribute: "groupString", withValue: groupTitle)!];
                    let userGroup : UserGroup = array.firstObject as! UserGroup;
                    userGroup.groupItem.add(user!);
                    NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (success, error) in
                        if success
                        {
                            print("增加User :\(user?.name)");
                        }
                        else if ((error) != nil)
                        {
                            print(error.debugDescription);
                        }
                    }
                    return;
                }
            }
        }
       
        // 不存在组 添加组 添加item
        let anewGroup = UserGroup.mr_createEntity();
        anewGroup?.groupString = groupTitle as String;
        anewGroup?.groupItem.add(user!);

        NSManagedObjectContext.mr_default().mr_saveToPersistentStore {[weak weakSelf = self] (success, error) in
            if success
            {
                print("新组增加User : \(groupTitle) \(user?.name)");
                weakSelf?.delegate?.addUserSuccess(dataManager: weakSelf!);
            }
            else if ((error) != nil)
            {
                print(error.debugDescription);
            }
        }
        
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
    
    // 去除两端空格
    func deleteBettwnSpace(_ string : String) -> String
    {
        let whiteSpace = NSCharacterSet.whitespacesAndNewlines;
        return string.trimmingCharacters(in: whiteSpace);
    }
    
}
