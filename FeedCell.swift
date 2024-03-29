//
//  FeedCell.swift
//  spmKullan
//
//  Created by beyza nur on 18.10.2023.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {

    @IBOutlet weak var usremailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func likeButtonlicked(_ sender: Any) {
        let fireStoreDatabase=Firestore.firestore()
        
        
        if let likeCount=Int(likeLabel.text!){
            
            let likeStore = ["likes" :likeCount+1] as [String:Any]
            
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData( likeStore, merge:true )

        }
    }
}
