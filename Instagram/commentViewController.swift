//
//  commentViewController.swift
//  Instagram
//
//  Created by 伊藤倫 on 2020/06/30.
//  Copyright © 2020 michi.ito. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class commentViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextField!
  
    var postData: PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func commentButton(_ sender:Any) {
        
        //投稿データの保存場所を定義する
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        //HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        //FireStoreに投稿データを保存する
        if commentTextField.text! == ""{
            SVProgressHUD.showError(withStatus: "コメントを入力してください。ホームに戻ります。")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            return
        }else{
        //HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
            
        //更新データを作成する
        var updateValue: FieldValue
            
        let name = Auth.auth().currentUser!.displayName!
            let comment = "\(name) : \(commentTextField.text!)"
            
        updateValue = FieldValue.arrayUnion([comment])
        
        postRef.updateData(["CommentTextField": updateValue])
            
        //投稿処理が完了したので先頭に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
   
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
