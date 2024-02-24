//
//  UploadViewController.swift
//  spmKullan
//
//  Created by beyza nur on 16.10.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import Firebase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    var choosenImage=" "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled=true
        let imageRec=UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageRec)
        
        if choosenImage != " "{
            uploadButton.isHidden=true
        }
       
    }
    
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference=storage.reference()
        
        let mediaFolder=storageReference.child("media")
        
        
        if let data=imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid=UUID().uuidString
            
            let imageReference=mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    imageReference.downloadURL{ (url,error) in
                        if error == nil {
                            let imageUrl=url?.absoluteString
                            
                          
                            
                            
                            //DATABASE
                            let fireStoreDatabase=Firestore.firestore()
                            
                            //database verilerini yazmak ,silmek ,okumak için referans
                            var fireStoreReference:DocumentReference? = nil
                            
                            let fireStorePost=["imageUrl" : imageUrl!,
                                               "postedBy": Auth.auth().currentUser?.email!,
                                               "postComment":self.commentText.text!,"date":FieldValue.serverTimestamp() , "likes": 0 ] as [String:Any]
                            
                            fireStoreReference = fireStoreDatabase.collection("Posts").addDocument(data: fireStorePost,completion: { (error) in
                                if error != nil{
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "error")
                                }else{
                                    //başa dönücek feed sayfasına
                                    self.imageView.image=UIImage(named: "select.png")
                                    self.commentText.text=" "
                                    self.tabBarController?.selectedIndex=0
                                }
                            })
                        }
                    }
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    @objc func selectImage(){
        let picker=UIImagePickerController()
        picker.delegate=self
        picker.sourceType = .photoLibrary
        picker.allowsEditing=false
        present(picker,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image=info[.originalImage] as? UIImage  //resim seçiceği kesin olmadığı için ? koyuyoruz
        uploadButton.isEnabled=true
        self.dismiss(animated: true,completion: nil)
    }
   

}
