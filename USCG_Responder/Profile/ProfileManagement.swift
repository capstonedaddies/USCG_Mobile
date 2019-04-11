//
//  ProfileManagement.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 4/8/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ProfileManagement:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emergencyContact: UITextField!
    @IBOutlet weak var emergencyNumber: UITextField!
    @IBOutlet weak var vesselNo: UITextField!
    @IBOutlet weak var medicalNotes: UITextView!
    
    var user = Dictionary<String,Any>()
    let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child((Auth.auth().currentUser?.uid)!)
    var imagePicker = UIImagePickerController()
    var isDiffImage = false
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        
        //Fields cant be change these
        self.firstName.isEnabled = false
        self.lastName.isEnabled = false
        self.dob.isEnabled = false
        
        ref.observe(.value, with:{ (snapshot: DataSnapshot) in
            let queryResult = snapshot.valueInExportFormat()
            print(queryResult!)
            let maybe = queryResult as? Dictionary<String,Any>
            
            //Populate textviews
            self.firstName.text = maybe!["First Name"] as? String
            self.lastName.text = maybe!["Last Name"] as? String
            self.dob.text = maybe!["DOB"] as? String
            self.address.text = maybe!["Address"] as? String
            self.email.text = maybe!["Email"] as? String
            self.emergencyContact.text = maybe!["Emergency Contact Name"] as? String
            self.emergencyNumber.text = maybe!["Emergency Contact Phone"] as? String
            self.vesselNo.text = maybe!["Vessel No"] as? String
            self.medicalNotes.text = maybe!["Medical Notes"] as? String
            
            
            //load profile image
            let imageUrlString = maybe!["Photo"] as! String
            let imageUrl:URL = URL(string: imageUrlString)!
            print(imageUrl)
            let data = try? Data(contentsOf: imageUrl)
            
            self.profileImage.image = UIImage(data:data!)
            self.profileImage.contentMode = UIViewContentMode.scaleAspectFit
            self.user = maybe!
        })
    }

    
    @IBAction func savePressed(_ sender: Any) {
        if address.text == nil || email.text == nil || emergencyContact.text == nil ||
            emergencyNumber.text == nil || vesselNo.text == nil{
            
            messageNote(errorMessage: "No empty fields", title: "Error!")
        }else{
            //Changes email in RT-DB and Auth Email
            if email.text != self.user["Email"] as? String{
               Auth.auth().currentUser?.updateEmail(to: email.text as! String, completion: nil)
               self.user["Email"] = email.text
            }
            
            // when photo updates
            if isDiffImage{
                let userID = Auth.auth().currentUser?.uid
                self.uploadImage(uid: userID!, image: profileImage.image!, completionBlock: {[weak self] (fileURL, error) in
                    guard let strongSelf = self else{
                        return
                    }
                    print(fileURL ?? "NO FILE URL||NO BUENO")
                    self!.user["Photo"] = fileURL?.absoluteString
                    self!.user["Address"] = self!.address.text
                    self!.user["Emergency Contact Name"] = self!.emergencyContact.text
                    self!.user["Emergency Contact Phone"] = self!.emergencyNumber.text
                    self!.user["Medical Notes"] = self!.medicalNotes.text
                    self!.user["Vessel No"] = self!.vesselNo.text
                    
                    self!.ref.setValue(self!.user)
                    
                    self!.messageNote(errorMessage: "Profile Updated.", title: "Confirmed")
                    
                    self!.isDiffImage = false
                })
                
            }else{
                self.user["Address"] = self.address.text
                self.user["Emergency Contact Name"] = self.emergencyContact.text
                self.user["Emergency Contact Phone"] = self.emergencyNumber.text
                self.user["Medical Notes"] = self.medicalNotes.text
                self.user["Vessel No"] = self.vesselNo.text
                
                self.ref.setValue(self.user)
                
                
                messageNote(errorMessage: "Profile Updated.", title: "Confirmed")
                
                
            }
        }
    }
    @IBAction func addPicturePressed(_ sender: Any) {
        //delete old photo and add new photo, upload, get download URL
        let alert = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
        
        let takePicAction = UIAlertAction(title: "Take Photo", style: .default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true, completion: nil)
            }
        }
        let libraryAction = UIAlertAction(title: "Select Photo", style: .default) { (action) -> Void in
            //launch library to get photo
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            self.present(self.imagePicker,animated: true, completion: nil)
            
        }
        
        alert.addAction(takePicAction)
        alert.addAction(libraryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let temp = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.profileImage.image = temp!
        isDiffImage = true
        imagePicker.dismiss(animated: true, completion: nil)

        
    }
    
    func messageNote(errorMessage:String, title:String){
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        
        present(alertController,animated: true,completion: nil)
    }
    
    func uploadImage(uid: String, image: UIImage,completionBlock: @escaping (_ url: URL?, _ error: String?)-> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userImageRef = storageRef.child("images/\(uid).jpg")
        if let imageData = UIImageJPEGRepresentation(image, 0.2){
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = userImageRef.putData(imageData , metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata{
                    userImageRef.downloadURL{(url, error) in
                        guard let downloadURL = url else{
                            return
                        }
                        completionBlock(url,nil)
                        self.user["Photo"] = downloadURL.absoluteString
                        print("image successfully updated")
                    }
                }else{
                    completionBlock(nil,error?.localizedDescription)
                }
            })
        } else{
            completionBlock(nil,"Image not converted")
        }
        
    }
}
