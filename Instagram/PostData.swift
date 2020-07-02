//
//  PostData.swift
//  Instagram
//
//  Created by 伊藤倫 on 2020/06/23.
//  Copyright © 2020 michi.ito. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    
    var id: String
    var name: String?
    var caption: String?
    //課題用
    var CommentTextField: [String] = []
    
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot){
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        self.caption = postDic["caption"] as? String
    
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
      
        //課題用
        if let CommentTextField = postDic["CommentTextField"] as? [String]{
            self.CommentTextField += CommentTextField
        }
        
        if let likes = postDic["likes"] as? [String]{
            self.likes = likes
        }
        
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかチェックすることで、自分が良いねを押しているか判断
            if self.likes.firstIndex(of: myid) != nil{
                //myidがあれば、良いねを押していると認識する
                self.isLiked = true
            }
        }
    }
}

