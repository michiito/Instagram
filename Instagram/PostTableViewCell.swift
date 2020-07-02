//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 伊藤倫 on 2020/06/23.
//  Copyright © 2020 michi.ito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        //画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //コメントラベルの表示
        var comments = ""
        for comment in postData.CommentTextField {
           
            print(comment)
            comments += "\(comment)\n"
            
        print(comments)
            
        }
        self.commentLabel.text = "\(comments)"
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH;mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        //いいねの数
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }else{
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
    

    
    
    
}
