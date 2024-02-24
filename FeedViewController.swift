//
//  FeedViewController.swift
//  spmKullan
//
//  Created by beyza nur on 16.10.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray=[String]()
    var userCommentArray=[String]()
    var likeArray=[Int]()
    var userImageArray=[String]()
    var documentIdArray=[String]()




    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate=self
        tableView.dataSource=self

      getDataFromFirestore()
        
    }
    
    
    //databaseden veri çekmek
    func getDataFromFirestore(){
        let fireStoreDatabase=Firestore.firestore()
        
        /*
        let settings=fireStoreDatabase.settings
        settings.prepareForInterfaceBuilder()
        
        fireStoreDatabase.settings=settings */
        //posts.document().collection path faln uzayabilir eger çok klasorumuz varsa o kadar indikt4en sonra add snapshot listener eklenir
        //.order ile istediğimiz şekilde sıralayabiliyoruz
        fireStoreDatabase.collection("Posts").order(by: "date",descending: true)
            .addSnapshotListener { (snapshot, error )in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                //post altındakı dokümanları vericek bi dizi içinde biz de onları loop içinde alıcaz
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy=document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                            if let postComment=document.get("postComment") as? String{
                                self.userCommentArray.append(postComment)
                                if let likes=document.get("likes") as? Int{
                                    self.likeArray.append(likes)
                                    if let imageUrl=document.get("imageUrl") as? String{
                                        self.userImageArray.append(imageUrl)
                                    }
                                }
                            }
                            
                        }
                    }
                    //for loop bittikten sonra
                    self.tableView.reloadData()
                    
                }
            }
        }
        
    }
      
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.usremailLabel.text=userEmailArray[indexPath.row]
        cell.commentLabel.text=userCommentArray[indexPath.row]
        cell.likeLabel.text=String(likeArray[indexPath.row])
        //sdwebimages i projeme ekledim paketlerden (github linki)
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text=documentIdArray[indexPath.row]
        
        return cell

    }
    
   
    //feed de üst üste durmasınlar diye
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    //listen for realtime updates

 
    

  

}
