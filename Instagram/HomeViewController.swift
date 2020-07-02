//
//  HomeViewController.swift
//  Instagram
//
//  Created by 伊藤倫 on 2020/06/20.
//  Copyright © 2020 michi.ito. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray: [PostData] = []
    
    //Firestoreのリスナー
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            //ログイン済み
            if listener == nil {
                //listener未登録なら、登録してスナップショットを受信する
                print(1)
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error)in
                    
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    //取得したdocumentをもとにPostDataを作成し、postArrayの配列にする
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT:document取得\(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    //TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        }else{
            //ログイン未（またはログアウト済）
            if listener != nil {
                //listener登録済なら削除してPostArrayをクリアする
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        //課題用　コメントボタンのアクションを設定
        cell.comment.addTarget(self, action:#selector(commentButton(_:forEvent:)), for: .touchUpInside)
        
        
       
        return  cell
    }
    //課題用　コメントボタンのアクション
    @objc func commentButton(_ sender: UIButton, forEvent event:UIEvent){
        print("DEBUG_PRINT: コメントボタンがタップされました。")
       
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "comment") as! commentViewController
        commentViewController.postData = postData
        self.present(commentViewController, animated: true, completion: nil)
        
    }
    
    
    @objc func handleButton(_ sender:UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            }else{
                //今回新たにいいねをしている場合は、いいね解除のためmyidを通りのぞく更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    
}
