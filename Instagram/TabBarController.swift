//
//  TabBarController.swift
//  Instagram
//
//  Created by 伊藤倫 on 2020/06/20.
//  Copyright © 2020 michi.ito. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

       //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        //UITabBarControllerDelegateぷrことるのメゾットをこのクラスで処理する
        self.delegate = self
    }
    //タブバーのアイコンがタップされた時に呼ばれるdelegateメゾットを処理する
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageViewController {
            //ImageSelectViewControllerは、タブ切り替えではなくモーダル画面転移する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "Image")
            present(imageSelectViewController, animated: true)
            return false
        }else {
            //その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil{
            //ログインしていない時の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
            
        }
    }

}
